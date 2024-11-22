package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.service.ScrapService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/scrap")
public class ScrapController extends HttpServlet {

    private final ScrapService scrapService = new ScrapService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = (String) request.getSession().getAttribute("loggedInUser");

        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 상태 반환
            return;
        }

        String scrapKey = request.getParameter("scrapKey");

        if (scrapKey == null || scrapKey.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Invalid scrapKey");
            return;
        }

        try {
            new ScrapService().addScrap(userId, scrapKey);
            response.getWriter().write("스크랩이 성공적으로 저장되었습니다!");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Failed to save scrap");
            e.printStackTrace();
        }
    }

}