package org.zerock.jdbcex.service;

import org.zerock.jdbcex.dao.QnADAO;
import org.zerock.jdbcex.dto.QnADTO;

import java.sql.SQLException;
import java.util.List;

public class QnAService {

    private final QnADAO qnaDAO;

    // 생성자 - QnADAO 객체 주입
    public QnAService(QnADAO qnaDAO) {
        this.qnaDAO = qnaDAO;
    }

    // QnA 추가
    public boolean addQnA(QnADTO qna) {
        try {
            return qnaDAO.insertQnA(qna);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // QnA ID로 조회
    public QnADTO getQnAById(int id) {
        try {
            return qnaDAO.getQnAById(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // 모든 QnA 조회
    public List<QnADTO> getAllQnA() {
        try {
            return qnaDAO.getAllQnA();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    // QnA 수정
    public boolean updateQnA(QnADTO qna) {
        try {
            return qnaDAO.updateQnA(qna);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // QnA 삭제
    public boolean deleteQnA(int id) {
        try {
            return qnaDAO.deleteQnA(id);
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
