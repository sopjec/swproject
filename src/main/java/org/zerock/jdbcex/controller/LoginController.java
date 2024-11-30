package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        String pwd = request.getParameter("pwd");

        // 로그인 처리
        UserDTO user = userService.loginUser(id, pwd);

        if (user != null) {
            // 로그인 성공 시 세션에 사용자 정보 저장
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user); // UserDTO 객체 저장
            session.setAttribute("id", user.getId());  // 사용자 ID 저장

            // 디버깅 로그 추가
            System.out.println("User successfully logged in: " + user.getId());

            response.sendRedirect("index.jsp"); // 메인 페이지로 리다이렉트
        } else {
            // 로그인 실패 처리
            request.setAttribute("loginError", true);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }

    }
}
