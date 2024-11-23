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
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("id");

        Part filePart = request.getPart("profileImageUpload");
        String fileName = extractFileName(filePart);

        // 저장 경로 설정
        String savePath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + fileName;
        File fileSaveDir = new File(savePath);
        fileSaveDir.getParentFile().mkdirs();
        filePart.write(savePath);

        // 데이터베이스에 프로필 이미지 경로 저장
        String profileUrl = "uploads/" + fileName;
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
