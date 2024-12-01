package org.zerock.jdbcex.service;

import org.zerock.jdbcex.dao.InterviewDAO;
import org.zerock.jdbcex.dto.InterviewDTO;

import java.util.List;

public class InterviewService {

    private final InterviewDAO interviewDAO = new InterviewDAO();

    public List<InterviewDTO> getInterviewsByUserId(String userId) throws Exception {
        return interviewDAO.findInterviewsByUserId(userId);
    }
}
