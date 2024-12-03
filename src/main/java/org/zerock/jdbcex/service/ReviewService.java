//ReviewService
package org.zerock.jdbcex.service;

import org.zerock.jdbcex.dao.ReviewDAO;
import org.zerock.jdbcex.dto.ReviewDTO;

import java.util.List;

public class ReviewService {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    public List<ReviewDTO> getFilteredReviews(String search, String sort, String experience, String region) throws Exception {
        return reviewDAO.getFilteredReviews(search, sort, experience, region);
    }

    public void saveReview(ReviewDTO review) throws Exception {
        reviewDAO.insertReview(review);
    }
}