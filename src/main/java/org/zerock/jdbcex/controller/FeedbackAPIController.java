package org.zerock.jdbcex.controller;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import org.json.JSONArray;
import org.json.JSONObject;
import org.zerock.jdbcex.service.InterviewService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet("/api/generate-feedback")
public class FeedbackAPIController extends HttpServlet {

    private static final String GPT_API_KEY = System.getenv("GPT_API_KEY");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // JSON 요청 본문 읽기
            StringBuilder jsonBuilder = new StringBuilder();
            try (BufferedReader reader = req.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonBuilder.append(line);
                }
            }

            // JSON 데이터 파싱
            JSONObject jsonObject = new JSONObject(jsonBuilder.toString());
            int interviewId = jsonObject.getInt("interviewId");
            JSONArray data = jsonObject.getJSONArray("data"); // 질문과 답변 배열

            // 답변이 모두 없는지 체크
            boolean allAnswersEmpty = true;

            // 질문과 답변 데이터를 문자열로 조합
            StringBuilder promptBuilder = new StringBuilder("다음은 면접 질문과 답변입니다. 답변에 대한 피드백을 작성해 주세요:\n");
            for (int i = 0; i < data.length(); i++) {
                JSONObject qa = data.getJSONObject(i);
                String question = qa.getString("question");
                String answer = qa.getString("answer");

                promptBuilder.append("질문 ").append(i + 1).append(": ").append(question).append("\n");

                if (answer.trim().isEmpty()) {
                    // 답변이 비어있을 경우 기본 메시지 추가
                    promptBuilder.append("답변이 없어 피드백을 생성하지 못했습니다.\n\n");
                } else {
                    promptBuilder.append("답변: ").append(answer).append("\n\n");
                    allAnswersEmpty = false;
                }
            }

            // 모든 답변이 비어 있는 경우 피드백 생성 중단
            if (allAnswersEmpty) {
                JSONObject responseJson = new JSONObject();
                responseJson.put("feedback", "답변이 없어 피드백을 생성하지 못했습니다.");
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write(responseJson.toString());
                return;
            }

            // GPT API 호출
            String feedback = callOpenAI(promptBuilder.toString());

            // 데이터베이스 업데이트
            InterviewService interviewService = new InterviewService();

            interviewService.updateFeedback(interviewId, feedback);

            // 성공 응답
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            JSONObject responseJson = new JSONObject();
            responseJson.put("feedback", feedback);
            resp.getWriter().write(responseJson.toString());
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
        }
    }

    private String callOpenAI(String prompt) throws IOException {
        String apiUrl = "https://api.openai.com/v1/chat/completions";

        // OpenAI 요청 데이터 생성
        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("model", "gpt-3.5-turbo");
        requestBody.addProperty("max_tokens", 500);
        requestBody.addProperty("temperature", 0.7); // 창의성 정도
        requestBody.addProperty("top_p", 1.0); // 다양성 설정
        requestBody.addProperty("frequency_penalty", 0.2); // 반복 방지
        requestBody.addProperty("presence_penalty", 0.5); // 새로운 아이디어 생성 유도

        // 메시지 추가
        JsonArray messages = new JsonArray();

        // 시스템 메시지 설정
        JsonObject systemMessage = new JsonObject();
        systemMessage.addProperty("role", "system");
        systemMessage.addProperty("content", "당신은 면접 질문에 대한 답변에 상세하고 유익한 피드백을 제공하는 도우미입니다.");
        messages.add(systemMessage);

        // 사용자 메시지 추가
        JsonObject userMessage = new JsonObject();
        userMessage.addProperty("role", "user");
        userMessage.addProperty("content", prompt);
        messages.add(userMessage);

        requestBody.add("messages", messages);

        // HTTP 요청
        URL url = new URL(apiUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Authorization", "Bearer " + GPT_API_KEY); // 환경변수에서 API 키 가져옴
        connection.setRequestProperty("Content-Type", "application/json");
        connection.setDoOutput(true);

        // 요청 본문 전송
        try (OutputStream os = connection.getOutputStream()) {
            os.write(requestBody.toString().getBytes("UTF-8"));
            os.flush();
        }

        // 응답 읽기
        StringBuilder responseBuilder = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
            String line;
            while ((line = reader.readLine()) != null) {
                responseBuilder.append(line);
            }
        }

        // 응답 처리
        JsonObject jsonResponse = new com.google.gson.JsonParser().parse(responseBuilder.toString()).getAsJsonObject();
        JsonArray choices = jsonResponse.getAsJsonArray("choices");

        if (choices != null && choices.size() > 0) {
            JsonObject firstChoice = choices.get(0).getAsJsonObject();
            return firstChoice.getAsJsonObject("message").get("content").getAsString().trim();
        }

        return "GPT에서 피드백을 생성하지 못했습니다.";
    }
}
