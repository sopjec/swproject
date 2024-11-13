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
      width: 100px; /* 로고 크기 */
      height: 50px; /* 로고 크기 */
      background-image: url('logo.png'); /* 로고 이미지 경로 */
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
    .auth-links {
      display: flex;
      gap: 10px;
    }
    .auth-links a {
      text-decoration: none;
      padding: 10px 15px;
      border: 1px solid #ddd;
      border-radius: 4px;
      color: #333;
    }
    .auth-links a:hover {
      background-color: #f0f0f0;
    }
    /* 메인 레이아웃 설정 */
    .container {
      display: flex;
      max-width: 1200px;
      margin: 20px auto;
      padding: 0 20px;
    }
  </style>
</head>

<body>
<!-- 상단바 -->
<div class="header">
  <div class="logo"><a href="index.jsp"></a></div>
  <nav>
    <a href="jobPosting.jsp">채용공고</a>
    <a href="interview.jsp">면접보기</a>
    <a href="resume.jsp">자소서등록</a>
    <a href="review.jsp">면접 후기</a>
  </nav>
  <div class="auth-links">
    &nbsp;
    <a href="login.jsp">Sign in</a>
    <a href="mypage.jsp">Mypage</a>
  </div>
</div>

</body>
</html>
