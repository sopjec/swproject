package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dto.ResumeDTO;
import org.zerock.jdbcex.dto.ResumeQnaDTO;
import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.ResumeQnaService;
import org.zerock.jdbcex.service.ResumeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/resume")
public class ResumeController extends HttpServlet {

    private final ResumeService resumeService = new ResumeService();
    private final ResumeQnaService resumeQnaService = new ResumeQnaService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.html");
            return;
        }

        // UserDTO 객체에서 userId 가져오기
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId(); // UserDTO의 userId 필드 사용

        String title = req.getParameter("title");
        String[] questions = req.getParameterValues("question");
        String[] answers = req.getParameterValues("answer");

        try {
            // Resume 저장
            ResumeDTO resume = new ResumeDTO();
            resume.setTitle(title);
            resume.setUserId(userId);
            resumeService.addResume(resume);

            // 질문/답변 저장
            if (questions != null && answers != null) {
                for (int i = 0; i < questions.length; i++) {
                    ResumeQnaDTO qna = new ResumeQnaDTO();
                    qna.setResumeId(resume.getId());
                    qna.setQuestion(questions[i]);
                    qna.setAnswer(answers[i]);
                    resumeQnaService.addQna(qna);
                }
            }

            resp.sendRedirect("resume_view.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "데이터 저장 중 오류가 발생했습니다.");
            req.getRequestDispatcher("error.jsp").forward(req, resp);
        }
    }

    // 자기소개서 조회 처리 (GET)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.html");
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

}