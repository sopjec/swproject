package org.zerock.jdbcex.controller;

import org.json.JSONException;
import org.json.JSONObject;
import org.zerock.jdbcex.dto.InterviewQnADTO;
import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.InterviewQnAService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;

@WebServlet("/interview")
public class InterviewController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            // URL에서 전달된 resumeId 파라미터를 읽음
            String resumeId = req.getParameter("resumeId");
            System.out.println("Resume ID: " + resumeId);

            if (resumeId == null || resumeId.isEmpty()) {
                System.out.println("Resume ID is missing or invalid.");
                resp.sendRedirect("error.jsp");
                return;
            }

            // 세션 확인
            HttpSession session = req.getSession(false);
            if (session == null) {
                System.out.println("No session found. Redirecting to login.");
                resp.sendRedirect("login.jsp");
                return;
            }

            // 세션 속성에서 사용자 정보를 가져옴
            UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
            if (loggedInUser == null) {
                System.out.println("User not logged in. Redirecting to login.");
                resp.sendRedirect("login.jsp");
                return;
            }

            // resumeId를 요청 속성에 저장하여 JSP에서 사용 가능하도록 함
            req.setAttribute("resumeId", resumeId);

            // 인터뷰 페이지로 전달
            req.getRequestDispatcher("interview.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");


        try {
            // JSON 요청 본문 읽기
            StringBuilder jsonBuilder = new StringBuilder();
            try (BufferedReader reader = req.getReader()) {
                String line;
                while ((line = reader.readLine()) != null) {
                    jsonBuilder.append(line);
                }
            }

            // JSON 파싱
            JSONObject jsonObject = new JSONObject(jsonBuilder.toString());
            System.out.println("요청 데이터: " + jsonObject);

            // JSON 데이터에서 값 추출
            int interviewId = jsonObject.getInt("interviewId");
            String question = jsonObject.getString("question");
            String answer = jsonObject.optString("answer", ""); // 답변이 없으면 빈 문자열

            // 세션 가져오기
            HttpSession session = req.getSession(false);
            if (session == null) {
                System.out.println("No session found. Unauthorized access.");
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
                return;
            }

            // 세션에서 사용자 정보 확인
            UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
            if (loggedInUser == null) {
                System.out.println("User not logged in. Unauthorized access.");
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
                return;
            }

            // 사용자 ID 가져오기
            String userId = loggedInUser.getId();
            System.out.println("로그인된 사용자 ID: " + userId);

            // DTO 설정
            InterviewQnADTO qna = new InterviewQnADTO();
            qna.setInterviewId(interviewId);
            qna.setQuestion(question);
            qna.setAnswer(answer);
            qna.setUser_id(userId);

            // 서비스 호출
            InterviewQnAService interviewQnAService = new InterviewQnAService();
            int num = interviewQnAService.insertQnA(qna);
            System.out.println(num + "행 추가되었습니다.");

            // 성공 응답
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            JSONObject responseJson = new JSONObject();
            responseJson.put("status", "success");
            resp.getWriter().write(responseJson.toString());
        } catch (JSONException e) {
            System.out.println("Invalid JSON format: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
        }
    }

}
