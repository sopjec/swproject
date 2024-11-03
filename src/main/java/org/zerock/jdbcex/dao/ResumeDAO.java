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
    public void deleteIntroductions(List<Integer> ids) throws Exception {
        String deleteResumesSql = "DELETE FROM Resume WHERE intro_id = ?";
        String deleteIntroductionsSql = "DELETE FROM Introduction WHERE id = ?";

        try (Connection con = DatabaseUtil.getConnection()) {
            // Resume 테이블에서 관련 레코드 삭제
            try (PreparedStatement pstmt = con.prepareStatement(deleteResumesSql)) {
                for (int id : ids) {
                    pstmt.setInt(1, id);
                    pstmt.executeUpdate();
                }
            }

            // Introduction 테이블에서 삭제
            try (PreparedStatement pstmt = con.prepareStatement(deleteIntroductionsSql)) {
                for (int id : ids) {
                    pstmt.setInt(1, id);
                    pstmt.executeUpdate();
                }
            }
        }
    }

}
