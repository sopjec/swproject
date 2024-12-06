package org.zerock.jdbcex.servlet;

import org.zerock.jdbcex.dao.EmotionDAO;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/api/save-expression")
public class SaveExpressionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 요청과 응답 인코딩 설정
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        try {
            // 요청 데이터에서 감정 정보 추출
            StringBuilder stringBuilder = new StringBuilder();
            BufferedReader reader = req.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                stringBuilder.append(line);
            }
            String requestBody = stringBuilder.toString();

            // JSON 데이터 파싱
            JSONObject jsonObject = new JSONObject(requestBody);
            int interviewId = jsonObject.getInt("interviewId");
            String emotionType = jsonObject.getString("type");
            double emotionValue = jsonObject.getDouble("value");

            System.out.println("Emotion Data Received - Interview ID: " + interviewId
                    + ", Type: " + emotionType
                    + ", Value: " + emotionValue);

            // 감정 데이터를 DB에 저장하는 로직 (DAO 호출)
            EmotionDAO.saveEmotion(interviewId, emotionType, emotionValue);

            // 성공적으로 저장되었을 경우 응답
            resp.setStatus(HttpServletResponse.SC_OK);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
