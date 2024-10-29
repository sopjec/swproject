package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.model.Resume;
import org.zerock.jdbcex.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

public class ResumeDAO {

    public int insertIntroduction(String userId, String title) throws Exception {
        String sql = "INSERT INTO Introduction (user_id, title) VALUES (?, ?)";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, userId);
            pstmt.setString(2, title);
            int affectedRows = pstmt.executeUpdate();
            System.out.println("Rows inserted into Introduction: " + affectedRows);

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        throw new Exception("Failed to insert introduction");
    }

    public void insertResume(Resume resume) throws Exception {
        String sql = "INSERT INTO Resume (intro_id, user_id, question, answer) VALUES (?, ?, ?, ?)";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setInt(1, resume.getIntroId());
            pstmt.setString(2, resume.getUserId());
            pstmt.setString(3, resume.getQuestion());
            pstmt.setString(4, resume.getAnswer());
            int affectedRows = pstmt.executeUpdate();
            System.out.println("Rows inserted into Resume: " + affectedRows);
        }
    }
}