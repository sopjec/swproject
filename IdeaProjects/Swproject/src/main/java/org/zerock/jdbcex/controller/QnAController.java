package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dao.QnADAO;
import org.zerock.jdbcex.dto.QnADTO;
import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.QnAService;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;

@WebServlet(name = "QnAController", urlPatterns = {"/submit", "/qna/update", "/qna/delete"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,     // 1MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 100   // 100MB
)
public class QnAController extends HttpServlet {

    private QnAService qnaService;

    @Override
    public void init() throws ServletException {
        qnaService = new QnAService(new QnADAO());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/submit":
                handleInsert(request, response);
                break;
            case "/qna/update":
                handleUpdate(request, response);
                break;
            case "/qna/delete":
                handleDelete(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    // QnAController의 handleInsert 메서드 예시
    private void handleInsert(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 세션에서 사용자 정보를 가져옴
        HttpSession session = request.getSession();
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        if (loggedInUser == null) {
            // 로그인이 되어 있지 않으면 로그인 페이지로 리다이렉트
            response.sendRedirect("login.jsp");
            return;
        }

        // UserDTO에서 사용자 ID를 가져옴
        String userId = loggedInUser.getId(); // UserDTO의 getId() 메서드 사용

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        String filePath = request.getParameter("filePath");

        if (title == null || title.isEmpty()) {
            System.out.println("Title is missing or empty"); // 디버그 메시지
        }

        QnADTO qna = new QnADTO();
        qna.setUserId(userId);
        qna.setTitle(title);
        qna.setContent(content);
        qna.setCategory(category);
        qna.setFilePath(filePath);
        qna.setQnaDate(new Date(System.currentTimeMillis()).toLocalDate());

        boolean isInserted = qnaService.addQnA(qna);
        if (isInserted) {
            response.sendRedirect("qna.jsp"); // 성공 시 목록 페이지로 리다이렉트
        } else {
            request.setAttribute("errorMessage", "문의 등록에 실패했습니다.");
            request.getRequestDispatcher("qna-submit.jsp").forward(request, response);
        }
    }

    // 문의 수정
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String category = request.getParameter("category");
        String filePath = request.getParameter("filePath");

        QnADTO qna = new QnADTO();
        qna.setId(id);
        qna.setTitle(title);
        qna.setContent(content);
        qna.setCategory(category);
        qna.setFilePath(filePath);

        boolean isUpdated = qnaService.updateQnA(qna);
        if (isUpdated) {
            response.sendRedirect("/qna/view?id=" + id); // 성공 시 상세보기 페이지로 리디렉션
        } else {
            request.setAttribute("errorMessage", "문의 수정에 실패했습니다.");
            request.getRequestDispatcher("/qna-submit.jsp").forward(request, response);
        }
    }

    // 문의 삭제
    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));

        boolean isDeleted = qnaService.deleteQnA(id);
        if (isDeleted) {
            response.sendRedirect("/qna.jsp"); // 성공 시 목록 페이지로 리디렉션
        } else {
            request.setAttribute("errorMessage", "문의 삭제에 실패했습니다.");
            request.getRequestDispatcher("/qna.jsp").forward(request, response);
        }
    }
}
