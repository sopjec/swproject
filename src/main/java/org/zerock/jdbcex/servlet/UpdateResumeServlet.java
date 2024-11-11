package org.zerock.jdbcex.servlet;

import org.zerock.jdbcex.dao.ResumeDAO;
import org.zerock.jdbcex.model.Resume;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/updateResume")
public class UpdateResumeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int introId = Integer.parseInt(request.getParameter("introId"));
        String title = request.getParameter("title");
        String[] questions = request.getParameterValues("questions");
        String[] answers = request.getParameterValues("answers");

        ResumeDAO resumeDAO = new ResumeDAO();
        try {
            // 제목 업데이트
            resumeDAO.updateIntroductionTitle(introId, title);

            // 질문과 답변 업데이트
            for (int i = 0; i < questions.length; i++) {
                String question = questions[i];
                String answer = answers[i];
                resumeDAO.updateResume(introId, question, answer);
            }
            response.sendRedirect("resume_view.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "업데이트 중 오류가 발생했습니다.");
        }
    }
}
