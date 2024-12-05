package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.dto.CommentDTO;
import org.zerock.jdbcex.dto.InterviewQnADTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InterviewQnADAO {

    public int insertQnA(InterviewQnADTO qna) {
        String sql = "INSERT INTO interview_qna (id, interview_id, user_id, question, answer) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, qna.getId());
            pstmt.setInt(2, qna.getInterviewId());
            pstmt.setString(3, qna.getUser_id());
            pstmt.setString(4, qna.getQuestion());
            pstmt.setString(5, qna.getAnswer());
            pstmt.executeUpdate();
        } catch (SQLException e) {
            System.out.println("fail");
            return 0;
        }
        System.out.println("success");
        return 1;
    }

    public List<InterviewQnADTO> selectQnA(int id) throws Exception {
        String sql = "SELECT * FROM interview_qna WHERE id = ?";

        List<InterviewQnADTO> qnaList = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, id);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    InterviewQnADTO qna = new InterviewQnADTO();
                    qna.setId(rs.getInt("id"));
                    qna.setInterviewId(rs.getInt("interview_id"));
                    qna.setUser_id(rs.getString("user_id"));
                    qna.setQuestion(rs.getString("question"));
                    qna.setAnswer(rs.getString("answer"));

                    qnaList.add(qna);
                }
            }
        }
        return qnaList;
    }

    public List<InterviewQnADTO> getQuestionsAndAnswers(int id) throws Exception {
        String sql = "SELECT * FROM interview_qna WHERE interview_id = ?";
        List<InterviewQnADTO> qnaList = new ArrayList<>();
        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
        PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    InterviewQnADTO qna = new InterviewQnADTO();
                    qna.setId(rs.getInt("id"));
                    qna.setInterviewId(rs.getInt("interview_id"));
                    qna.setUser_id(rs.getString("user_id"));
                    qna.setQuestion(rs.getString("question"));
                    qna.setAnswer(rs.getString("answer"));
                    qnaList.add(qna);
                }
            }
        }
        return qnaList;
    }

}
