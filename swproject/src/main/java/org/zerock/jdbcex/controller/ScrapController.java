package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.ScrapService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/scrap") // scrap으로 매핑된 하나의 컨트롤러
public class ScrapController extends HttpServlet {
    private final ScrapService scrapService = new ScrapService();

    // 스크랩 추가 (POST 요청)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        response.setContentType("application/json; charset=UTF-8"); // JSON 형식과 UTF-8 인코딩 설정
        response.setCharacterEncoding("UTF-8"); // 문자 인코딩 UTF-8로 설정

        // 로그인 확인
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("로그인이 필요합니다.");
            return;
        }

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        // JSON 데이터 읽기
        StringBuilder jsonString = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                jsonString.append(line);
            }
        }

        // JSON에서 scrapKey 추출
        String scrapKey = jsonString.toString().replaceAll("\"", "");
        if (scrapKey == null || scrapKey.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("스크랩 키가 유효하지 않습니다.");
            return;
        }

        // 스크랩 추가 처리
        try {
            scrapService.addScrap(loggedInUser.getId(), scrapKey);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("스크랩 성공");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("스크랩 처리 실패");
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);
            if (session == null || session.getAttribute("loggedInUser") == null) {
                resp.sendRedirect("login.jsp");
                return;
            }

            UserDTO user = (UserDTO) session.getAttribute("loggedInUser");
            String userId = user.getId();

            String keyword = req.getParameter("keyword");
            String region = req.getParameter("region");
            String employmentType = req.getParameter("employmentType");

            List<Map<String, String>> jobs = scrapService.fetchScrapJobs(userId);
            List<Map<String, String>> filteredJobs = jobs.stream()
                    .filter(job -> (keyword == null || job.get("title").contains(keyword)) &&
                            (region == null || job.get("region").contains(region)) &&
                            (employmentType == null || job.get("employmentType").contains(employmentType)))
                    .collect(Collectors.toList());

            req.setAttribute("jobData", filteredJobs);
            req.getRequestDispatcher("/jobScrap.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }


    // 스크랩 삭제 (DELETE 요청)
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        response.setContentType("application/json; charset=UTF-8"); // JSON 형식과 UTF-8 인코딩 설정
        response.setCharacterEncoding("UTF-8"); // 문자 인코딩 UTF-8로 설정

        // 로그인 확인
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("로그인이 필요합니다.");
            return;
        }

        UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");

        // JSON 데이터 읽기
        StringBuilder jsonString = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                jsonString.append(line);
            }
        }

        // JSON에서 scrapKey 추출
        String scrapKey = jsonString.toString().replaceAll("\"", "");
        if (scrapKey == null || scrapKey.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("스크랩 키가 유효하지 않습니다.");
            return;
        }

        // 스크랩 삭제 처리
        try {
            scrapService.deleteScrap(loggedInUser.getId(), scrapKey);
            response.setStatus(HttpServletResponse.SC_OK);
            response.getWriter().write("스크랩 삭제 성공");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("스크랩 삭제 실패");
            e.printStackTrace();
        }
    }
}
