package org.zerock.jdbcex.servlet;

import org.zerock.jdbcex.dao.EmotionDAO;
import org.zerock.jdbcex.dto.EmotionDTO;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/api/get-emotions")
public class GetEmotionsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json; charset=UTF-8");

        // 인터뷰 ID를 파라미터로 받음
        String interviewIdParam = req.getParameter("interviewId");
        if (interviewIdParam == null || interviewIdParam.isEmpty()) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        try {
            int interviewId = Integer.parseInt(interviewIdParam);
            List<EmotionDTO> emotions = EmotionDAO.getEmotionsByInterviewId(interviewId);

            // 감정 데이터를 JSON 형태로 변환
            JSONArray jsonArray = new JSONArray();
            for (EmotionDTO emotion : emotions) {
                JSONObject jsonObject = new JSONObject();
                jsonObject.put("type", emotion.getType());
                jsonObject.put("value", emotion.getValue());
                jsonArray.put(jsonObject);
            }

            PrintWriter out = resp.getWriter();
            out.print(jsonArray.toString());
            resp.setStatus(HttpServletResponse.SC_OK);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
}
