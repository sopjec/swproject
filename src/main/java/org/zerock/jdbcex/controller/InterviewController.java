package org.zerock.jdbcex.controller;

import lombok.var;
import org.zerock.jdbcex.dto.InterviewDTO;
import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.InterviewService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/interview")
public class InterviewController extends HttpServlet {

    private final InterviewService interviewService = new InterviewService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // 세션에서 사용자 정보 가져오기
        Object loggedInUser = session.getAttribute("loggedInUser");

        // UserDTO로 캐스팅 시도
        if (!(loggedInUser instanceof UserDTO)) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "잘못된 사용자 세션 데이터입니다.");
            return;
        }

        UserDTO user = (UserDTO) loggedInUser;

        try {
            // 로그인한 사용자 ID로 인터뷰 기록 가져오기
            var interviewList = interviewService.getInterviewsByUserId(user.getId());
            req.setAttribute("interviewList", interviewList);

            req.getRequestDispatcher("interview_view.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "면접 기록을 가져오는 중 오류가 발생했습니다.");
        }
    }

}
