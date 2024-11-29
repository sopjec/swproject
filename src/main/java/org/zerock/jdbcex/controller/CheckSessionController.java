package org.zerock.jdbcex.controller;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/checkSession")
public class CheckSessionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false); // 세션이 없으면 null 반환
        boolean isLoggedIn = (session != null && session.getAttribute("loggedInUser") != null);

        // JSON 형식으로 응답
        response.getWriter().write("{\"isLoggedIn\": " + isLoggedIn + "}");
    }
}
