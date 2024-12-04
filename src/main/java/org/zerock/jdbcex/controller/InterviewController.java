package org.zerock.jdbcex.controller;


import org.zerock.jdbcex.dto.InterviewQnADTO;
import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.InterviewQnAService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/interview")
public class InterviewController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // URL에서 전달된 resumeId 파라미터를 읽음
        String resumeId = req.getParameter("resumeId");
        System.out.println(resumeId);

        HttpSession session = req.getSession(false);

        if (resumeId == null || resumeId.isEmpty()) {
            // resumeId가 없는 경우 오류 페이지로 리다이렉트
            System.out.println("Resume ID is missing or invalid.");
            resp.sendRedirect("error.jsp");
            return;
        }

        System.out.println("Received Resume ID: " + resumeId);

        // resumeId를 요청 속성에 저장하여 JSP에서 사용 가능하도록 함
        req.setAttribute("resumeId", resumeId);

        // interview.jsp로 전달
        req.getRequestDispatcher("interview.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        InterviewQnAService interviewQnAService = new InterviewQnAService();
        InterviewQnADTO qna = new InterviewQnADTO();

        int interviewId = Integer.parseInt(req.getParameter("interviewId"));
        String question = req.getParameter("question");
        String answer = req.getParameter("answer");

        HttpSession session = req.getSession(false);

        // 사용자 정보 확인
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId(); // User ID 가져오기

        qna.setInterviewId(interviewId);
        qna.setQuestion(question);
        qna.setAnswer(answer);
        qna.setUser_id(userId);

        int num = interviewQnAService.insertQnA(qna);
        System.out.println(num + "행 추가되었습니다. ");

    }
}