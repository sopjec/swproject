package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.model.Resume;
import org.zerock.jdbcex.util.DatabaseUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

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

    public List<String[]> getAllIntroductionTitlesAndUserIds() throws Exception {
        List<String[]> results = new ArrayList<>();
        String sql = "SELECT id, title, user_id FROM Introduction";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                String id = String.valueOf(rs.getInt("id"));
                String title = rs.getString("title");
                String userId = rs.getString("user_id");
                results.add(new String[]{id, title, userId});
            }
        }
        return results;
    }

    //디비 속 resume 삭제 메서드
      public void deleteIntroductions(List<Integer> ids) throws Exception {
        String sql = "DELETE FROM Introduction WHERE id = ?";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {
            for (int id : ids) {
                pstmt.setInt(1, id);
                pstmt.executeUpdate();
            }
        }

    }


}
