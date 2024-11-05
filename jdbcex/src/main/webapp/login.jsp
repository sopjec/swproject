<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 페이지</title>

    <!-- 로그인 페이지에만 적용될 CSS -->
    <style>
        /* 전체 페이지 배경 및 기본 스타일 */
        body {
            background-color: #f9f9f9;
            color: #333;
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        /* 입력 필드 스타일 */
        input[type="text"],
        input[type="password"] {
            width: 95%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            background-color: #fff;
            color: #333;
        }
        /* 입력 필드에 포커스가 갔을 때 스타일 */
        input[type="text"]:focus,
        input[type="password"]:focus {
            border-color: #333;
            outline: none;
            box-shadow: 0 0 5px rgba(0, 0, 0, 0.2);
        }
        /* 로그인 버튼 스타일 */
        button {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        /* 버튼에 마우스를 올렸을 때 배경색 변경 */
        button:hover {
            background-color: #000;
        }
        /* 메인 페이지 링크 스타일 */
        .link {
            display: block;
            margin-top: 20px;
            color: #333;
            text-decoration: none;
            text-align: center;
            font-size: 14px;
        }
        .link:hover {
            text-decoration: underline;
        }
        /* 로그인 폼의 스타일 */
        .container {
            width: 400px;
            padding: 40px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin: 150px auto;
        }
        h1 {
            color: #333;
            text-align: center;
        }
    </style>
</head>

<body>
    <!-- 상단바 -->
    <iframe src="header.jsp" style="border:none; width:100%; height:100px;"></iframe>

    <div class="container">
        <h1>로그인</h1>
        <form action="login.jsp" method="POST">
            <input type="text" name="username" id="input-user-id" placeholder="아이디" required>
            <input type="password" name="password" id="input-user-password" placeholder="비밀번호" required>
            <button type="submit">로그인</button>
        </form>

        <a href="index.jsp" class="link">계정을 잃어버리셨나요?</a>
        <a href="signup.jsp" class="link">계정이 없으신가요?</a>
    </div>

</body>
</html>
