package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dao.CommentDAO;
import org.zerock.jdbcex.dao.ReviewDAO;
import org.zerock.jdbcex.dto.CommentDTO;
import org.zerock.jdbcex.dto.ReviewDTO;
import org.zerock.jdbcex.dto.UserDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/reviewDetail")
public class ReviewDetailController extends HttpServlet{
    private final ReviewDAO reviewDAO = new ReviewDAO();
    private final CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        try {
            // 리뷰 ID를 요청에서 가져옴
            int reviewId = Integer.parseInt(request.getParameter("review_id"));

            // 해당 리뷰 ID로 세부 정보를 가져옴
            ReviewDTO review = reviewDAO.getReviewById(reviewId);
            System.out.println(review);

            // 댓글 리스트 가져오기
            List<CommentDTO> comments = commentDAO.getCommentsByReviewId(reviewId);

            System.out.println(comments);

            // JSP에 전달
            request.setAttribute("review", review);
            request.setAttribute("comments", comments);

            request.getRequestDispatcher("/review_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "세부 내용 로드 중 오류 발생");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        try {
            // 댓글 작성 요청 처리
            int reviewId = Integer.parseInt(request.getParameter("review_id"));
            String content = request.getParameter("content");

            // 익명 처리 (익명 + 댓글 수로 생성)
            int currentCount = commentDAO.getCommentCountByReviewId(reviewId);
            String author = "익명 " + (currentCount + 1);

            // 댓글 객체 생성 및 데이터 삽입
            CommentDTO comment = new CommentDTO();
            comment.setReviewId(reviewId);
            comment.setAuthor(author);
            comment.setContent(content);

            commentDAO.insertComment(comment);

            // 성공적으로 저장 후 다시 세부 페이지로 리다이렉트
            response.sendRedirect("review_detail?review_id=" + reviewId);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "댓글 작성 중 오류 발생");
        }
    }
}
