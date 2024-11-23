package org.zerock.jdbcex.service;


import org.zerock.jdbcex.dao.ResumeDAO;
import org.zerock.jdbcex.dto.ResumeDTO;

import java.util.List;

public class ResumeService {

    private final ResumeDAO resumeDAO = new ResumeDAO();

    public void addResume(ResumeDTO resume) throws Exception {
        resumeDAO.createResume(resume);
    }

    public List<ResumeDTO> getAllResumes() throws Exception {
        return resumeDAO.getAllResumes();
    }

    public String getResumeTitleById(int id) throws Exception {
        return resumeDAO.getResumeTitleById(id);
    }

    public List<ResumeDTO> getResumesByUserId(String userId) throws Exception {
        return resumeDAO.getResumesByUserId(userId);
    }

    public void editResume(ResumeDTO resume) throws Exception {
        resumeDAO.updateResume(resume);
    }

    public void removeResume(int id, String userId) throws Exception {
        resumeDAO.deleteResume(id, userId);
    }
}
