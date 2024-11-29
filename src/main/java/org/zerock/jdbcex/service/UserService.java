package org.zerock.jdbcex.service;

import org.zerock.jdbcex.dao.UserDAO;
import org.zerock.jdbcex.dto.UserDTO;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import org.zerock.jdbcex.util.ConnectionUtil;

public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public boolean registerUser(UserDTO user) {
        return userDAO.registerUser(user);
    }

    public boolean updateProfileImage(String userId, String profileUrl) {
        String sql = "UPDATE users SET profile_image = ? WHERE user_id = ?";
        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, profileUrl);
            pstmt.setString(2, userId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public UserDTO loginUser(String id, String pwd) {
        return userDAO.loginUser(id, pwd);
    }
}