package org.zerock.jdbcex.controller;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

@WebServlet("/aiCoaching")
public class AICoaching extends HttpServlet {

    private static final String GPT_API_URL = "https://api.openai.com/v1/chat/completions";
    private static final String GPT_API_KEY = System.getenv("GPT_API_KEY");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 요청 및 응답 기본 설정
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        // 세션 확인 (로그인 여부 체크)
        HttpSession session = req.getSession(false);
        // 로그인 확인
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write("세션이 만료 되었습니다.");
            return;
        }

        // 입력 JSON 읽기
        String body = req.getReader().lines().reduce("", (accumulator, actual) -> accumulator + actual);
        System.out.println("[DEBUG] Received Request Body: " + body); // 요청 바디 로그 출력

        JsonObject inputJson;
        try {
            inputJson = new com.google.gson.JsonParser().parse(body).getAsJsonObject();
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid JSON format\"}");
            return;
        }

        // 입력 텍스트 추출
        String inputText = inputJson.get("text").getAsString();
        if (inputText == null || inputText.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"No input text provided\"}");
            return;
        }

        // OpenAI 요청 데이터 생성
        JsonObject requestBody = new JsonObject();
        requestBody.addProperty("model", "gpt-4o-mini");
        requestBody.addProperty("max_tokens", 500);

        JsonArray messages = new JsonArray();

        JsonObject systemMessage = new JsonObject();
        systemMessage.addProperty("role", "system");
        systemMessage.addProperty("content", "자기소개서의 주요키워드 3가지와 추가 수정할 내용을 간략하게 알려줘");
        messages.add(systemMessage);

        JsonObject userMessage = new JsonObject();
        userMessage.addProperty("role", "user");
        userMessage.addProperty("content", inputText);
        messages.add(userMessage);

        requestBody.add("messages", messages);

        // OpenAI API 호출
        try {
            System.out.println("[DEBUG] Sending request to GPT API with body: " + requestBody);

            URL url = new URL(GPT_API_URL);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Authorization", "Bearer " + GPT_API_KEY);
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);

            // 요청 본문 전송
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = requestBody.toString().getBytes("UTF-8");
                os.write(input, 0, input.length);
            }

            // 응답 코드 확인
            int responseCode = connection.getResponseCode();
            System.out.println("[DEBUG] GPT API response code: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) {
                // 응답 읽기
                try (BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"))) {
                    StringBuilder responseBuilder = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        responseBuilder.append(responseLine.trim());
                    }

                    JsonObject responseJson = new com.google.gson.JsonParser().parse(responseBuilder.toString()).getAsJsonObject();
                    String replacedText = responseJson
                            .getAsJsonArray("choices")
                            .get(0).getAsJsonObject()
                            .getAsJsonObject("message")
                            .get("content")
                            .getAsString();

                    // 결과 JSON 작성
                    JsonObject resultJson = new JsonObject();
                    resultJson.addProperty("replacedText", replacedText);

                    System.out.println("[DEBUG] Final Response to Client: " + resultJson.toString());
                    resp.getWriter().write(resultJson.toString());
                }
            } else {
                System.err.println("[ERROR] GPT API call failed with status code: " + responseCode);
                resp.setStatus(HttpURLConnection.HTTP_INTERNAL_ERROR);
                resp.getWriter().write("{\"error\":\"GPT API 호출 실패\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpURLConnection.HTTP_INTERNAL_ERROR);
            resp.getWriter().write("{\"error\":\"서버 내부 오류\"}");
        }
    }
}