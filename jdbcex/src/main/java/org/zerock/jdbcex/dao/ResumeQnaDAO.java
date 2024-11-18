package org.zerock.jdbcex.dao;


import org.json.JSONArray;
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

    public void updateQuestionsAndAnswers(int resumeId, JSONArray questions, JSONArray answers) throws Exception {
        String deleteSql = "DELETE FROM resume_qna WHERE resume_id = ?";
        String insertSql = "INSERT INTO resume_qna (resume_id, question, answer) VALUES (?, ?, ?)";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement deletePstmt = conn.prepareStatement(deleteSql)) {
                deletePstmt.setInt(1, resumeId);
                deletePstmt.executeUpdate();
            }

            try (PreparedStatement insertPstmt = conn.prepareStatement(insertSql)) {
                for (int i = 0; i < questions.length(); i++) {
                    insertPstmt.setInt(1, resumeId);
                    insertPstmt.setString(2, questions.getString(i));
                    insertPstmt.setString(3, answers.getString(i));
                    insertPstmt.addBatch();
                }
                insertPstmt.executeBatch();
            }

            conn.commit();
        }
    }

    public List<ResumeQnaDTO> getQnaByResumeId(int resumeId) throws Exception {
        String sql = "SELECT question, answer FROM resume_qna WHERE resume_id = ?";
        List<ResumeQnaDTO> qnaList = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, resumeId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ResumeQnaDTO qna = new ResumeQnaDTO();
                    qna.setQuestion(rs.getString("question"));
                    qna.setAnswer(rs.getString("answer"));
                    qnaList.add(qna);
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
}
