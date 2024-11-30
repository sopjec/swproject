package org.zerock.jdbcex.servlet;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import io.github.cdimascio.dotenv.Dotenv;
import org.json.JSONObject;
import org.json.JSONArray;

@WebServlet("/api/generate-question")
public class GenerateQuestionServlet extends HttpServlet {
    // MariaDB 연결 정보
    private static final String DB_URL = "jdbc:mariadb://localhost:3306/merijob_db?useUnicode=true&characterEncoding=UTF-8&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1111";
    // OpenAI API 키
    private static final String OPENAI_API_KEY;

    static {
	Dotenv dotenv = Dotenv.configure()
            .directory("C:/Users/wlsek/IdeaProjects/project") // .env 파일의 디렉토리 경로
            .load();

	OPENAI_API_KEY = dotenv.get("OPENAI_API_KEY");
    // OpenAI API 키 확인용 로그
    System.out.println("로드된 OpenAI API 키: " + OPENAI_API_KEY);
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String resumeId = request.getParameter("resumeId"); // 요청에서 resume_id를 가져옴
        System.out.println("받은 resumeId: " + resumeId); // 디버깅용 로그 추가

        if (resumeId == null || resumeId.isEmpty()) {
            System.out.println("resumeId가 전달되지 않았습니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            System.out.println("데이터베이스 연결 성공"); // 확인용
            // MariaDB에서 질문과 답변 데이터를 가져옴
            StringBuilder resumeContent = new StringBuilder();
            String query = "SELECT question, answer FROM resume_qna WHERE resume_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(resumeId));
            ResultSet rs = pstmt.executeQuery();
            System.out.println("데이터베이스 연결 성공");
            System.out.println("SQL 쿼리 실행: " + query + " / resumeId: " + resumeId);

            while (rs.next()) {
                resumeContent.append("Q: ").append(rs.getString("question"))
                        .append("\nA: ").append(rs.getString("answer"))
                        .append("\n\n");
            }
            rs.close();

            System.out.println("DB 조회 결과: " + resumeContent.toString()); // 확인용

            if (resumeContent.length() == 0) {
                System.out.println("데이터베이스에서 가져온 데이터가 없습니다: resumeId = " + resumeId); //확인용
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "No data found for resume_id: " + resumeId);
                response.getWriter().write(errorResponse.toString());
                return;
            } else{
                System.out.println("데이터베이스에서 가져온 데이터: " + resumeContent.toString());
            }

            // OpenAI GPT API 호출
            String prompt = "다음 자소서 데이터를 바탕으로 면접 질문을 생성해 주세요:\n" + resumeContent.toString();
            String generatedQuestion = callOpenAI(prompt);

            // 클라이언트에 반환할 JSON 데이터 생성
            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("question", generatedQuestion);

            response.getWriter().write(jsonResponse.toString()); // JSON 데이터 반환
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


    // OpenAI API 호출
    private String callOpenAI(String prompt) throws Exception {
        System.out.println("OpenAI API 호출 시작. 전달할 프롬프트: " + prompt); //호출여부, 응답상태 확인
        String apiUrl = "https://api.openai.com/v1/chat/completions";
        HttpURLConnection connection = (HttpURLConnection) new URL(apiUrl).openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Authorization", "Bearer " + OPENAI_API_KEY);
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);

        // JSON 객체 생성
        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "gpt-3.5-turbo");

        JSONArray messages = new JSONArray();

        // GPT 모델 역할 설명
        JSONObject systemMessage = new JSONObject();
        systemMessage.put("role", "system");
        systemMessage.put("content", "너는 한국어로 대답하는 면접 질문 생성 AI이다.");
        messages.put(systemMessage);

        // 사용자 메시지: 요청 프롬프트
        JSONObject userMessage = new JSONObject();
        userMessage.put("role", "user");
        userMessage.put("content", prompt + "\n\n모든 질문을 한국어로 작성해주세요.");
        messages.put(userMessage);

        requestBody.put("messages", messages);
        requestBody.put("max_tokens", 1000);
        requestBody.put("temperature", 0.7);

        // OpenAI API 요청 데이터 확인
        System.out.println("OpenAI 요청 데이터: " + requestBody.toString());

        // JSON 데이터 전송
        try (OutputStream os = connection.getOutputStream()) {
            os.write(requestBody.toString().getBytes("UTF-8"));
            os.flush();
        }

        int responseCode = connection.getResponseCode();
        System.out.println("OpenAI 응답 코드: " + responseCode);

        if (responseCode != 200) {
            // OpenAI 응답 오류 처리
            BufferedReader errorReader = new BufferedReader(new InputStreamReader(connection.getErrorStream(), "UTF-8"));
            StringBuilder errorResponse = new StringBuilder();
            String errorLine;
            while ((errorLine = errorReader.readLine()) != null) {
                errorResponse.append(errorLine.trim());
            }
            errorReader.close();
            System.out.println("OpenAI 오류 응답: " + errorResponse.toString());
            throw new IOException("OpenAI API 호출 실패: " + errorResponse.toString());
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
        StringBuilder responseString = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            responseString.append(line.trim());
        }
        br.close();

        System.out.println("OpenAI 응답: " + responseString.toString());

        // JSON 응답 파싱
        JSONObject jsonResponse = new JSONObject(responseString.toString());
        String question = jsonResponse
                .getJSONArray("choices")
                .getJSONObject(0)
                .getJSONObject("message")
                .getString("content");

        System.out.println("추출된 질문: " + question);

        return question;
    }
}
