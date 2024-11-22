package org.zerock.jdbcex.dao;
import org.zerock.jdbcex.dto.ScrapDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ScrapDAO {

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