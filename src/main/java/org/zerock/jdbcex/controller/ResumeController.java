package org.zerock.jdbcex.controller;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import org.zerock.jdbcex.dto.ResumeDTO;
import org.zerock.jdbcex.dto.ResumeQnaDTO;
import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.ResumeQnaService;
import org.zerock.jdbcex.service.ResumeService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.List;
import java.util.Map;

@WebServlet("/resume")
public class ResumeController extends HttpServlet {

    private final ResumeService resumeService = new ResumeService();
    private final ResumeQnaService resumeQnaService = new ResumeQnaService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);

        // 사용자 정보 확인
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId(); // User ID 가져오기

        // 제목 가져오기
        String title = req.getParameter("resumeTitle");
        System.out.println("제목: " + title);

        // 여러 개의 질문과 답변 가져오기
        String[] questions = req.getParameterValues("question");
        String[] answers = req.getParameterValues("answer");

        if (questions == null || answers == null || questions.length != answers.length) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "질문과 답변 데이터가 올바르지 않습니다.");
            return;
        }

        try {
            // Resume 저장
            ResumeDTO resume = new ResumeDTO();
            resume.setTitle(title);
            resume.setUserId(userId);
            resumeService.addResume(resume);

            // QnA 저장
            for (int i = 0; i < questions.length; i++) {
                ResumeQnaDTO qna = new ResumeQnaDTO();
                qna.setResumeId(resume.getId());
                qna.setQuestion(questions[i]);
                qna.setAnswer(answers[i]);
                resumeQnaService.addQna(qna);
            }

            resp.sendRedirect("resume_view");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "데이터 저장 중 오류가 발생했습니다.");
            req.getRequestDispatcher("error.jsp").forward(req, resp);
        }
    }

    // 자기소개서 조회 처리 (GET)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId();

        try {
            // 요청 URI에 따라 다른 동작
            String action = req.getParameter("action");

            if ("view".equals(action)) {
                List<ResumeDTO> resumes = resumeService.getResumesByUserId(userId);
                req.setAttribute("resumes", resumes);
                req.getRequestDispatcher("resume_view.jsp").forward(req, resp);
            } else if ("interview".equals(action)) {
                List<ResumeDTO> resumes = resumeService.getResumesByUserId(userId);
                req.setAttribute("resumes", resumes);
                req.getRequestDispatcher("interview_resume_select.jsp").forward(req, resp);
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 요청입니다.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터 조회 중 오류가 발생했습니다.");
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId();

        // DELETE 요청의 body에서 JSON 데이터를 읽음
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }

        // JSON 파싱
        String jsonBody = sb.toString();
        Gson gson = new Gson(); // Google Gson 라이브러리를 사용 (또는 다른 라이브러리 사용 가능)
        Map<String, Object> payload = gson.fromJson(jsonBody, Map.class);

        String id = String.valueOf(payload.get("id"));

        try {
            int intId = Integer.parseInt(id);
            resumeService.removeResume(intId, userId);
            resumeQnaService.deleteQnaByResumeId(intId);
            resp.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
