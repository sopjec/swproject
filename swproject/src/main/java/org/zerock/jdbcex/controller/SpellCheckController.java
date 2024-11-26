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

@WebServlet("/spellcheck")
public class SpellCheckController extends HttpServlet {

    private static final String GPT_API_URL = "https://api.openai.com/v1/chat/completions";
    private static final String GPT_API_KEY = "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"; // OpenAI API 키 입력

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 디버깅: 초기 요청 상태 로그
        System.out.println("[DEBUG] Received POST request at /spellcheck");

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        // 세션 확인
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            System.out.println("[DEBUG] Session not found or user not logged in");
            resp.sendRedirect("login.jsp");
            return;
        }

        // 요청 본문 읽기
        String body = req.getReader().lines().reduce("", (accumulator, actual) -> accumulator + actual);
        System.out.println("[DEBUG] Request body: " + body);

        JsonObject inputJson;
        String inputText;
        try {
            inputJson = new com.google.gson.JsonParser().parse(body).getAsJsonObject();
            inputText = inputJson.get("text").getAsString();
        } catch (Exception e) {
            System.out.println("[ERROR] Failed to parse request body: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"Invalid request body\"}");
            return;
        }

        if (inputText == null || inputText.trim().isEmpty()) {
            System.out.println("[DEBUG] Empty or null input text");
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"No input text provided\"}");
            return;
        }

        try {
            // OpenAI API 요청 구성
            JsonObject requestBody = new JsonObject();
            requestBody.addProperty("model", "gpt-4-turbo");
            requestBody.addProperty("max_tokens", 100);

            JsonArray messages = new JsonArray();
            JsonObject systemMessage = new JsonObject();
            systemMessage.addProperty("role", "system");
            systemMessage.addProperty("content", "자기소개서에 적합한 어휘이면서, 문맥에 맞고 의미는 변하지 않도록 하며, 고급스럽고 직무에 적합한 단어로 교체해줘");
            messages.add(systemMessage);

            JsonObject userMessage = new JsonObject();
            userMessage.addProperty("role", "user");
            userMessage.addProperty("content", inputText);
            messages.add(userMessage);

            requestBody.add("messages", messages);

            System.out.println("[DEBUG] Sending request to GPT API with body: " + requestBody);

            // HTTP 요청
            URL url = new URL(GPT_API_URL);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Authorization", "Bearer " + GPT_API_KEY);
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setDoOutput(true);

            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = requestBody.toString().getBytes("UTF-8");
                os.write(input, 0, input.length);
            }

            int responseCode = connection.getResponseCode();
            System.out.println("[DEBUG] GPT API response code: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream(), "UTF-8"))) {
                    StringBuilder responseBuilder = new StringBuilder();
                    String responseLine;
                    while ((responseLine = br.readLine()) != null) {
                        responseBuilder.append(responseLine.trim());
                    }

                    System.out.println("[DEBUG] GPT API response: " + responseBuilder);

                    JsonObject responseJson = new com.google.gson.JsonParser().parse(responseBuilder.toString()).getAsJsonObject();
                    String replacedText = responseJson
                            .getAsJsonArray("choices")
                            .get(0).getAsJsonObject()
                            .getAsJsonObject("message")
                            .get("content")
                            .getAsString();

                    JsonObject resultJson = new JsonObject();
                    resultJson.addProperty("replacedText", replacedText);

                    resp.getWriter().write(resultJson.toString());
                }
            } else {
                System.out.println("[ERROR] GPT API call failed with status code: " + responseCode);
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"error\":\"GPT API 호출 실패\"}");
            }
        } catch (Exception e) {
            System.out.println("[ERROR] Exception during GPT API call: " + e.getMessage());
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"GPT API 호출 실패\"}");
        }
    }
}
