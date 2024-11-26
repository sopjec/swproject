package org.zerock.jdbcex.controller;

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

@WebServlet("/resume")
public class ResumeController extends HttpServlet {

    private final ResumeService resumeService = new ResumeService();
    private final ResumeQnaService resumeQnaService = new ResumeQnaService();

    private static final String GPT_API_URL = "https://api.openai.com/v1/chat/completions";
    private static final String GPT_API_KEY = "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"; // OpenAI API 키 입력

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 요청 데이터 인코딩 설정
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // UserDTO 객체에서 userId 가져오기
        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
        String userId = loggedInUser.getId(); // UserDTO의 userId 필드 사용

        String title = req.getParameter("resumeTitle");
        System.out.println("받은 제목: " + title); // 디버그 출력

        String[] questions = req.getParameterValues("question");
        String[] answers = req.getParameterValues("answer");

        try {
            // Resume 저장
            ResumeDTO resume = new ResumeDTO();
            resume.setTitle(title);
            resume.setUserId(userId);
            resumeService.addResume(resume);

            // 질문/답변 저장
            if (questions != null && answers != null) {
                for (int i = 0; i < questions.length; i++) {
                    ResumeQnaDTO qna = new ResumeQnaDTO();
                    qna.setResumeId(resume.getId());
                    qna.setQuestion(questions[i]);
                    qna.setAnswer(answers[i]);
                    resumeQnaService.addQna(qna);
                }
            }

            resp.sendRedirect("resume_view.jsp");
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

}