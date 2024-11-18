<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>

    <!-- 페이지 스타일 정의 -->
    <style>
        /* 전체 페이지 배경 및 기본 스타일 */
        body {
            background-color: #f0f2f5;
            color: #333;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            flex-direction: column;
        }

        /* 헤더 영역 */
        #header-container {
            width: 100%;
            position: fixed;
            top: 0;
            left: 0;
            background-color: white;
            padding: 0;
            text-align: center;
            z-index: 10;
        }

        /* 로그인 컨테이너 스타일 */
        .login-container {
            width: 400px;
            padding: 40px 30px;
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
            text-align: center;
            margin-top: 100px; /* 헤더 아래쪽에 위치하도록 여백 추가 */
        }

        /* 제목 스타일 */
        .login-container h2 {
            color: #333;
            font-weight: bold;
            margin-bottom: 20px;
            font-size: 24px;
        }

        /* 입력 필드 스타일 */
        .form-group input[type="text"],
        .form-group input[type="password"] {
            width: 90%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
            background-color: #f9f9f9;
            color: #333;
            transition: border-color 0.3s;
        }

        /* 입력 필드 포커스 스타일 */
        .form-group input[type="text"]:focus,
        .form-group input[type="password"]:focus {
            border-color: #007bff;
            outline: none;
            box-shadow: 0 0 8px rgba(0, 123, 255, 0.2);
        }

        /* 로그인 버튼 스타일 */
        .login-btn {
            width: 100%;
            padding: 12px;
            margin-top: 20px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 18px;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        /* 버튼에 마우스를 올렸을 때 */
        .login-btn:hover {
            background-color: #000;
        }

        /* 하단 텍스트와 링크 스타일 */
        .login-container p {
            margin-top: 20px;
            font-size: 14px;
            color: #666;
        }

        .login-container p a {
            color: #333;
            text-decoration: none;
        }

        .login-container p a:hover {
            text-decoration: underline;
        }
    </style>
    <script>
        // header.html 파일을 불러오는 함수
        function loadHeader() {
            fetch("header.jsp")
                .then(response => response.text())
                .then(data => {
                    document.getElementById("header-container").innerHTML = data;
                })
                .catch(error => console.error("Error loading header:", error));
        }

        window.onload = loadHeader; // 페이지가 로드될 때 헤더를 불러옴
    </script>
</head>

<body>

<!-- 고정된 헤더 -->
<div id="header-container"></div>

<!-- 로그인 폼 -->
<div class="login-container">
    <h2>로그인</h2>
    <form action="login" method="POST">
        <div class="form-group">
            <input type="text" name="id" id="input-user-id" placeholder="아이디" required>
        </div>
        <div class="form-group">
            <input type="password" name="pwd" id="input-user-password" placeholder="비밀번호" required>
        </div>
        <button type="submit" class="login-btn">로그인</button>
    </form>

    <p>계정을 잃어버리셨나요? <a href="index.jsp">도움 받기</a></p>
    <p>계정이 없으신가요? <a href="signup.jsp">회원가입</a></p>
</div>

</body>
</html>
