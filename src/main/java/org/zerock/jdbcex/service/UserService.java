package org.zerock.jdbcex.service;

import org.zerock.jdbcex.dao.UserDAO;
import org.zerock.jdbcex.dto.UserDTO;

public class UserService {

    private final UserDAO userDAO;

    public UserService() {
        this.userDAO = new UserDAO();
    }

    public boolean registerUser(UserDTO user) {
        return userDAO.registerUser(user);
    }

    public UserDTO loginUser(String id, String pwd) {
        return userDAO.loginUser(id, pwd);
    }
}
