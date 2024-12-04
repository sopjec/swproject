package org.zerock.jdbcex.servlet;

import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import org.json.JSONObject;
import org.json.JSONArray;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet("/api/generate-question")
public class GenerateQuestionServlet extends HttpServlet {

    private static final String GPT_API_KEY = System.getenv("GPT_API_KEY");

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            System.out.println("세션이 없거나 로그인된 사용자가 없습니다.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
            return;
        }

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId();
        System.out.println("로그인된 User ID: " + userId);

        String resumeId = request.getParameter("resumeId");
        if (resumeId == null || resumeId.isEmpty()) {
            System.out.println("resumeId가 전달되지 않았습니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
            return;
        }

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection()) {
            System.out.println("데이터베이스 연결 성공");

            StringBuilder resumeContent = getResumeContent(resumeId, conn);
            if (resumeContent.length() == 0) {
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "No data found for resume_id: " + resumeId);
                response.getWriter().write(errorResponse.toString());
                return;
            }

            System.out.println("DB 조회 결과: " + resumeContent.toString());

            String prompt = "다음 자소서 데이터를 바탕으로 최소 5개의 면접 질문을 생성해 주세요. 질문은 번호를 매겨 출력하세요:\n" + resumeContent.toString();
            String rawResponse = callOpenAI(prompt);
            List<String> questions = ensureMinimumQuestions(rawResponse, prompt);

            String resumeTitle = getResumeTitle(resumeId, conn);
            if (resumeTitle != null) {
                saveInterviewData(userId, resumeTitle, conn);
            } else {
                System.out.println("resumeTitle이 null입니다.");
            }

            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("questions", new JSONArray(questions));

            response.getWriter().write(jsonResponse.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
        }
    }

    private StringBuilder getResumeContent(String resumeId, Connection conn) throws SQLException {
        StringBuilder resumeContent = new StringBuilder();
        String query = "SELECT question, answer FROM resume_qna WHERE resume_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(resumeId));
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    resumeContent.append("Q: ").append(rs.getString("question"))
                            .append("\nA: ").append(rs.getString("answer"))
                            .append("\n\n");
                }
            }
        }
        return resumeContent;
    }

    private List<String> ensureMinimumQuestions(String rawResponse, String prompt) throws Exception {
        List<String> questions = Arrays.stream(rawResponse.split("\n"))
                .filter(q -> q.trim().matches("^\\d+\\.\\s+.*")) // 번호가 있는 질문 필터링
                .map(q -> q.replaceFirst("^\\d+\\.\\s+", "")) // 번호 제거
                .collect(Collectors.toList());

        int maxRetries = 3; // 최대 추가 호출 횟수
        int retries = 0;

        while (questions.size() < 5 && retries < maxRetries) {
            retries++;
            String additionalPrompt = "현재 질문은 " + questions.size() + "개입니다. 추가로 " + (5 - questions.size())
                    + "개의 질문을 생성해 주세요. 질문은 번호를 매겨 출력하세요.";
            String additionalResponse = callOpenAI(prompt + "\n" + additionalPrompt);

            List<String> additionalQuestions = Arrays.stream(additionalResponse.split("\n"))
                    .filter(q -> q.trim().matches("^\\d+\\.\\s+.*"))
                    .map(q -> q.replaceFirst("^\\d+\\.\\s+", ""))
                    .collect(Collectors.toList());

            for (String question : additionalQuestions) {
                if (!questions.contains(question)) {
                    questions.add(question);
                }
            }
        }

        while (questions.size() < 5) {
            questions.add("기본 질문 " + (questions.size() + 1));
        }

        return questions;
    }

    private void saveInterviewData(String userId, String resumeTitle, Connection conn) throws Exception {
        int interviewCount = getInterviewCount(userId, resumeTitle, conn);
        String interviewTitle = resumeTitle + "_" + interviewCount;
        String interviewDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date());
        String insertSQL = "INSERT INTO interview (user_id, title, interview_date) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, interviewTitle);
            pstmt.setString(3, interviewDate);
            pstmt.executeUpdate();
        }
    }

    private String getResumeTitle(String resumeId, Connection conn) throws SQLException {
        String query = "SELECT title FROM resume WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, Integer.parseInt(resumeId));
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("title");
                }
            }
        }
        return null;
    }

    private int getInterviewCount(String userId, String resumeTitle, Connection conn) throws SQLException {
        String query = "SELECT COUNT(*) FROM interview WHERE user_id = ? AND title LIKE ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, resumeTitle + "_%");
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) + 1;
                }
            }
        }
        return 1;
    }

    private String callOpenAI(String prompt) throws Exception {
        String apiUrl = "https://api.openai.com/v1/chat/completions";
        HttpURLConnection connection = (HttpURLConnection) new URL(apiUrl).openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Authorization", "Bearer " + GPT_API_KEY);
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);

        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "gpt-3.5-turbo");

        JSONArray messages = new JSONArray();
        messages.put(new JSONObject().put("role", "system").put("content", "너는 한국어로 답변하는 면접 질문 생성 AI이다."));
        messages.put(new JSONObject().put("role", "user").put("content", prompt));
        requestBody.put("messages", messages);
        requestBody.put("max_tokens", 1000);
        requestBody.put("temperature", 0.7);

        try (OutputStream os = connection.getOutputStream()) {
            os.write(requestBody.toString().getBytes("UTF-8"));
            os.flush();
        }

        int responseCode = connection.getResponseCode();
        if (responseCode != 200) {
            throw new IOException("OpenAI API 호출 실패");
        }

        try (BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"))) {
            StringBuilder responseString = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                responseString.append(line.trim());
            }

            JSONObject jsonResponse = new JSONObject(responseString.toString());
            return jsonResponse.getJSONArray("choices").getJSONObject(0).getJSONObject("message").getString("content");
        }
    }
}