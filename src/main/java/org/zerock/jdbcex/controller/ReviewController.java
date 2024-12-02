//ReviewController
package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dao.ReviewDAO;
import org.zerock.jdbcex.dto.ReviewDTO;
import org.zerock.jdbcex.dto.UserDTO;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/reviewUpload")
public class ReviewController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        ReviewDAO reviewDAO = new ReviewDAO();

        try {
            // 필터 조건 가져오기
            String sort = request.getParameter("sort"); // 정렬 기준
            String experience = request.getParameter("experience"); // 경력 필터
            String region = request.getParameter("region"); // 지역 필터

            // DAO에서 필터 조건에 맞는 데이터 조회
            List<ReviewDTO> reviews = reviewDAO.getAllReviews(sort, experience, region);

            //조회된 데이터 jsp에 전달
            request.setAttribute("reviews", reviews); // 요청 속성에 데이터 저장
            request.getRequestDispatcher("/review.jsp").forward(request, response); // JSP로 전달
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "리뷰 조회 중 오류 발생");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        // 데이터베이스 접근 객체 생성
        ReviewDAO reviewDAO = new ReviewDAO();
        // 로그인 확인
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("세션이 만료 되었습니다.");
            return;
        }

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        // 사용자 입력 데이터 가져오기
        String comname = request.getParameter("comname");
        String job = request.getParameter("job");
        String experience = request.getParameter("experience");
        String region = request.getParameter("region");
        String content = request.getParameter("content");

        // ReviewDTO 객체 생성 및 데이터 설정
        ReviewDTO reviewDTO = new ReviewDTO();
        reviewDTO.setComname(comname);
        reviewDTO.setJob(job);
        reviewDTO.setExperience(experience);
        reviewDTO.setRegion(region);
        reviewDTO.setContent(content);
        reviewDTO.setUserId(loggedInUser.getId()); // 필요에 따라 설정

        try {
            // 데이터베이스에 리뷰 저장
            reviewDAO.insertReview(reviewDTO);

            // 성공적으로 저장된 경우 성공 메시지와 함께 페이지 이동
            response.sendRedirect("/reviewUpload");
        } catch (Exception e) {
            // 예외 처리: 로그 출력 및 오류 페이지로 이동
            e.printStackTrace();
            //response.sendRedirect("review.jsp");
        }
    }
}