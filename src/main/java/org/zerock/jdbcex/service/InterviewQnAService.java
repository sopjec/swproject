package org.zerock.jdbcex.service;

import org.zerock.jdbcex.dao.InterviewQnADAO;
import org.zerock.jdbcex.dto.InterviewQnADTO;

import java.util.List;

public class InterviewQnAService {

    private InterviewQnADAO qnaDAO = new InterviewQnADAO();

    public int insertQnA (InterviewQnADTO qna) {
        return (qnaDAO.insertQnA(qna));
    };

    public List<InterviewQnADTO> getQuestionsAndAnswers(int qnaId) throws Exception {
        return qnaDAO.getQuestionsAndAnswers(qnaId);
    }
}
