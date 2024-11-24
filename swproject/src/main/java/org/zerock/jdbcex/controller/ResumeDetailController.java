package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dto.ResumeQnaDTO;
import org.zerock.jdbcex.service.ResumeQnaService;
import org.zerock.jdbcex.service.ResumeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/resume_detail")
public class ResumeDetailController extends HttpServlet {

    private final ResumeService resumeService = new ResumeService();
    private final ResumeQnaService resumeQnaService = new ResumeQnaService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID가 필요합니다.");
            return;
        }

        try {
            int resumeId = Integer.parseInt(idParam);

            // resume 제목 조회
            String title = resumeService.getResumeTitleById(resumeId);

            // resume_qna 질문/답변 조회
            List<ResumeQnaDTO> qnaList = resumeQnaService.getQnaByResumeId(resumeId);

            req.setAttribute("title", title);
            req.setAttribute("qnaList", qnaList);
            req.getRequestDispatcher("resume_detail.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터를 불러오는 중 오류가 발생했습니다.");
        }
    }
}
