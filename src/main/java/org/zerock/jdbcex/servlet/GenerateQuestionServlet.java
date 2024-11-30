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

@WebServlet("/api/generate-question")
public class GenerateQuestionServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mariadb://localhost:3007/merijob_db?useUnicode=true&characterEncoding=UTF-8&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "abcd980225*";
    private static final String OPENAI_API_KEY;

    static {
        Dotenv dotenv = Dotenv.configure()
                .directory("C:/Users/igaeu/IdeaProjects/swproject") // .env 파일 경로
                .load();
        OPENAI_API_KEY = dotenv.get("OPENAI_API_KEY");
        System.out.println("로드된 OpenAI API 키: " + OPENAI_API_KEY);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String resumeId = request.getParameter("resumeId");
        if (resumeId == null || resumeId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"resumeId가 전달되지 않았습니다.\"}");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            StringBuilder resumeContent = new StringBuilder();
            String query = "SELECT question, answer FROM resume_qna WHERE resume_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, Integer.parseInt(resumeId));
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                resumeContent.append("Q: ").append(rs.getString("question"))
                        .append("\nA: ").append(rs.getString("answer"))
                        .append("\n\n");
            }
            rs.close();

            if (resumeContent.length() == 0) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("{\"error\":\"해당 resumeId로 데이터를 찾을 수 없습니다.\"}");
                return;
            }

            String prompt = "다음 자소서 데이터를 바탕으로 면접 질문을 생성해 주세요:\n" + resumeContent.toString();
            String generatedQuestion = callOpenAI(prompt);

            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("question", generatedQuestion);

            response.getWriter().write(jsonResponse.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"서버 내부 오류 발생\"}");
        }
    }

    private String callOpenAI(String prompt) throws Exception {
        String apiUrl = "https://api.openai.com/v1/chat/completions";
        HttpURLConnection connection = (HttpURLConnection) new URL(apiUrl).openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Authorization", "Bearer " + OPENAI_API_KEY);
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);

        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "gpt-3.5-turbo");

        JSONObject systemMessage = new JSONObject();
        systemMessage.put("role", "system");
        systemMessage.put("content", "너는 한국어로 대답하는 면접 질문 생성 AI이다.");

        JSONObject userMessage = new JSONObject();
        userMessage.put("role", "user");
        userMessage.put("content", prompt + "\n\n모든 질문을 한국어로 작성해주세요.");

        requestBody.put("messages", new org.json.JSONArray().put(systemMessage).put(userMessage));
        requestBody.put("max_tokens", 1000);
        requestBody.put("temperature", 0.7);

        try (OutputStream os = connection.getOutputStream()) {
            os.write(requestBody.toString().getBytes("UTF-8"));
            os.flush();
        }

        int responseCode = connection.getResponseCode();
        if (responseCode != 200) {
            try (BufferedReader errorReader = new BufferedReader(new InputStreamReader(connection.getErrorStream(), "UTF-8"))) {
                StringBuilder errorResponse = new StringBuilder();
                String errorLine;
                while ((errorLine = errorReader.readLine()) != null) {
                    errorResponse.append(errorLine.trim());
                }
                throw new IOException("OpenAI API 호출 실패: " + errorResponse.toString());
            }
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"))) {
            StringBuilder responseString = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                responseString.append(line.trim());
            }

            JSONObject jsonResponse = new JSONObject(responseString.toString());
            return jsonResponse.getJSONArray("choices")
                    .getJSONObject(0)
                    .getJSONObject("message")
                    .getString("content");
        }
    }
}
