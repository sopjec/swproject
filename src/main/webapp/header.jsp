<%@ page import="org.zerock.jdbcex.dto.UserDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
      margin: 0;
      padding: 0;
    }
    .section {
      display: none;
      width: 100%;
    }
    .section.active {
      display: block;
    }
    /* 상단바 스타일 */
    .header {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      padding: 10px 20px;
      background-color: white;
      border-bottom: 1px solid #ddd;
    }
    .logo {
      width: 100px;
      height: 50px;
      /*background-image: url('logo.png'); /* 로고 이미지 경로 */
      background-size: contain;
      background-repeat: no-repeat;
      background-position: center;
      margin-right: auto;
    }
    .header nav a {
      margin-left: 20px;
      color: #333;
      text-decoration: none;
      font-size: 16px;
    }

    nav {
      padding-right: 15px;
    }

    /* 프로필 사진과 사용자 ID 스타일 */
    .auth-links {
      display: flex;
      align-items: center;
      gap: 10px;
    }
    .auth-links .profile-pic {
      width: 40px; /* 프로필 사진 크기 */
      height: 40px;
      border-radius: 50%; /* 동그라미 모양 */
      object-fit: cover; /* 사진을 영역에 맞게 자름 */
      border: 2px solid #ddd; /* 테두리 추가 */
      background-color: #ffffff; /* 기본 배경색 흰색 */
    }
    .auth-links .username {
      font-weight: bold;
      color: #333;
      font-size: 16px;
      text-decoration: none;
      cursor: pointer;
    }
    .auth-links .username:hover {
      color: #007bff; /* 호버 시 색상 변경 */
    }
    .auth-links a {
      text-decoration: none;
      padding: 8px 12px;
      border: 1px solid #ddd;
      border-radius: 4px;
      color: #333;
      font-size: 16px;
    }
    .auth-links a:hover {
      background-color: #f0f0f0;
      border-color: #bbb;
    }
  </style>
  <script>
    document.addEventListener("DOMContentLoaded", function () {
      const modal = document.getElementById("login-modal");
      const closeModal = document.getElementById("close-modal");
      const goLogin = document.getElementById("go-login");

      closeModal.addEventListener("click", () => {
        modal.style.display = "none";
      });

      goLogin.addEventListener("click", () => {
        window.location.href = "login.jsp";
      });

      function checkSessionAndNavigate(url) {
        const xhr = new XMLHttpRequest();
        xhr.open("GET", "/checkSession", true);
        xhr.onload = function () {
          if (xhr.status === 200) {
            const response = JSON.parse(xhr.responseText);
            if (response.isLoggedIn) {
              // 세션이 있으면 URL로 이동
              window.location.href = url;
            } else {
              // 세션이 없으면 모달창 표시
              modal.style.display = "block";
            }
          } else {
            console.error("세션 확인 중 오류 발생");
          }
        };
        xhr.send();
      }

      // 페이지 내에서 사용하는 함수도 이벤트 리스너 안에 포함
      window.checkSessionAndNavigate = checkSessionAndNavigate;
    });

  </script>
</head>

<body>
<!-- 상단바 -->
<div class="header">
  <div class="logo">
    <a href="index.jsp">
      <img id="logo-img" src="logo.png" alt="Logo" style="width: 100%; height: 100%;">
    </a>
  </div>
  <nav>
    <a href="#" onclick="checkSessionAndNavigate('resume.jsp'); return false;">자소서관리</a>
    <a href="#" onclick="checkSessionAndNavigate('/resume?action=interview'); return false;">가상면접</a>
    <a href="jobPosting.jsp">채용공고</a>
    <a href="review.jsp">커뮤니티</a> <!--면접후기 이름 수정-->
  </nav>
  <div class="auth-links">
    <%
      // 세션에서 로그인한 사용자 정보를 가져옴
      UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
      if (loggedInUser != null) {
        String profileImagePath = loggedInUser.getProfileUrl(); // 프로필 이미지 경로
        String userId = loggedInUser.getId(); // 사용자 ID
    %>
    <!-- 프로필 사진과 사용자 아이디 표시 -->
    <img src="<%= (profileImagePath != null && !profileImagePath.isEmpty()) ? profileImagePath : "default-profile.png" %>"
         alt="Profile Picture" class="profile-pic">
    <a href="mypage.jsp" class="username"><%= userId %>님</a> <!-- 아이디 클릭 시 mypage.jsp로 이동 -->
    <a href="logout">로그아웃</a>
    <%
    } else {
    %>
    <a href="login.jsp">log in</a>
    <a href="mypage.jsp">Mypage</a>
    <%
      }
    %>
  </div>
</div>

</body>
</html>