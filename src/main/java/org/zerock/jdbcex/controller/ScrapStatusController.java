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
import java.util.Collections;
import java.util.List;

@WebServlet("/scrapStatus")
public class ScrapStatusController extends HttpServlet {

    private ScrapService scrapService = new ScrapService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);

        UserDTO user = (UserDTO) session.getAttribute("loggedInUser");
        List<String> scrapedKeys;

        try {
            scrapedKeys = scrapService.getScrapedKeys(user.getId());
            System.out.println("스크랩된 공고 키: " + scrapedKeys); // 디버깅 로그 추가
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        // 올바른 JSON 응답 반환
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        new ObjectMapper().writeValue(response.getWriter(), scrapedKeys);
    }
}
