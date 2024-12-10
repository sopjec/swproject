package org.zerock.jdbcex.service;


import org.zerock.jdbcex.dao.ResumeDAO;
import org.zerock.jdbcex.dto.ResumeDTO;
import org.zerock.jdbcex.util.ConnectionUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
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

    public void updateTitleByResumeId(String resumeId, String newTitle) throws Exception {
        String query = "UPDATE resume SET title = ? WHERE id = ?";
        try (Connection connection = ConnectionUtil.INSTANCE.getConnection();
             PreparedStatement pstmt = connection.prepareStatement(query)) {

            System.out.println("Executing Update: resumeId=" + resumeId + ", newTitle=" + newTitle);

            pstmt.setString(1, newTitle);
            pstmt.setInt(2, Integer.parseInt(resumeId));
            int rowsUpdated = pstmt.executeUpdate();

            System.out.println("Rows Updated: " + rowsUpdated); // 몇 개의 행이 업데이트되었는지 출력
        }
    }



    public List<ResumeDTO> getResumesByUserId(String userId) throws Exception {
        return resumeDAO.getResumesByUserId(userId);
    }

    public void updateTitleById(int id, String newTitle) throws Exception {
        resumeDAO.updateResume(id, newTitle);
    }

    public void removeResume(int id, String userId) throws Exception {
        resumeDAO.deleteResume(id, userId);
    }


}
