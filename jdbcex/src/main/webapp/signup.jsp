<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입</title>
  <!-- 페이지 스타일을 정의 -->
  <style>
    body {
      background-color: #000;
      /* 블랙 배경 */
      color: #fff;
      /* 기본 텍스트 화이트 */
      font-family: Arial, sans-serif;
      align-items: center;
      height: 100vh;
      /* 화면 전체 높이 */
      margin: 0;
      /* 기본 여백 제거 */
    }
    /* 회원가입 폼 컨테이너 스타일 */

    .signup-container {
      position: absolute;
      top: 250px;
      left: 720px;
      background-color: #111;
      /* 어두운 배경 */
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
      width: 440px;
      height: 520px;
      color: #fff;
    }
    /* 회원가입 제목 스타일 */

    .signup-container h2 {
      text-align: center;
      margin-bottom: 20px;
      color: #ff69b4;
      /* 핑크 색상 */
    }
    /* 입력 그룹을 감싸는 div 스타일 */

    .form-group {
      margin-bottom: 15px;
    }
    /* 입력 필드의 라벨 스타일 */

    .form-group label {
      display: block;
      margin-bottom: 5px;
      color: #fff;
    }
    /* 입력 필드 스타일 */

    .form-group input {
      width: 94%;
      /* 가로 길이를 조금 줄임 */
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
      background-color: #333;
      /* 어두운 입력 필드 */
      color: #fff;
    }
    /* 입력 필드에 포커스 시 스타일 */

    .form-group input:focus {
      border-color: #ff69b4;
      /* 포커스 시 핑크 테두리 */
      outline: none;
      box-shadow: 0 0 5px rgba(255, 105, 180, 0.7);
      /* 핑크 포커스 그림자 */
    }
    /* 회원가입 버튼 스타일 */

    .signup-btn {
      width: 100%;
      padding: 10px;
      background-color: #ff69b4;
      /* 핑크 버튼 */
      border: none;
      color: white;
      font-size: 16px;
      border-radius: 5px;
      cursor: pointer;
    }
    /* 버튼 호버 시 스타일 변화 */

    .signup-btn:hover {
      background-color: #ff1493;
      /* 더 진한 핑크 */
    }
    /* 하단에 표시되는 '이미 회원이신가요?' 텍스트 스타일 */

    .signup-container p {
      text-align: center;
      margin-top: 10px;
    }

    .signup-container p a {
      color: #ff69b4;
      /* 핑크 링크 */
      text-decoration: none;
    }

    .signup-container p a:hover {
      text-decoration: underline;
    }
  </style>
</head>

<body>

<div id="header"></div>

<!-- 회원가입 폼을 담고 있는 컨테이너 -->
<div class="signup-container">
  <h2>회원가입</h2>
  <!-- 폼 시작, 데이터 전송 방식은 POST, 처리 파일은 signup_process.php -->
  <form action="signup" method="post">
    <!-- 이름 입력 필드 -->
    <div class="form-group">
      <input type="text" id="name" name="name" placeholder="이름" required>
    </div>
    <br>
    <!-- 이메일 입력 필드 -->
    <div class="form-group">
      <input type="email" id="email" name="email" placeholder="이메일" required>
    </div>
    <br>
    <!-- 아이디 입력 필드 -->
    <div class="form-group">
      <input type="text" id="id" name="id" placeholder="아이디" required>
    </div>
    <br>
    <!-- 비밀번호 입력 필드 -->
    <div class="form-group">
      <input type="password" id="pwd" name="pwd" placeholder="비밀번호" required>
    </div>
    <br>
    <!-- 비밀번호 확인 입력 필드 -->
    <div class="form-group">
      <input type="password" id="confirm_password" name="confirm_password" placeholder="비밀번호 확인" required>
    </div>
    <br>
    <!-- 회원가입 버튼 -->
    <button type="submit" class="signup-btn">회원가입</button>
    <br>
  </form>
  <!-- 이미 계정이 있으면 로그인 페이지로 이동하는 링크 -->
  <p>이미 회원이신가요? <a href="login.jsp">로그인</a></p>
</div>

<script>
  // header.html 파일을 불러와서 #header div에 삽입
  fetch('header.jsp')
          .then(response => response.text())
          .then(data => {
            document.getElementById('header').innerHTML = data;
          });
</script>

</body>

