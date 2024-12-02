package org.zerock.jdbcex.servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import org.zerock.jdbcex.util.ConnectionUtil;

@WebServlet("/upload-video")
@MultipartConfig(
        fileSizeThreshold = 2097152, // 2MB
        maxFileSize = 52428800, // 50MB
        maxRequestSize = 104857600 // 100MB
)
public class VideoUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        PrintWriter writer = response.getWriter();

        // 요청 파라미터 확인
        request.getParameterMap().forEach((key, value) -> {
            System.out.println("Key: " + key + ", Value: " + String.join(", ", value));
        });

        // URL에서 resumeId 가져오기
        String resumeId = request.getParameter("resumeId");
        if (resumeId == null || resumeId.isEmpty()) {
            writer.println("resumeId가 전달되지 않았습니다.");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // 데이터베이스에서 resumeId에 해당하는 title 가져오기
        String resumeTitle = getResumeTitle(resumeId);
        if (resumeTitle == null) {
            writer.println("해당 resumeId에 대한 자소서를 찾을 수 없습니다.");
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        System.out.println("조회된 resumeTitle: " + resumeTitle);

        // 저장 경로를 상대 경로로 설정
        String relativePath = "/videos"; // 상대 경로 설정
        String savePath = getServletContext().getRealPath(relativePath);
        File uploadDir = new File(savePath);

        // 디렉토리 생성
        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
            writer.println("업로드 디렉토리 생성에 실패했습니다.");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            return;
        }

        // 파일 업로드 처리
        for (Part part : request.getParts()) {
            String originalFileName = extractFileName(part);
            if (originalFileName != null && !originalFileName.isEmpty()) {
                String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                String uniqueFileName = generateUniqueFileName(savePath, resumeTitle, fileExtension);

                File fileToSave = new File(savePath, uniqueFileName);
                part.write(fileToSave.getAbsolutePath());

                writer.println("파일 저장 완료: " + fileToSave.getAbsolutePath());
                System.out.println("파일 저장 완료: " + fileToSave.getAbsolutePath());
            }
        }

        writer.println("파일 업로드 성공!");
    }

    // 데이터베이스에서 resumeId에 해당하는 title 조회
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

    // 파일 이름 생성 로직
    private String generateUniqueFileName(String savePath, String baseName, String fileExtension) {
        String uniqueFileName = baseName + fileExtension;
        File file = new File(savePath, uniqueFileName);
        int counter = 1;

        while (file.exists()) {
            uniqueFileName = baseName + "_" + counter + fileExtension;
            file = new File(savePath, uniqueFileName);
            counter++;
        }
        return uniqueFileName;
    }

    // 원본 파일 이름 추출
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
