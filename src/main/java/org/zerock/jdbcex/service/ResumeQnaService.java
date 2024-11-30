package org.zerock.jdbcex.service;


import org.zerock.jdbcex.dao.ResumeQnaDAO;
import org.zerock.jdbcex.dto.ResumeQnaDTO;

import java.util.List;

public class ResumeQnaService {

    private final ResumeQnaDAO resumeQnaDAO = new ResumeQnaDAO();

    public void addQna(ResumeQnaDTO qna) throws Exception {
        resumeQnaDAO.createQna(qna);
    }

    public List<ResumeQnaDTO> getQnaList(int resumeId) throws Exception {
        return resumeQnaDAO.getQnaByResumeId(resumeId);
    }

    public List<ResumeQnaDTO> getQnaByResumeId(int resumeId) throws Exception {
        return resumeQnaDAO.getQnaByResumeId(resumeId);
    }

    public void deleteQnaByResumeId(int resumeId) throws Exception {
        resumeQnaDAO.deleteQnaByResumeId(resumeId);
    }

    public void updateAnswerById(int id, String answer) throws Exception {
        resumeQnaDAO.updateAnserById(id, answer);
    }
}
