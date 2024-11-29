package org.zerock.jdbcex.servlet;

import org.zerock.jdbcex.dao.ResumeDAO;
import org.zerock.jdbcex.model.Resume;
import org.zerock.jdbcex.dto.UserDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/resume")
public class ResumeServlet extends HttpServlet {  // 클래스의 시작
    private ResumeDAO resumeDAO = new ResumeDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            System.out.println("No user logged in, redirecting to login page.");
            response.sendRedirect("login.jsp");
            return;
        }

        String userId = loggedInUser.getId();
        System.out.println("User ID from session: " + userId);

        String title = request.getParameter("title");
        String[] questions = request.getParameterValues("question");
        String[] answers = request.getParameterValues("answer");

        System.out.println("Title: " + title);
        if (questions != null) {
            for (String question : questions) {
                System.out.println("Question: " + question);
            }
        }
        if (answers != null) {
            for (String answer : answers) {
                System.out.println("Answer: " + answer);
            }
        }

        if (userId == null || userId.trim().isEmpty() || title == null || title.trim().isEmpty() || questions == null || answers == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid input. Please make sure all fields are filled.");
            return;
        }

        try {
            int introId = resumeDAO.insertIntroduction(userId, title);

            for (int i = 0; i < questions.length; i++) {
                String question = questions[i];
                String answer = answers[i];

                if (question == null || question.trim().isEmpty() || answer == null || answer.trim().isEmpty()) {
                    continue;
                }

                Resume resume = new Resume();
                resume.setIntroId(introId);
                resume.setUserId(userId);
                resume.setQuestion(question);
                resume.setAnswer(answer);
                resumeDAO.insertResume(resume);
            }
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("Resume successfully saved.");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("An error occurred while saving the resume.");
        }
    }
}  // 클래스의 끝
