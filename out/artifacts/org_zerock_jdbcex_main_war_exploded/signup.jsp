<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입</title>
  <style>
    body {
      background-color: #000;
      color: #fff;
      font-family: Arial, sans-serif;
      align-items: center;
      height: 100vh;
      margin: 0;
    }

    .signup-container {
      position: absolute;
      top: 250px;
      left: 720px;
      background-color: #111;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
      width: 440px;
      height: 650px;
      color: #fff;
    }

    .signup-container h2 {
      text-align: center;
      margin-bottom: 20px;
      color: #ff69b4;
    }

    .form-group {
      margin-bottom: 15px;
    }

    .form-group label {
      display: block;
      margin-bottom: 5px;
      color: #fff;
    }

    .form-group input,
    .form-group select {
      width: 94%;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
      background-color: #333;
      color: #fff;
    }

    .form-group input:focus,
    .form-group select:focus {
      border-color: #ff69b4;
      outline: none;
      box-shadow: 0 0 5px rgba(255, 105, 180, 0.7);
    }

    .signup-btn {
      width: 100%;
      padding: 10px;
      background-color: #ff69b4;
      border: none;
      color: white;
      font-size: 16px;
      border-radius: 5px;
      cursor: pointer;
    }

    .signup-btn:hover {
      background-color: #ff1493;
    }

    .signup-container p {
      text-align: center;
      margin-top: 10px;
    }

    .signup-container p a {
      color: #ff69b4;
      text-decoration: none;
    }

    .signup-container p a:hover {
      text-decoration: underline;
    }
  </style>
</head>

<body>

<div id="header"></div>

<div class="signup-container">
  <h2>회원가입</h2>
  <form action="signup" method="post">
    <div class="form-group">
      <input type="text" id="name" name="name" placeholder="이름" required>
    </div>
    <br>
    <div class="form-group">
      <input type="email" id="email" name="email" placeholder="이메일" required>
    </div>
    <br>
    <div class="form-group">
      <input type="text" id="id" name="id" placeholder="아이디" required>
    </div>
    <br>
    <div class="form-group">
      <input type="password" id="pwd" name="pwd" placeholder="비밀번호" required>
    </div>
    <br>
    <div class="form-group">
      <input type="password" id="confirm_password" name="confirm_password" placeholder="비밀번호 확인" required>
    </div>
    <br>

    <!-- 성별 선택 -->
    <div class="form-group">
      <label>성별</label>
      <input type="radio" id="female" name="gender" value="female" required> 여성
      <input type="radio" id="male" name="gender" value="male" required> 남성
    </div>
    <br>

    <!-- 생년월일 선택 -->
    <div class="form-group">
      <label>생년월일</label>
      <select id="year" name="year" required></select>
      <select id="month" name="month" required>
        <option value="">월</option>
        <% for (int i = 1; i <= 12; i++) { %>
        <option value="<%= i %>"><%= i %></option>
        <% } %>
      </select>
      <select id="day" name="day" required>
        <option value="">일</option>
        <% for (int i = 1; i <= 31; i++) { %>
        <option value="<%= i %>"><%= i %></option>
        <% } %>
      </select>
    </div>
    <br>

    <button type="submit" class="signup-btn">회원가입</button>
    <br>
  </form>
  <p>이미 회원이신가요? <a href="login.jsp">로그인</a></p>
</div>

<script>
  // 현재 연도를 기준으로 100년 전까지의 연도 생성
  const yearSelect = document.getElementById("year");
  const currentYear = new Date().getFullYear();
  for (let year = currentYear; year >= currentYear - 100; year--) {
    const option = document.createElement("option");
    option.value = year;
    option.textContent = year;
    yearSelect.appendChild(option);
  }

  // header.html 파일을 불러와서 #header div에 삽입
  fetch('header.jsp')
          .then(response => response.text())
          .then(data => {
            document.getElementById('header').innerHTML = data;
          });
</script>

</body>

</html>
