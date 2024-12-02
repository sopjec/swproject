
package org.zerock.jdbcex.dao;

import org.zerock.jdbcex.dto.InterviewDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.ArrayList;
import java.util.List;


import org.zerock.jdbcex.dto.InterviewDTO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class InterviewDAO {

    private static final String SELECT_INTERVIEWS_BY_USER_ID = "SELECT id, title, user_id, interview_date FROM interview WHERE user_id = ?";

    public List<InterviewDTO> findInterviewsByUserId(String userId) throws Exception {
        List<InterviewDTO> interviewList = new ArrayList<>();

        try (Connection conn = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_INTERVIEWS_BY_USER_ID)) {

            pstmt.setString(1, userId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    InterviewDTO interview = InterviewDTO.builder()
                            .id(rs.getInt("id"))
                            .title(rs.getString("title"))
                            .userId(rs.getString("user_id"))
                            .interviewDate(rs.getDate("interview_date"))
                            .build();

                    interviewList.add(interview);
                }
            }
        }
        return interviewList;
    }
}
