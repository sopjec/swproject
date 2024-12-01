package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.dto.CommentDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

    // 댓글 삽입 메서드
    public void insertComment(CommentDTO comment) throws Exception {
        String sql = "INSERT INTO comments (review_id, author, content, created_date) VALUES (?, ?, ?, NOW())";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, comment.getReviewId());
            pstmt.setString(2, comment.getAuthor());
            pstmt.setString(3, comment.getContent());

            pstmt.executeUpdate();
        }
    }

    // 특정 리뷰에 대한 댓글 개수 조회 메서드
    public int getCommentCountByReviewId(int reviewId) throws Exception {
        String sql = "SELECT COUNT(*) FROM comments WHERE review_id = ?";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reviewId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // 댓글 수 반환
                }
            }
        }
        return 0; // 댓글이 없으면 0 반환
    }

    // 특정 리뷰에 대한 댓글 리스트 조회 메서드
    public List<CommentDTO> getCommentsByReviewId(int reviewId) throws Exception {
        String sql = "SELECT id, review_id, author, content, created_date FROM comments WHERE review_id = ?";
        List<CommentDTO> comments = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reviewId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CommentDTO comment = new CommentDTO();
                    comment.setId(rs.getInt("id"));
                    comment.setReviewId(rs.getInt("review_id"));
                    comment.setAuthor(rs.getString("author"));
                    comment.setContent(rs.getString("content"));

                    // DATETIME 값을 LocalDateTime으로 변환
                    comment.setCreatedDate(rs.getTimestamp("created_date").toLocalDateTime());

                    comments.add(comment);
                }
            }
        }
        return comments;
    }

}
