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
@WebServlet("/updateProfile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5)
public class ProfileUpdateServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 요청과 응답 인코딩 설정
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("id");

        // 선택한 이미지 값 가져오기
        String selectedImage = request.getParameter("profileImage");
        if (selectedImage == null || selectedImage.isEmpty()) {
            response.getWriter().write("프로필 사진을 선택하세요.");
            return;
        }

        // 경로 저장
        String profileUrl = "uploads/" + selectedImage;

        // 데이터베이스 업데이트
        boolean updateSuccess = userService.updateProfileImage(userId, profileUrl);


        if (updateSuccess) {
            response.sendRedirect("mypage.jsp");
        } else {
            response.getWriter().write("프로필 업데이트 실패"); // 디버그 메시지
            System.out.println("프로필 업데이트 실패: userId=" + userId + ", profileUrl=" + profileUrl); // 디버그 메시지
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
