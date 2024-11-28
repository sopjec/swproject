package org.zerock.jdbcex.dao;
import org.zerock.jdbcex.dto.ScrapDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ScrapDAO {
    private static final String DELETE_SCRAP_SQL = "DELETE FROM scrap WHERE user_id = ? AND scrap_key = ?";

    // 스크랩 키 가져오기
    public List<String> getScrapKeys(String userId) {
        List<String> scrapedKeys = new ArrayList<>();
        String sql = "SELECT scrap_key FROM scrap WHERE user_id = ?";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    scrapedKeys.add(rs.getString("scrap_key"));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return scrapedKeys;
    }

    public int getScrapCount(String userId) throws SQLException {
        String query = "SELECT COUNT(*) AS total FROM scrap WHERE user_id = ?";
        int totalScraps = 0;

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    totalScraps = rs.getInt("total");
                }
            }
        }
        return totalScraps;
    }

    public void deleteScrap(String userId, String scrapKey) {
        String query = "DELETE FROM scrap WHERE user_id = ? AND scrap_key = ?";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, scrapKey);
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    // 스크랩 데이터 삽입 메서드
    public boolean insertScrap(ScrapDTO scrap) throws SQLException {
        String sql = "INSERT INTO scrap (user_id, scrap_key) VALUES (?, ?)";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, scrap.getUserId());
            pstmt.setString(2, scrap.getScrapKey());

            int rowsInserted = pstmt.executeUpdate();
            return rowsInserted > 0; // 삽입 성공 여부 반환
        }
    }


}