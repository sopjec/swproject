//ReviewController
package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dao.ReviewDAO;
import org.zerock.jdbcex.dto.ReviewDTO;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/reviewUpload")
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

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 데이터베이스 접근 객체 생성
        ReviewDAO reviewDAO = new ReviewDAO();

        // 사용자 입력 데이터 가져오기
        String comname = request.getParameter("comname");
        String job = request.getParameter("job");
        String experience = request.getParameter("experience");
        String region = request.getParameter("region");
        String content = request.getParameter("content");
        //String userId = request.getParameter("user_id"); // 필요에 따라 수정

        // ReviewDTO 객체 생성 및 데이터 설정
        ReviewDTO reviewDTO = new ReviewDTO();
        reviewDTO.setComname(comname);
        reviewDTO.setJob(job);
        reviewDTO.setExperience(experience);
        reviewDTO.setRegion(region);
        reviewDTO.setContent(content);
        //reviewDTO.setUserId(userId); // 필요에 따라 설정

        try {
            // 데이터베이스에 리뷰 저장
            reviewDAO.insertReview(reviewDTO);

            // 성공적으로 저장된 경우 성공 메시지와 함께 페이지 이동
            response.sendRedirect("review.jsp?success=true");
        } catch (Exception e) {
            // 예외 처리: 로그 출력 및 오류 페이지로 이동
            e.printStackTrace();
            //response.sendRedirect("review.jsp");
        }
    }
}
