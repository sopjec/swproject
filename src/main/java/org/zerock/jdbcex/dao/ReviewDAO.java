//ReviewDAO
package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.dto.ReviewDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {
    //리뷰 데이터 삽입 메서드
    public void insertReview(ReviewDTO review) throws Exception {
        String sql = "INSERT INTO review (user_id, content, job, region, comname, experience) VALUES (?, ?, ?, ?, ?, ?)";

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
        String sql = "SELECT id, comname, job, experience, region, content FROM review";

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
                review.setId(Integer.parseInt(rs.getString("id")));

                reviews.add(review); // 리스트에 데이터 추가
            }
        }
        return reviews;
    }

    public ReviewDTO getReviewById(int reviewId) throws Exception {
        String sql = "SELECT * FROM review WHERE id = ?";


        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reviewId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ReviewDTO review = new ReviewDTO();
                    review.setId(Integer.parseInt(rs.getString("id")));
                    review.setUserId(rs.getString("user_id"));
                    review.setComname(rs.getString("comname"));
                    review.setJob(rs.getString("job"));
                    review.setExperience(rs.getString("experience"));
                    review.setRegion(rs.getString("region"));
                    review.setContent(rs.getString("content"));
                    review.setLikes(rs.getInt("count_likes"));
                    return review;
                }
            }
        }
        return null;
    }

    // 좋아요 여부 확인
    public boolean isLikedByUser(String userId, int reviewId) throws Exception {
        String sql = "SELECT COUNT(*) FROM likes WHERE user_id = ? AND review_id = ?";
        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setInt(2, reviewId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }

    //좋아요 추가
    public void likeReview(String userId, int reviewId) throws Exception {
        String sql = "INSERT INTO likes (user_id, review_id) VALUES (?, ?)";
        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setInt(2, reviewId);
            pstmt.executeUpdate();
        }
    }

    //좋아요 삭제
    public void unlikeReview(String userId, int reviewId) throws Exception {
        String sql = "DELETE FROM likes WHERE user_id = ? AND review_id = ?";
        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setInt(2, reviewId);
            pstmt.executeUpdate();
        }
    }

    //좋아요 갯수 가져오기
    public int getLikes(int reviewId) throws Exception {
        String sql = "SELECT COUNT(*) FROM likes WHERE review_id = ?";
        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, reviewId);
            try (ResultSet rs = pstmt.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}