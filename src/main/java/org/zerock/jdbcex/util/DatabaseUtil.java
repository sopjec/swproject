package org.zerock.jdbcex.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {

    private static final String URL = "jdbc:mariadb://localhost:3007/merijob_db";
    private static final String USER = "root";
    private static final String PASSWORD = "abcd980225*";

    public static Connection getConnection() {
        try {
            Connection connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database connection established successfully.");
            return connection;
        } catch (SQLException e) {
            System.err.println("Failed to create database connection.");
            e.printStackTrace();
            return null;
        }
    }


}
