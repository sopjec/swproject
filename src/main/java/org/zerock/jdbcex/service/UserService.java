package org.zerock.jdbcex.service;

import org.zerock.jdbcex.dao.UserDAO;
import org.zerock.jdbcex.dto.UserDTO;

public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public boolean registerUser(UserDTO user) {
        // 프로필 이미지가 없는 경우 기본값 설정
        if (user.getProfileUrl() == null || user.getProfileUrl().isEmpty()) {
            user.setProfileUrl("/img/1.png");
        }
        return userDAO.registerUser(user);
    }

    public boolean updateProfileImage(String userId, String profileUrl) {
        return userDAO.updateProfileImage(userId, profileUrl);
    }

    public UserDTO loginUser(String id, String pwd) {
        return userDAO.loginUser(id, pwd);
    }
}
