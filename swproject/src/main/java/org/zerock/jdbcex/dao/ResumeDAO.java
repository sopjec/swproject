package org.zerock.jdbcex.dao;


import org.zerock.jdbcex.dto.ResumeDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ResumeDAO {

    public void createResume(ResumeDTO resume) throws Exception {
        String sql = "INSERT INTO resume (title, user_id) VALUES (?, ?)";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            pstmt.setString(1, resume.getTitle());
            pstmt.setString(2, resume.getUserId());
            pstmt.executeUpdate();

            try (ResultSet rs = pstmt.getGeneratedKeys()) {
                if (rs.next()) {
                    resume.setId(rs.getInt(1));
                }
            }
        }
    }

    public List<ResumeDTO> getAllResumes() throws Exception {
        String sql = "SELECT id, title FROM resume";

        List<ResumeDTO> resumes = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                ResumeDTO resume = new ResumeDTO();
                resume.setId(rs.getInt("id"));
                resume.setTitle(rs.getString("title"));
                resumes.add(resume);
            }
        }

        return resumes;
    }


    public List<ResumeDTO> getResumesByUserId(String userId) throws Exception {
        String sql = "SELECT id, title FROM resume WHERE user_id = ?";

        List<ResumeDTO> resumes = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ResumeDTO resume = new ResumeDTO();
                    resume.setId(rs.getInt("id"));
                    resume.setTitle(rs.getString("title"));
                    resumes.add(resume);
                }
            }
        }

        return resumes;
    }

    public String getResumeTitleById(int id) throws Exception {
        String sql = "SELECT title FROM resume WHERE id = ?";
        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("title");
                }
            }
        }
        return null;
    }

    public void updateTitle(int resumeId, String title) throws Exception {
        String sql = "UPDATE resume SET title = ? WHERE id = ?";
        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, title);
            pstmt.setInt(2, resumeId);
            pstmt.executeUpdate();
        }
    }



    public List<ResumeDTO> getAllResumesByUserId(String userId) throws Exception {
        String sql = "SELECT id, title, user_id FROM resume WHERE user_id = ?";
        List<ResumeDTO> resumes = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ResumeDTO resume = new ResumeDTO();
                    resume.setId(rs.getInt("id"));
                    resume.setTitle(rs.getString("title"));
                    resume.setUserId(rs.getString("user_id"));
                    resumes.add(resume);
                }
            }
        }

        return resumes;
    }

    public void updateResume(ResumeDTO resume) throws Exception {
        String sql = "UPDATE resume SET title = ? WHERE id = ? AND user_id = ?";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, resume.getTitle());
            pstmt.setInt(2, resume.getId());
            pstmt.setString(3, resume.getUserId());
            pstmt.executeUpdate();
        }
    }

    public void deleteResume(int id, String userId) throws Exception {
        String sql = "DELETE FROM resume WHERE id = ? AND user_id = ?";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);
            pstmt.setString(2, userId);
            pstmt.executeUpdate();
        }
    }
}
