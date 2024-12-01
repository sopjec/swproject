package org.zerock.jdbcex.controller;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.zerock.jdbcex.service.UserService;
import org.zerock.jdbcex.dto.UserDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/updateProfileImage")
public class ProfileUpdateServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // JSON 데이터 읽기
        StringBuilder jsonBuilder = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                jsonBuilder.append(line);
            }
        }

        // JSON 데이터 파싱
        String jsonData = jsonBuilder.toString();
        JsonObject jsonObject;
        try {
            jsonObject = JsonParser.parseString(jsonData).getAsJsonObject();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"Invalid JSON format\"}");
            return;
        }

        String imageUrl = jsonObject.get("imageUrl").getAsString();

        // 세션에서 사용자 ID 가져오기
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("id");
        System.out.println("User ID from session: " + userId);


        // 세션에 ID가 없거나 이미지 URL이 비어 있으면 오류 반환
        if (userId == null || userId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false, \"message\": \"User not logged in\"}");
            System.out.println("User not logged in: session ID is null or empty");
            return;
        }

        // 데이터베이스 업데이트
        boolean isUpdated = userService.updateProfileImage(userId, imageUrl);

        response.setContentType("application/json");
        if (isUpdated) {
            response.getWriter().write("{\"success\": true, \"imageUrl\": \"" + imageUrl + "\"}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"Database update failed\"}");
        }

    }

}