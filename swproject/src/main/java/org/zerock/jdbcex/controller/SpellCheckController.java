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
    private static final String GPT_API_KEY = System.getenv("GPT_API_KEY");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // 입력 JSON 파싱
        String body = req.getReader().lines().reduce("", (accumulator, actual) -> accumulator + actual);
        JsonObject inputJson = new com.google.gson.JsonParser().parse(body).getAsJsonObject();
        String inputText = inputJson.get("text").getAsString();

        if (inputText == null || inputText.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"No input text provided\"}");
            return;
        }

        try {
            // OpenAI 요청 JSON 생성
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
            userMessage.addProperty("content", inputText); // inputText를 순수 텍스트로 추가
            messages.add(userMessage);

            requestBody.add("messages", messages);

            // 요청 로그
            System.out.println("[DEBUG] Sending request to GPT API with body: " + requestBody);

            // OpenAI API 호출
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
