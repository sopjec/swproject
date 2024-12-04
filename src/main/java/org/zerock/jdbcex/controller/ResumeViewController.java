package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dto.ResumeDTO;
import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.ResumeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/resume_view")
public class ResumeViewController  extends HttpServlet {

    private final ResumeService resumeService = new ResumeService();

    // 자기소개서 조회 처리 (GET)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);

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
