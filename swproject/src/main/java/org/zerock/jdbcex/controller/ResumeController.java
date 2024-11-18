package org.zerock.jdbcex.controller;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import org.zerock.jdbcex.dto.ResumeDTO;
import org.zerock.jdbcex.dto.ResumeQnaDTO;
import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.ResumeQnaService;
import org.zerock.jdbcex.service.ResumeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;

@WebServlet("/resume")
public class ResumeController extends HttpServlet {

    private final ResumeService resumeService = new ResumeService();
    private final ResumeQnaService resumeQnaService = new ResumeQnaService();

    private static final String GPT_API_URL = "https://api.openai.com/v1/chat/completions";
    private static final String GPT_API_KEY = "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"; // OpenAI API 키 입력

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId();

        String title = req.getParameter("title");
        String[] questions = req.getParameterValues("question");
        String[] answers = req.getParameterValues("answer");

        try {
            ResumeDTO resume = new ResumeDTO();
            resume.setTitle(title);
            resume.setUserId(userId);
            resumeService.addResume(resume);

            if (questions != null && answers != null) {
                for (int i = 0; i < questions.length; i++) {
                    ResumeQnaDTO qna = new ResumeQnaDTO();
                    qna.setResumeId(resume.getId());
                    qna.setQuestion(questions[i]);
                    qna.setAnswer(answers[i]);
                    resumeQnaService.addQna(qna);
                }
            }

            resp.sendRedirect("resume");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "데이터 저장 중 오류가 발생했습니다.");
            req.getRequestDispatcher("error.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html; charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId();

        try {
            List<ResumeDTO> resumes = resumeService.getResumesByUserId(userId);
            req.setAttribute("resumes", resumes);
            req.getRequestDispatcher("resume_view.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터 조회 중 오류가 발생했습니다.");
        }
    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String body = req.getReader().lines().reduce("", (accumulator, actual) -> accumulator + actual);

        JsonObject inputJson = new com.google.gson.JsonParser().parse(body).getAsJsonObject();
        String inputText = inputJson.get("text").getAsString();

        if (inputText == null || inputText.trim().isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\":\"No input text provided\"}");
            return;
        }

        try {
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

                    resp.setContentType("application/json; charset=UTF-8");
                    resp.getWriter().write(resultJson.toString());
                }
            } else {
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"error\":\"GPT API 호출 실패\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\":\"GPT API 호출 실패\"}");
        }
    }
}
