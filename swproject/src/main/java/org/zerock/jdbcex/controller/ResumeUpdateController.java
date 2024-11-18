package org.zerock.jdbcex.controller;

import org.json.JSONArray;
import org.json.JSONObject;
import org.zerock.jdbcex.service.ResumeService;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/update_resume")
public class ResumeUpdateController extends HttpServlet {

    private final ResumeService resumeService = new ResumeService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");

        try {
            // JSON 파싱
            StringBuilder json = new StringBuilder();
            String line;
            while ((line = req.getReader().readLine()) != null) {
                json.append(line);
            }
            JSONObject jsonObject = new JSONObject(json.toString());

            int resumeId = jsonObject.getInt("id");
            String title = jsonObject.getString("title");
            JSONArray questions = jsonObject.getJSONArray("questions");
            JSONArray answers = jsonObject.getJSONArray("answers");

            // 업데이트 처리
            resumeService.updateResume(resumeId, title, questions, answers);
            resp.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "업데이트 중 오류가 발생했습니다.");
        }
    }
}

