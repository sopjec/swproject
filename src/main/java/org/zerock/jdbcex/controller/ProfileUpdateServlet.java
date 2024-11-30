package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.BufferedReader;

@WebServlet("/updateProfile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5)
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
        String jsonData = jsonBuilder.toString();
        System.out.println("Received JSON: " + jsonData); // 디버깅 로그

        // JSON 파싱
        com.google.gson.JsonObject jsonObject = com.google.gson.JsonParser.parseString(jsonData).getAsJsonObject();
        String imageUrl = jsonObject.get("imageUrl").getAsString();

        // 세션에서 사용자 ID 가져오기
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("id");

        if (userId == null || imageUrl == null) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\": false}");
            return;
        }

        // 데이터베이스 업데이트
        boolean isUpdated = userService.updateProfileImage(userId, imageUrl);
        response.setContentType("application/json");
        if (isUpdated) {
            response.getWriter().write("{\"success\": true}");
        } else {
            response.getWriter().write("{\"success\": false}");
        }
    }



    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) {
            System.out.println("Error: content-disposition header is missing.");
            return null; // null 반환
        }
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return null;
    }
}
