package org.zerock.jdbcex.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

import org.modelmapper.ModelMapper;
import org.modelmapper.config.Configuration;
import org.modelmapper.convention.MatchingStrategies;

public enum ConnectionUtil {
    INSTANCE;

    // Database connection details


    private static final String URL = "jdbc:mariadb://localhost:3306/merijob_db";

    private static final String USER = "root";
    private static final String PASSWORD = "1024";


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
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MariaDB JDBC Driver not found", e);
        }
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    // Method to get the ModelMapper instance
    public ModelMapper getModelMapper() {
        return modelMapper;
    }
}
