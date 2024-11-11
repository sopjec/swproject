package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.model.Resume;
import org.zerock.jdbcex.util.DatabaseUtil;

import java.sql.*;
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

    // 특정 사용자의 자기소개서만 가져오는 메서드 추가
    public List<String[]> getUserIntroductionTitlesAndUserIds(String userId) throws Exception {
        List<String[]> results = new ArrayList<>();
        String sql = "SELECT id, title, user_id FROM Introduction WHERE user_id = ?";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String id = String.valueOf(rs.getInt("id"));
                    String title = rs.getString("title");
                    String userIdFromDB = rs.getString("user_id");
                    results.add(new String[]{id, title, userIdFromDB});
                }
            }
        }
        return results;
    }

    // 특정 introId에 해당하는 제목 가져오는 메서드 추가
    public String getIntroductionTitleById(int introId) throws Exception {
        String sql = "SELECT title FROM Introduction WHERE id = ?";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setInt(1, introId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("title");
                }
            }
        }
        throw new Exception("Failed to find the introduction title");
    }

    // Introduction과 연결된 Resume 삭제 메서드 추가
    public void deleteIntroductionsAndResumes(List<Integer> ids) throws Exception {
        String deleteResumesSql = "DELETE FROM Resume WHERE intro_id = ?";
        String deleteIntroductionsSql = "DELETE FROM Introduction WHERE id = ?";

        try (Connection con = DatabaseUtil.getConnection()) {
            // 트랜잭션 시작
            con.setAutoCommit(false);

            try (PreparedStatement pstmtResume = con.prepareStatement(deleteResumesSql);
                 PreparedStatement pstmtIntroduction = con.prepareStatement(deleteIntroductionsSql)) {

                // Resume 삭제
                for (int id : ids) {
                    pstmtResume.setInt(1, id);
                    pstmtResume.executeUpdate();
                }

                // Introduction 삭제
                for (int id : ids) {
                    pstmtIntroduction.setInt(1, id);
                    pstmtIntroduction.executeUpdate();
                }

                // 트랜잭션 커밋
                con.commit();
            } catch (Exception e) {
                // 오류 발생 시 롤백
                con.rollback();
                throw e;
            } finally {
                // 트랜잭션 자동 커밋 모드 복원
                con.setAutoCommit(true);
            }
        }
    }

    public List<Resume> getResumesByIntroId(int introId) throws Exception {
        List<Resume> resumes = new ArrayList<>();
        String sql = "SELECT question, answer FROM Resume WHERE intro_id = ?";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setInt(1, introId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Resume resume = new Resume();
                    resume.setIntroId(introId);
                    resume.setQuestion(rs.getString("question"));
                    resume.setAnswer(rs.getString("answer"));
                    resumes.add(resume);
                }
            }
        }
        return resumes;
    }

    public void updateIntroductionTitle(int introId, String title) throws Exception {
        String sql = "UPDATE Introduction SET title = ? WHERE id = ?";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, title);
            pstmt.setInt(2, introId);
            pstmt.executeUpdate();
        }
    }

    public void updateResume(int introId, String question, String answer) throws Exception {
        String sql = "UPDATE Resume SET question = ?, answer = ? WHERE intro_id = ? AND question = ?";
        try (Connection con = DatabaseUtil.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql)) {

            pstmt.setString(1, question);
            pstmt.setString(2, answer);
            pstmt.setInt(3, introId);
            pstmt.setString(4, question); // 기존 질문을 기준으로 업데이트
            pstmt.executeUpdate();
        }
    }
}
