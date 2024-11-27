package org.zerock.jdbcex.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.ScrapService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/scrapStatus")
class ScrapStatusController extends HttpServlet {

    private ScrapService scrapService = new ScrapService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        UserDTO user = (UserDTO) session.getAttribute("loggedInUser");
        List<String> scrapedKeys = null;
        try {
            scrapedKeys = scrapService.getScrapedKeys(user.getId());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

        response.setContentType("application/json; charset=UTF-8");
        new ObjectMapper().writeValue(response.getWriter(), scrapedKeys);
    }

}
