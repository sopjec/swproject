package org.zerock.jdbcex.controller;

import com.google.gson.Gson;
import org.zerock.jdbcex.service.ResumeQnaService;
import org.zerock.jdbcex.service.ResumeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;
import java.util.Map;
@WebServlet(name = "ResumeUpdateController", urlPatterns = {"/updateAnswer", "/updateAnswers"})
public class ResumeUpdateController extends HttpServlet {

    private final ResumeQnaService resumeQnaService = new ResumeQnaService(); // ResumeQnaService 객체 생성
    private final ResumeService resumeService = new ResumeService(); // ResumeService 객체 생성

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        String path = req.getServletPath(); // 요청 경로 확인
        Gson gson = new Gson();

        // 요청 Body 읽기
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        String requestBody = sb.toString();

        try {
            if (path.equals("/updateAnswer")) {
                // 개별 답변 수정
                Map<String, Object> payload = gson.fromJson(requestBody, Map.class);
                int id = Integer.parseInt(payload.get("id").toString()); // resume_qna.id
                String newTitle = payload.get("newTitle") != null ? payload.get("newTitle").toString() : null;
                String answer = payload.get("answer").toString();

                // 제목 업데이트
                if (newTitle != null) {
                    resumeService.updateTitleById(id, newTitle);
                }

                // 답변 업데이트
                resumeQnaService.updateAnswerById(id, answer);

                // 성공 응답
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("{\"message\": \"Answer updated successfully\"}");
            } else if (path.equals("/updateAnswers")) {
                // 전체 답변 및 제목 수정
                Map<String, Object> payload = gson.fromJson(requestBody, Map.class);
                String newTitle = payload.get("title") != null ? payload.get("title").toString() : null;
                List<Map<String, Object>> answers = (List<Map<String, Object>>) payload.get("answers");

                // 제목 업데이트
                if (newTitle != null) {
                    int resumeId = Integer.parseInt(answers.get(0).get("id").toString()); // ID로 resume를 식별
                    resumeService.updateTitleById(resumeId, newTitle);
                }

                // 답변 업데이트 처리
                for (Map<String, Object> answerMap : answers) {
                    int id = Integer.parseInt(answerMap.get("id").toString()); // resume_qna.id
                    String answer = answerMap.get("answer").toString();
                    resumeQnaService.updateAnswerById(id, answer);
                }

                // 성공 응답
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.getWriter().write("{\"message\": \"All answers and title updated successfully\"}");
            }
        } catch (Exception e) {
            // 에러 응답
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"message\": \"Error updating answer(s) and/or title\"}");
            e.printStackTrace();
        }
    }
}
