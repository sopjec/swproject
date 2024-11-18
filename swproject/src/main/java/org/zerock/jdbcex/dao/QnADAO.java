package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.dto.QnADTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class QnADAO {

    // QnA 삽입 메서드
    public boolean insertQnA(QnADTO qna) throws SQLException {
        String sql = "INSERT INTO qna (user_id, title, content, file_path, qna_date, category) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, qna.getUserId());
            pstmt.setString(2, qna.getTitle());
            pstmt.setString(3, qna.getContent());
            pstmt.setString(4, qna.getFilePath());
            pstmt.setDate(5, java.sql.Date.valueOf(qna.getQnaDate())); // LocalDate를 java.sql.Date로 변환
            pstmt.setString(6, qna.getCategory());

            int rowsInserted = pstmt.executeUpdate();
            return rowsInserted > 0; // 삽입 성공 여부 반환
        }
    }

    // QnA 조회 메서드 (ID로 조회)
    public QnADTO getQnAById(int id) throws SQLException {
        String sql = "SELECT * FROM qna WHERE id = ?";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new QnADTO(
                            rs.getInt("id"),
                            rs.getString("user_id"),
                            rs.getString("title"),
                            rs.getString("content"),
                            rs.getString("file_path"),
                            rs.getDate("qna_date").toLocalDate(),
                            rs.getString("category")
                    );
                }
            }
        }
        return null;
    }

    // QnA 전체 조회 메서드
    public List<QnADTO> getAllQnA() throws SQLException {
        String sql = "SELECT * FROM qna";
        List<QnADTO> qnaList = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                QnADTO qna = new QnADTO(
                        rs.getInt("id"),
                        rs.getString("user_id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("file_path"),
                        rs.getDate("qna_date").toLocalDate(),
                        rs.getString("category")
                );
                qnaList.add(qna);
            }
        }
        return qnaList;
    }

    // QnA 수정 메서드
    public boolean updateQnA(QnADTO qna) throws SQLException {
        String sql = "UPDATE qna SET title = ?, content = ?, file_path = ?, category = ? WHERE id = ?";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, qna.getTitle());
            pstmt.setString(2, qna.getContent());
            pstmt.setString(3, qna.getFilePath());
            pstmt.setString(4, qna.getCategory());
            pstmt.setInt(5, qna.getId());

            int rowsUpdated = pstmt.executeUpdate();
            return rowsUpdated > 0;
        }
    }

    // QnA 삭제 메서드
    public boolean deleteQnA(int id) throws SQLException {
        String sql = "DELETE FROM qna WHERE id = ?";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            int rowsDeleted = pstmt.executeUpdate();
            return rowsDeleted > 0;
        }
    }
}
