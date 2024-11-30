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
            background-color: #f9f9f9;
            color: #333;
            font-family: Arial, sans-serif;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .signup-container {
            position: absolute;
            top: 250px;
            left: 50%;
            transform: translateX(-50%);
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 440px;
            height: 620px;
            color: #333;
        }

        .signup-container h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
        }

        .form-group input,
        .form-group select {
            width: 94%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #fff;
            color: #333;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #333;
            outline: none;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
        }

        .signup-btn {
            width: 100%;
            padding: 10px;
            background-color: #333;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
        }

        .signup-btn:hover {
            background-color: #000;
        }

        .signup-container p {
            text-align: center;
            margin-top: 10px;
        }

        .signup-container p a {
            color: #333;
            text-decoration: none;
        }

        .signup-container p a:hover {
            text-decoration: underline;
        }
    </style>
    <script>

        // 오늘 날짜를 생년월일 기본값으로 설정하는 함수
        function setTodayDate() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById("date_of_birth").value = today;
        }

        window.onload = function() {
            loadHeader(); // 페이지가 로드될 때 헤더를 불러옴
            setTodayDate(); // 생년월일 기본값을 오늘 날짜로 설정
        };
    </script>
</head>

<body>


<jsp:include page="header.jsp"/>

<div class="signup-container">
    <h2>회원가입</h2>
    <!-- 폼 시작, 데이터 전송 방식은 POST, 처리 파일은 signup_process.php -->
    <form action="signup" method="post" enctype="multipart/form-data">
        <!-- 아이디 입력 필드 -->
        <div class="form-group">
            <input type="text" id="id" name="id" placeholder="아이디" required>
        </div>

        <!-- 비밀번호 입력 필드 -->
        <div class="form-group">
            <input type="password" id="pwd" name="pwd" placeholder="비밀번호" required>
        </div>

        <!-- 이름 입력 필드 -->
        <div class="form-group">
            <input type="text" id="name" name="name" placeholder="이름" required>
        </div>

        <!-- 성별 선택 필드 -->
        <div class="form-group">
            <select id="gender" name="gender" required>
                <option value="">성별 선택</option>
                <option value="남">남</option>
                <option value="여">여</option>
            </select>
        </div>

        <!-- 생년월일 입력 필드 -->
        <div class="form-group">
            <input type="date" id="date_of_birth" name="date_of_birth" required>
        </div>

        <!-- 회원가입 버튼 -->
        <button type="submit" class="signup-btn">회원가입</button>
    </form>

    <!-- 이미 계정이 있으면 로그인 페이지로 이동하는 링크 -->
    <p>이미 회원이신가요? <a href="login.jsp">로그인</a></p>
</div>

</body>
</html>
