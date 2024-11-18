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
      align-items: center;
      padding: 10px 20px;
      background-color: white;
      border-bottom: 1px solid #ddd;
    }
    .logo {
      width: 100px;
      height: 50px;
      background-image: url('logo.png'); /* 로고 이미지 경로 */
      background-size: contain;
      background-repeat: no-repeat;
      background-position: center;
      margin-right: 20px; /* 로고와 nav 사이 간격 */
    }
    .header nav {
      flex-grow: 1; /* nav가 남은 공간 차지 */
      margin-right: 20px;
    }
    .header nav a {
      float: right;
      margin-left: 20px;
      color: #333;
      text-decoration: none;
      font-size: 16px;
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
</head>

<body>
<!-- 상단바 -->
<div class="header">
  <a href="index.jsp">
    <div class="logo"></div>
  </a>
  <nav>
    <a href="resume.jsp">자소서등록</a>
    <a href="interview.jsp">면접보기</a>
    <a href="jobPosting.jsp">채용공고</a>
    <a href="review.jsp">면접 후기</a>
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
    <a href="logout.jsp">로그아웃</a>
    <%
    } else {
    %>
    <a href="login.jsp">Sign in</a>
    <a href="mypage.jsp">Mypage</a>
    <%
      }
    %>
  </div>
</div>

</body>
</html>
