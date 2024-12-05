package org.zerock.jdbcex.servlet;

import org.zerock.jdbcex.util.ConnectionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/upload-video")
@MultipartConfig(
        fileSizeThreshold = 2097152, // 2MB
        maxFileSize = 52428800, // 50MB
        maxRequestSize = 104857600 // 100MB
)
public class VideoUploadServlet extends HttpServlet {

    // C 드라이브의 upload/videos 디렉토리로 설정
    private static final String VIDEO_FOLDER = "C:/upload/videos";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        PrintWriter writer = response.getWriter();

        // URL에서 resumeId와 interviewId 가져오기
        String resumeId = request.getParameter("resumeId");
        String interviewId = request.getParameter("interviewId");

        if (resumeId == null || resumeId.isEmpty() || interviewId == null || interviewId.isEmpty()) {
            writer.println("resumeId 또는 interviewId가 전달되지 않았습니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 자소서 제목 조회
        String resumeTitle = getResumeTitle(resumeId);
        if (resumeTitle == null) {
            writer.println("해당 resumeId에 대한 자소서를 찾을 수 없습니다.");
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        System.out.println("조회된 resumeTitle: " + resumeTitle);

        // 저장 경로를 "C:/upload/videos/자소서제목_인터뷰ID.webm"으로 설정
        String folderName = resumeTitle + "_" + interviewId; // 파일명 생성
        File videoDir = new File(VIDEO_FOLDER);

        // videos 디렉토리 생성
        if (!videoDir.exists() && !videoDir.mkdirs()) {
            writer.println("업로드 디렉토리 생성에 실패했습니다.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        // 저장할 파일 경로
        File fileToSave = new File(videoDir, folderName + ".webm");

        // 파일 업로드 처리
        for (Part part : request.getParts()) {
            String originalFileName = extractFileName(part);
            if (originalFileName != null && !originalFileName.isEmpty()) {
                part.write(fileToSave.getAbsolutePath());
                writer.println("파일 저장 완료: " + fileToSave.getAbsolutePath());
                System.out.println("파일 저장 완료: " + fileToSave.getAbsolutePath());
            }
        }

        writer.println("파일 업로드 성공!");
    }

    // 자소서 제목 가져오기
    private String getResumeTitle(String resumeId) {
        String title = null;
        try (Connection conn = ConnectionUtil.INSTANCE.getConnection()) {
            String sql = "SELECT title FROM resume WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, Integer.parseInt(resumeId));
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        title = rs.getString("title");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return title;
    }

    // 원본 파일명 추출
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        for (String content : contentDisp.split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf("=") + 2, content.length() - 1);
            }
        }
        return null;
    }
}
