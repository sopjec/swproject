package org.zerock.jdbcex.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public enum ConnectionUtil {

    INSTANCE;

    private static final String URL = "jdbc:mariadb://localhost:3307/merijob_db";
    private static final String USER = "root";
    private static final String PASSWORD = "1111";

    public Connection getConnection() throws SQLException {
        try {
            // JDBC 드라이버 수동 로드
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MariaDB JDBC Driver not found", e);
        }

        // 데이터베이스 연결 생성
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

}
