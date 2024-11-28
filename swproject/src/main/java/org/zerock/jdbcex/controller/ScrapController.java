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
            response.getWriter().write("세션이 만료 되었습니다.");
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

    // GET 요청 - 스크랩된 데이터 표시
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            HttpSession session = req.getSession(false);

            // 로그인 확인
            if (session == null || session.getAttribute("loggedInUser") == null) {
                resp.setContentType("application/json; charset=UTF-8");
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.getWriter().write("{\"message\":\"로그인이 필요합니다.\"}");
                return;
            }

            UserDTO user = (UserDTO) session.getAttribute("loggedInUser");
            String userId = user.getId();

            // 필터 파라미터 가져오기
            String keyword = req.getParameter("keyword");
            String region = req.getParameter("region");
            String employmentType = req.getParameter("employmentType");
            String jobType = req.getParameter("jobType");

            // 페이지네이션 파라미터
            int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
            int pageSize = 9; // 한 페이지에 표시할 공고 수

            // 데이터 가져오기
            List<Map<String, String>> jobData = scrapService.fetchScrapJobs(userId, page, pageSize);

            req.setAttribute("jobData", jobData);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", (int) Math.ceil((double) scrapService.getScrapCount(userId) / pageSize));

            req.getRequestDispatcher("/jobScrap.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터를 처리하는 중 오류가 발생했습니다.");
        }
    }

    // 요청에서 scrapKey 추출
    private String extractScrapKey(HttpServletRequest request) throws IOException {
        StringBuilder jsonString = new StringBuilder();
        try (BufferedReader reader = request.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) {
                jsonString.append(line);
            }
        }
        return jsonString.toString().replaceAll("\"", "").trim();
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
            response.getWriter().write("세션이 만료 되었습니다.");
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
