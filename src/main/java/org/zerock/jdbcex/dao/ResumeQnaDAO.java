package org.zerock.jdbcex.dao;


import org.zerock.jdbcex.dto.ResumeQnaDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ResumeQnaDAO {

    public void createQna(ResumeQnaDTO qna) throws Exception {
        String sql = "INSERT INTO resume_qna (resume_id, question, answer) VALUES (?, ?, ?)";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, qna.getResumeId());
            pstmt.setString(2, qna.getQuestion());
            pstmt.setString(3, qna.getAnswer());
            pstmt.executeUpdate();
        }

    }

    public List<ResumeQnaDTO> getQnaByResumeId(int resumeId) throws Exception {
        String sql = "SELECT id, question, answer FROM resume_qna WHERE resume_id = ?";
        List<ResumeQnaDTO> qnaList = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, resumeId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ResumeQnaDTO qna = new ResumeQnaDTO();
                    qna.setId(rs.getInt("id")); // 이 부분 확인
                    qna.setQuestion(rs.getString("question"));
                    qna.setAnswer(rs.getString("answer"));
                    qnaList.add(qna);
                    System.out.println(qna.getQuestion());
                    System.out.println(qna.getAnswer());
                }
            }
        }
        return qnaList;
    }


    public void deleteQnaByResumeId(int resumeId) throws Exception {
        String sql = "DELETE FROM resume_qna WHERE resume_id = ?";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, resumeId);
            pstmt.executeUpdate();
        }
    }

    public void updateAnserById(int id, String answer) {
        String sql = "UPDATE resume_qna SET answer = ? WHERE id = ?";
        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, answer);
            pstmt.setLong(2, id);
            pstmt.executeUpdate();

        } catch (Exception e) {
            throw new RuntimeException("Error updating answer by id", e);
        }
    }
}
