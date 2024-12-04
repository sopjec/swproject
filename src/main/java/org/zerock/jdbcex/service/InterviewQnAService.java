package org.zerock.jdbcex.service;

import org.zerock.jdbcex.dao.InterviewQnADAO;
import org.zerock.jdbcex.dto.InterviewQnADTO;

public class InterviewQnAService {

    private InterviewQnADAO qnaDAO = new InterviewQnADAO();

    public int insertQnA (InterviewQnADTO qna) {
        return (qnaDAO.insertQnA(qna));
    };
}
