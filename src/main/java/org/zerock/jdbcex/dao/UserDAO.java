package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO {

    public boolean registerUser(UserDTO user) {
        String sql = "INSERT INTO user (id, pwd, name, gender, profile_url, date_of_birth) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, user.getId());
            pstmt.setString(2, user.getPwd());
            pstmt.setString(3, user.getName());
            pstmt.setString(4, user.getGender());
            pstmt.setString(5, user.getProfileUrl());
            pstmt.setString(6, user.getDateOfBirth());

            int rowsInserted = pstmt.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public UserDTO loginUser(String id, String pwd) {
        String sql = "SELECT * FROM user WHERE id = ? AND pwd = ?";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);
            pstmt.setString(2, pwd);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return new UserDTO(
                            rs.getString("id"),
                            rs.getString("pwd"),
                            rs.getString("name"),
                            rs.getString("gender"),
                            rs.getString("profile_url"),
                            rs.getString("date_of_birth")
                    );
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // 로그인 실패 시 null 반환
    }
}
