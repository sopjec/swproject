package org.zerock.jdbcex.controller;

import org.zerock.jdbcex.dto.UserDTO;
import org.zerock.jdbcex.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/signup")
public class SignUpController extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 회원가입 폼에서 데이터 가져오기
        String id = request.getParameter("id");
        String pwd = request.getParameter("pwd");
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String profileUrl = request.getParameter("profileUrl"); // 프로필 URL 입력 필드가 있다면 추가
        String dateOfBirth = request.getParameter("dateOfBirth");

        // DTO 생성
        UserDTO user = new UserDTO(id, pwd, name, gender, profileUrl, dateOfBirth);

        // 회원가입 처리
        boolean isRegistered = userService.registerUser(user);

        if (isRegistered) {
            // 성공 시 로그인 페이지로 리다이렉트
            response.sendRedirect("login.jsp");
        } else {
            // 실패 시 회원가입 페이지로 리다이렉트
            response.sendRedirect("signup.jsp?error=true");
        }
    }
}
