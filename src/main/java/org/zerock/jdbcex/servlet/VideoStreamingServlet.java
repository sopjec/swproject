package org.zerock.jdbcex.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/videos/*")
public class VideoStreamingServlet extends HttpServlet {

    private static final String VIDEO_FOLDER = "C:/upload/videos";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String requestedFile = request.getPathInfo(); // /{filename}.webm
        if (requestedFile == null || requestedFile.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "파일 이름이 누락되었습니다.");
            return;
        }

        File videoFile = new File(VIDEO_FOLDER, requestedFile);
        if (!videoFile.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "파일을 찾을 수 없습니다.");
            return;
        }

        response.setContentType("video/webm");
        response.setContentLength((int) videoFile.length());

        try (FileInputStream fis = new FileInputStream(videoFile);
             OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }
    }
}
