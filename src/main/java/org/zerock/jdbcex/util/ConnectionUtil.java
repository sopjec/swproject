package org.zerock.jdbcex.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.modelmapper.ModelMapper;
import org.modelmapper.config.Configuration;
import org.modelmapper.convention.MatchingStrategies;

public enum ConnectionUtil {

    INSTANCE, jdbc;

    private static final String URL = "jdbc:mariadb://localhost:3307/merijob_db?useUnicode=true&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "1111";
    // ModelMapper instance
    private final ModelMapper modelMapper;

    // Constructor to initialize ModelMapper and other resources
    ConnectionUtil() {
        // Initialize ModelMapper with specific configuration
        modelMapper = new ModelMapper();
        modelMapper.getConfiguration()
                .setFieldMatchingEnabled(true)
                .setFieldAccessLevel(Configuration.AccessLevel.PRIVATE)
                .setMatchingStrategy(MatchingStrategies.STRICT);
    }

    // Method to get a database connection
    public Connection getConnection() throws SQLException {
        try {
            // JDBC 드라이버 수동 로드 (필요 시)
            Class.forName("org.mariadb.jdbc.Driver");
            System.out.println("MariaDB JDBC Driver 로드 성공");
        } catch (ClassNotFoundException e) {
            System.err.println("MariaDB JDBC Driver 로드 실패: " + e.getMessage());
            throw new RuntimeException("MariaDB JDBC Driver not found", e);
        }

        try {
            // 데이터베이스 연결 생성
            Connection connection = DriverManager.  getConnection(URL, USER, PASSWORD);
            System.out.println("데이터베이스 연결 성공: " + URL);
            return connection;
        } catch (SQLException e) {
            System.err.println("데이터베이스 연결 실패: " + e.getMessage());
            throw e;
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Method to get the ModelMapper instance
    public ModelMapper getModelMapper() {
        return modelMapper;
    }
}
