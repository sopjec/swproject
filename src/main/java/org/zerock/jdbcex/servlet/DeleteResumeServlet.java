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
                resumeDAO.deleteIntroductions(idList);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("resume_view.jsp");
    }
}
