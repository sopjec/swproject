package org.zerock.jdbcex.servlet;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONObject;
import org.json.JSONArray;
import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

@WebServlet("/api/generate-question")
public class GenerateQuestionServlet extends HttpServlet {

    private static final String GPT_API_KEY = System.getenv("GPT_API_KEY");

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // 세션에서 UserDTO 가져오기
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            System.out.println("세션이 없거나 로그인된 사용자가 없습니다.");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized 상태 반환
            return;
        }

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId(); // UserDTO에서 userId 가져오기
        System.out.println("로그인된 User ID: " + userId);

        String resumeId = request.getParameter("resumeId"); // 요청에서 resume_id를 가져옴
        System.out.println("받은 resumeId: " + resumeId);

        if (userId == null || userId.isEmpty()) {
            System.out.println("userID가 전달되지 않았습니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request 상태 반환
            return;
        }

        if (resumeId == null || resumeId.isEmpty()) {
            System.out.println("resumeId가 전달되지 않았습니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request 상태 반환
            return;
        }

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection()) {
            System.out.println("데이터베이스 연결 성공");

            // MariaDB에서 질문과 답변 데이터를 가져옴
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

            if (resumeContent.length() == 0) {
                System.out.println("데이터베이스에서 가져온 데이터가 없습니다: resumeId = " + resumeId);
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "No data found for resume_id: " + resumeId);
                response.getWriter().write(errorResponse.toString());
                return;
            }

            System.out.println("DB 조회 결과: " + resumeContent.toString());

            // 면접 데이터 저장
            String resumeTitle = getResumeTitle(resumeId, conn);
            if (resumeTitle != null) {
                saveInterviewData(userId, resumeTitle, conn);
            } else {
                System.out.println("resumeTitle이 null입니다.");
            }

            // OpenAI GPT API 호출 및 결과 반환
            String prompt = "다음 자소서 데이터를 바탕으로 면접 질문을 생성해 주세요:\n" + resumeContent.toString();
            String generatedQuestion = callOpenAI(prompt);

            JSONObject jsonResponse = new JSONObject();
            jsonResponse.put("question", generatedQuestion);

            response.getWriter().write(jsonResponse.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private String callOpenAI(String prompt) throws Exception {
        // OpenAI API 호출 로직
        String apiUrl = "https://api.openai.com/v1/chat/completions";
        HttpURLConnection connection = (HttpURLConnection) new URL(apiUrl).openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Authorization", "Bearer " + GPT_API_KEY);
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);

        JSONObject requestBody = new JSONObject();
        requestBody.put("model", "gpt-3.5-turbo");

        JSONArray messages = new JSONArray();
        JSONObject systemMessage = new JSONObject();
        systemMessage.put("role", "system");
        systemMessage.put("content", "너는 한국어로 대답하는 면접 질문 생성 AI이다.");
        messages.put(systemMessage);

        JSONObject userMessage = new JSONObject();
        userMessage.put("role", "user");
        userMessage.put("content", prompt);
        messages.put(userMessage);

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

    private String getResumeTitle(String resumeId, Connection conn) throws Exception {
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

    private void saveInterviewData(String userId, String resumeTitle, Connection conn) throws Exception {
        String interviewTitle = resumeTitle + " - 면접 " + getInterviewCount(userId, resumeTitle, conn);
        String interviewDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

        String insertSQL = "INSERT INTO interview (user_id, title, interview_date) VALUES (?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(insertSQL, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, interviewTitle);
            pstmt.setString(3, interviewDate);
            pstmt.executeUpdate();
        }
    }

    private int getInterviewCount(String userId, String resumeTitle, Connection conn) throws Exception {
        String query = "SELECT COUNT(*) FROM interview WHERE user_id = ? AND title LIKE ?";
        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, resumeTitle + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) + 1;
                }
            }
        }
        return 1;
    }
}
