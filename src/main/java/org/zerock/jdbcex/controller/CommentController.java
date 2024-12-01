package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dao.CommentDAO;
import org.zerock.jdbcex.dto.CommentDTO;
import org.zerock.jdbcex.dto.UserDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/comment")
public class CommentController extends HttpServlet {

    private final CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 사용자 정보 확인
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId(); // User ID 가져오기

        try {
            // 댓글 데이터 가져오기
            int reviewId = Integer.parseInt(request.getParameter("review_id"));
            String content = request.getParameter("content");

            // CommentDTO 생성 및 설정
            CommentDTO comment = new CommentDTO();
            comment.setReviewId(reviewId);
            comment.setAuthor(userId);
            comment.setContent(content);

            // 댓글 삽입
            commentDAO.insertComment(comment);

            // 성공 시 해당 리뷰 상세 페이지로 리다이렉트
            response.sendRedirect("reviewDetail?review_id=" + reviewId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "댓글 작성 중 오류 발생");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 리뷰 ID 가져오기
            int reviewId = Integer.parseInt(request.getParameter("review_id"));

            // 댓글 목록 조회
            List<CommentDTO> comments = commentDAO.getCommentsByReviewId(reviewId);

            // 요청 속성에 댓글 목록 저장
            request.setAttribute("comments", comments);

            // 댓글 데이터가 포함된 JSP 페이지로 전달
            request.getRequestDispatcher("/review_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "댓글 조회 중 오류 발생");
        }
    }
}
