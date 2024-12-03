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
        String sql = "INSERT INTO review (user_id, content, job, region, comname, experience, created_date) VALUES (?, ?, ?, ?, ?, ?, NOW())";

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
    public List<ReviewDTO> getAllReviews(String sort, String experience, String region) throws Exception {
        StringBuilder sql = new StringBuilder("SELECT id, comname, job, experience, region, content, created_date, count_likes FROM review WHERE 1=1");

        // 조건 추가
        if (experience != null && !experience.isEmpty()) {
            sql.append(" AND experience = ?");
        }
        if (region != null && !region.isEmpty()) {
            sql.append(" AND region = ?");
        }
        if (sort != null) {
            if (sort.equals("최신순")) {
                sql.append(" ORDER BY created_date DESC");
            } else if (sort.equals("인기순")) {
                sql.append(" ORDER BY count_likes DESC");
            } else {
                sql.append(" ORDER BY id ASC"); // 기본 정렬
            }
        }

        List<ReviewDTO> reviews = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (experience != null && !experience.isEmpty()) {
                pstmt.setString(paramIndex++, experience);
            }
            if (region != null && !region.isEmpty()) {
                pstmt.setString(paramIndex++, region);
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewDTO review = new ReviewDTO();
                    review.setId(rs.getInt("id"));
                    review.setComname(rs.getString("comname"));
                    review.setJob(rs.getString("job"));
                    review.setExperience(rs.getString("experience"));
                    review.setRegion(rs.getString("region"));
                    review.setContent(rs.getString("content"));
                    review.setCreatedDate(rs.getTimestamp("created_date").toLocalDateTime());
                    review.setLikes(rs.getInt("count_likes"));
                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

    //리뷰 상세 조회 메서드
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
                    review.setCreatedDate(rs.getTimestamp("created_date").toLocalDateTime()); // 날짜 설정
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

    //필터 적용
    public List<ReviewDTO> getFilteredReviews(String search, String sort, String experience, String region) throws Exception {
        StringBuilder sql = new StringBuilder(
                "SELECT id, comname, job, experience, region, content, created_date, count_likes FROM review WHERE 1=1"
        );

        // 조건에 따라 쿼리 추가
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (comname LIKE ? OR content LIKE ?)");
        }
        if (experience != null && !experience.isEmpty()) {
            sql.append(" AND experience = ?");
        }
        if (region != null && !region.isEmpty()) {
            sql.append(" AND region = ?");
        }
        if ("최신순".equals(sort)) {
            sql.append(" ORDER BY created_date DESC");
        } else if ("인기순".equals(sort)) {
            sql.append(" ORDER BY count_likes DESC");
        }

        List<ReviewDTO> reviews = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            // 조건에 따라 파라미터 바인딩
            if (search != null && !search.isEmpty()) {
                pstmt.setString(paramIndex++, "%" + search + "%"); // `comname` 검색
                pstmt.setString(paramIndex++, "%" + search + "%"); // `content` 검색
            } //검섹어 조건 바인딩
            if (experience != null && !experience.isEmpty()) {
                pstmt.setString(paramIndex++, experience);
            }//경험 필터 바인딩
            if (region != null && !region.isEmpty()) {
                pstmt.setString(paramIndex++, region);
            }//지역필터 바인딩

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ReviewDTO review = new ReviewDTO();
                    review.setId(rs.getInt("id"));
                    review.setComname(rs.getString("comname"));
                    review.setJob(rs.getString("job"));
                    review.setExperience(rs.getString("experience"));
                    review.setRegion(rs.getString("region"));
                    review.setContent(rs.getString("content"));
                    review.setCreatedDate(rs.getTimestamp("created_date").toLocalDateTime());
                    review.setLikes(rs.getInt("count_likes"));

                    reviews.add(review);
                }
            }
        }
        return reviews;
    }

}
