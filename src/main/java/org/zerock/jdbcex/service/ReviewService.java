//ReviewService
package org.zerock.jdbcex.service;

import org.zerock.jdbcex.dao.ReviewDAO;
import org.zerock.jdbcex.dto.ReviewDTO;

import java.util.List;

public class ReviewService {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    public List<ReviewDTO> getAllReviews() throws Exception {
        return reviewDAO.getAllReviews();
    }

    public void saveReview(ReviewDTO review) throws Exception {
        reviewDAO.insertReview(review);
    }
}