package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.dto.CommentDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {
    // 댓글 삽입
    public void insertComment(CommentDTO comment) throws Exception {
        String sql = "INSERT INTO comments (review_id, parent_comment_id, author, content, created_date) VALUES (?, ?, ?, ?, NOW())";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, comment.getReviewId());
            if (comment.getParentCommentId() != null) {
                pstmt.setInt(2, comment.getParentCommentId());
            } else {
                pstmt.setNull(2, java.sql.Types.INTEGER);
            }
            pstmt.setString(3, comment.getAuthor());
            pstmt.setString(4, comment.getContent());

            pstmt.executeUpdate();
        }
    }

    // 댓글 리스트 가져오기
    public List<CommentDTO> getCommentsByReviewId(int reviewId) throws Exception {
        String sql = "SELECT * FROM comments WHERE review_id = ? ORDER BY parent_comment_id ASC, created_date ASC";

        List<CommentDTO> comments = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, reviewId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CommentDTO comment = new CommentDTO();
                    comment.setId(rs.getInt("id"));
                    comment.setReviewId(rs.getInt("review_id"));
                    comment.setParentCommentId(rs.getInt("parent_comment_id") != 0 ? rs.getInt("parent_comment_id") : null);
                    comment.setAuthor(rs.getString("author"));
                    comment.setContent(rs.getString("content"));
                    comment.setCreatedDate(rs.getTimestamp("created_date").toLocalDateTime());

                    comments.add(comment);
                }
            }
        }
        return comments;
    }
}