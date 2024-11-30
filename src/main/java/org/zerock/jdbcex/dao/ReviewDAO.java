//ReviewDAO
package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.dto.ReviewDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {
    //리뷰 데이터 삽입 메서드
    public void insertReview(ReviewDTO review) throws Exception {
        String sql = "INSERT INTO interview_review (user_id, content, job, region, comname, experience) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, review.getUserId());
            pstmt.setString(2, review.getContent());
            pstmt.setString(3, review.getJob());
            pstmt.setString(4, review.getRegion());
            pstmt.setString(5, review.getComname());
            pstmt.setString(6, review.getExperience());

            pstmt.executeUpdate();
        }
    }
    // 데이터 조회 메서드
    public List<ReviewDTO> getAllReviews() throws Exception {
        String sql = "SELECT comname, job, experience, region, content FROM interview_review";

        List<ReviewDTO> reviews = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                ReviewDTO review = new ReviewDTO();
                review.setComname(rs.getString("comname"));
                review.setJob(rs.getString("job"));
                review.setExperience(rs.getString("experience"));
                review.setRegion(rs.getString("region"));
                review.setContent(rs.getString("content"));

                reviews.add(review); // 리스트에 데이터 추가
            }
        }
        return reviews;
    }
}