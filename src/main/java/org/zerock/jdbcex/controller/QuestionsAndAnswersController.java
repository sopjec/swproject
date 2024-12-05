package org.zerock.jdbcex.controller;

import org.json.JSONArray;
import org.json.JSONObject;
import org.zerock.jdbcex.dto.InterviewQnADTO;
import org.zerock.jdbcex.service.InterviewQnAService;
import org.zerock.jdbcex.service.InterviewService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/api/get-questions-and-answers")
public class QuestionsAndAnswersController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // 요청 파라미터에서 interviewId 가져오기
            String interviewIdParam = req.getParameter("interviewId");
            if (interviewIdParam == null || interviewIdParam.isEmpty()) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
                return;
            }

            int interviewId = Integer.parseInt(interviewIdParam);

            // 데이터베이스에서 질문과 답변 가져오기
            InterviewQnAService qnAService = new InterviewQnAService();
            List<InterviewQnADTO> questionsAndAnswers = qnAService.getQuestionsAndAnswers(interviewId);

            // JSON 응답 생성
            JSONArray jsonArray = new JSONArray();
            for (InterviewQnADTO qa : questionsAndAnswers) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("question", qa.getQuestion());
                jsonObject.put("answer", qa.getAnswer());
                jsonArray.put(jsonObject);
            }

            // 응답 반환
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.getWriter().write(jsonArray.toString());
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
        }
    }
}
