package org.zerock.jdbcex.servlet;

import org.zerock.jdbcex.dao.ResumeDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/deleteResumes")
public class DeleteResumeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] ids = request.getParameterValues("ids");
        if (ids != null) {
            List<Integer> idList = new ArrayList<>();
            for (String id : ids) {
                idList.add(Integer.parseInt(id));
            }

            ResumeDAO resumeDAO = new ResumeDAO();
            try {
                // 변경된 메서드 호출 (Introduction과 관련된 Resume도 함께 삭제)
                resumeDAO.deleteIntroductionsAndResumes(idList);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "삭제 중 오류가 발생했습니다.");
                return;
            }
        }
        response.sendRedirect("resume_view.jsp");
    }
}
