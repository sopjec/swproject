package org.zerock.jdbcex.servlet;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet("/upload-video")
@MultipartConfig(
        fileSizeThreshold = 2097152, // 2MB
        maxFileSize = 52428800, // 50MB
        maxRequestSize = 104857600 // 100MB
)
public class VideoUploadServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "videos"; // 상대 경로 설정

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter writer = response.getWriter();

        // 프로젝트 절대 경로 확인 (Tomcat의 실제 배포 경로)
        String appPath = request.getServletContext().getRealPath("");
        String uploadPath = appPath + File.separator + UPLOAD_DIR;
        System.out.println("실제 업로드 경로: " + uploadPath);

        // 테스트용 절대 경로 설정
        String savePath = "C:\\Users\\wlsek\\IdeaProjects\\project\\src\\main\\webapp\\videos";

        // 디렉토리가 없는 경우 생성
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) {
            if (uploadDir.mkdirs()) {
                System.out.println("업로드 디렉토리가 생성되었습니다: " + savePath);
            } else {
                System.out.println("업로드 디렉토리 생성에 실패했습니다.");
                writer.println("업로드 디렉토리 생성 실패!");
                return;
            }
        }

        // 업로드 파일 저장 처리
        for (Part part : request.getParts()) {
            String fileName = extractFileName(part);
            if (fileName != null && !fileName.isEmpty()) {
                File fileToSave = new File(savePath, fileName);
                part.write(fileToSave.getAbsolutePath()); // 파일 저장
                System.out.println("파일 저장 완료: " + fileToSave.getAbsolutePath());
                writer.println("파일 저장 완료: " + fileToSave.getAbsolutePath());
            }
        }

        writer.println("파일 업로드 성공!");
    }

    // 파일 이름 추출
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
