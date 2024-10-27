<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>메인 페이지</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f9f9f9;
    }
    /* 상단바 스타일 */
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 20px;
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
    /* 메인 컨텐츠 스타일 */
    .main-container {
      display: flex;
      justify-content: center;
      align-items: center;
      height: calc(100vh - 80px); /* 헤더의 높이를 제외한 화면 중앙 배치 */
      padding: 0 20px;
    }
    .main-box {
      display: flex;
      gap: 20px;
      max-width: 1200px;
      width: 100%;
    }
    .box {
      flex: 1;
      padding: 30px;
      text-align: center;
      border: 1px solid #ddd;
      border-radius: 8px;
      background-color: white; /* 기본 배경색 */
      font-size: 18px; /* 글자 크기 조정 */
      transition: background-color 0.3s ease; /* 배경색 변환 시 부드럽게 */
    }
    .box:hover {
      background-color: #e0e0e0; /* 마우스 호버 시 배경색 변경 */
    }
    .box h3 {
      margin-bottom: 10px;
      font-size: 22px; /* 타이틀 글자 크기 조정 */
    }
    .box ul {
      list-style-type: none;
      padding: 0;
      margin-bottom: 20px;
    }
    .box ul li {
      margin-bottom: 5px;
      font-size: 18px;
    }
    .box a {
      text-decoration: none;
      color: inherit; /* 링크가 일반 텍스트처럼 보이도록 설정 */
    }
    .box a:hover {
      text-decoration: underline; /* 마우스 호버 시 밑줄 */
    }
    .dark-box {
      background-color: white; /* 기본 배경색을 흰색으로 설정 */
      color: #333; /* 기본 글자색 */
    }
    .dark-box:hover {
      background-color: #333; /* 마우스 호버 시 어두운 색으로 변경 */
      color: white; /* 글자색을 흰색으로 변경 */
    }
    .dark-box a {
      color: inherit; /* 링크 색상도 기본 텍스트 색상과 동일 */
    }
    .dark-box a:hover {
      text-decoration: underline; /* 마우스 호버 시 밑줄 */
    }
  </style>
</head>
<body>
<!-- 상단바 -->
<div class="header">
  <div class="logo">
  </div>
  <div class="auth-links">
    <a href="qna.jsp">1:1문의</a>
    <a href="login.jsp">login</a>
    <a href="signup.jsp">Register</a>
  </div>
</div>

<!-- 메인 컨텐츠 -->
<div class="main-container">
  <div class="main-box">
    <div class="box dark-box">
      <h3>자기소개서</h3>
      <ul>
        <li><a href="resume.jsp">자기소개서 등록</a></li>
        <li><a href="resume.jsp">자기소개서 조회</a></li>
      </ul>
    </div>
    <div class="box dark-box">
      <h3>면접하기</h3>
      <ul>
        <li><a href="interview.jsp">면접 보러가기</a></li>
        <li><a href="interview.jsp">면접 녹화기록 조회</a></li>
      </ul>
    </div>
    <div class="box dark-box">
      <h3>채용공고</h3>
      <ul>
        <li><a href="jobPosting.jsp">채용공고 보러가기</a></li>
        <li><a href="jobScrap.jsp">저장된 공고 목록</a></li>
      </ul>
    </div>
    <div class="box dark-box">
      <h3>기업분석</h3>
      <ul>
        <li><a href="review.jsp">면접후기</a></li>
      </ul>
    </div>
  </div>
</div>

</body>
</html>