package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dao.UserDAO;
import org.zerock.jdbcex.util.ConnectionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import java.sql.Connection;
import java.sql.SQLException;

@WebServlet("/ProfileUploadController")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5,   // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class ProfileUploadController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        try {
            Connection conn = ConnectionUtil.INSTANCE.getConnection();
            userDAO = new UserDAO();
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }


}
