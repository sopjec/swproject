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

@WebServlet("/api/generate-question")
public class GenerateQuestionServlet extends HttpServlet {
    // MariaDB 연결 정보
    private static final String DB_URL = "jdbc:mariadb://localhost:3306/merijob_db?useUnicode=true&characterEncoding=UTF-8&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1111";

    // OpenAI API 키

    private static final String GPT_API_KEY = System.getenv("GPT_API_KEY");

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
            // 1. MariaDB에서 질문과 답변 데이터를 가져옴
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

            if (resumeContent.length() == 0) {
                response.getWriter().write("{\"error\": \"No data found for resume_id: " + resumeId + "\"}");
                return;
            }

            // 2. OpenAI GPT API 호출
            String prompt = "다음 자소서 데이터를 바탕으로 면접 질문을 생성해 주세요:\n" + resumeContent.toString();
            String generatedQuestion = callOpenAI(prompt);

            // 3. 결과 반환
            response.getWriter().write("{\"question\": \"" + generatedQuestion + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    // OpenAI API 호출
    private String callOpenAI(String prompt) throws Exception {
        String apiUrl = "https://api.openai.com/v1/completions";
        HttpURLConnection connection = (HttpURLConnection) new URL(apiUrl).openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Authorization", "Bearer " + GPT_API_KEY);
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);

        String jsonInput = String.format(
                "{ \"model\": \"text-davinci-003\", \"prompt\": \"%s\", \"max_tokens\": 100, \"temperature\": 0.7 }",
                prompt
        );

        System.out.println("OpenAI 요청 JSON: " + jsonInput);

        try (OutputStream os = connection.getOutputStream()) {
            os.write(jsonInput.getBytes());
            os.flush();
        }

        int responseCode = connection.getResponseCode();
        System.out.println("OpenAI 응답 코드: " + responseCode);

        if (responseCode == 401) {
            throw new IOException("Unauthorized: API 키가 올바르지 않거나 인증 문제 발생");
        }

        BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"));
        StringBuilder response = new StringBuilder();
        String line;
        while ((line = br.readLine()) != null) {
            response.append(line.trim());
        }
        br.close();

        System.out.println("OpenAI 응답: " + response.toString());
        // OpenAI 응답 파싱
        return response.toString(); // 필요하면 JSON 파싱 후 가공
    }
}
