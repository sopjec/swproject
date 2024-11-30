//ReviewController
package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dao.ReviewDAO;
import org.zerock.jdbcex.dto.ReviewDTO;

import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/review")
public class ReviewController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        ReviewDAO reviewDAO = new ReviewDAO();
        try {
            List<ReviewDTO> reviews = reviewDAO.getAllReviews(); // DB에서 리뷰 목록 가져오기
            request.setAttribute("reviews", reviews); // 요청 속성에 데이터 저장
            request.getRequestDispatcher("/review.jsp").forward(request, response); // JSP로 전달
        } catch (Exception e) {
            System.err.println("Error occurred while processing request: " + e.getMessage());
        }
    }
}
