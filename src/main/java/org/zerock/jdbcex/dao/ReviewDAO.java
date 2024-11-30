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
    public void insertReview(ReviewDTO review) throws Exception {
        String sql = "INSERT INTO Interview_review (user_id, title, content, job, industry) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, review.getUserId());
            pstmt.setString(2, review.getTitle());
            pstmt.setString(3, review.getContent());
            pstmt.setString(4, review.getJob());
            pstmt.setString(5, review.getIndustry());
            pstmt.executeUpdate();
        }
    }
    // 데이터 조회 메서드
    public List<ReviewDTO> getAllReviews() throws Exception {
        String sql = "SELECT * FROM Interview_review ORDER BY id DESC"; // 최신순으로 정렬

        List<ReviewDTO> reviews = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                ReviewDTO review = new ReviewDTO();
                review.setId(rs.getInt("id"));
                review.setUserId(rs.getString("user_id"));
                review.setTitle(rs.getString("title"));
                review.setContent(rs.getString("content"));
                review.setJob(rs.getString("job"));
                review.setIndustry(rs.getString("industry"));

                reviews.add(review); // 리스트에 데이터 추가
            }
        }
        return reviews;
    }
}