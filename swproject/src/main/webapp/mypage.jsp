<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.zerock.jdbcex.dto.UserDTO" %> <!-- UserDTO 클래스 임포트 -->
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이 페이지</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }

        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }

        .sidebar {
            width: 200px;
            padding: 20px;
            background-color: white;
            border-right: 1px solid #ddd;
        }
        .sidebar ul {
            list-style-type: none;
            padding: 0;
        }
        .sidebar ul li {
            margin-bottom: 10px;
        }
        .sidebar ul li a {
            text-decoration: none;
            color: #333;
            font-size: 16px;
            cursor: pointer;
        }
        .sidebar li:hover {
            background-color: #c6c6c6;
        }

        h2 {
            text-align: left;
        }

        .content {
            flex-grow: 1;
            padding-left: 20px;
        }

        #profileImage {
            width: 100px;
            height: 100px;
            display: block;
            margin: 0 auto 20px auto;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #ddd;
            background-color: #ffffff;
        }
        .custom-file-upload {
            height: 25px;
            width: 130px;
            font-size: 14px;
            line-height: 25px;
            text-align: center;
            color: white;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #333;
            margin: 10px auto;
            display: block;
            cursor: pointer;
        }
        .custom-file-upload:hover {
            background-color: #000;
        }

        .authSection {
            max-width: 400px;
            padding: 20px;
            text-align: center;
            margin: 0 auto;
        }
        .authSection input[type="text"],
        .authSection input[type="password"] {
            height: 40px;
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .authSection button {
            height: 50px;
            width: 50%;
            padding: 10px;
            background-color: #333;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .authSection button:hover {
            background-color: #000;
        }

        #account-info span {
            font-size: 16px;
            color: #555;
        }
    </style>

    <script>
        function loadHeader() {
            fetch("header.jsp")
                .then(response => response.text())
                .then(data => {
                    document.getElementById("header-container").innerHTML = data;
                })
                .catch(error => console.error("Error loading header:", error));
        }

        window.onload = loadHeader;
    </script>
</head>

<body>

<!-- 세션에서 loggedInUser 가져오기 -->
<%
    UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp"); // 로그인되지 않은 경우 로그인 페이지로 리디렉트
        return;
    }
%>

<!-- 헤더가 로드될 위치 -->
<div id="header-container"></div>

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="mypage.jsp">내계정</a></li>
            <li><a href="resume">자기소개서 조회</a></li>
            <li><a href="interview_view.jsp">면접 녹화 기록 조회</a></li>
            <li><a href="jobScrap.jsp">저장된 공고 목록</a></li>
        </ul>
    </div>

    <div class="content">
        <h2>내계정</h2>

        <!-- 프로필 사진 및 업로드 -->
        <form action="updateProfile" method="post" enctype="multipart/form-data">
            <img src="<%= loggedInUser.getProfileUrl() %>" alt="프로필 이미지" id="profileImage">
            <label for="profileImageUpload" class="custom-file-upload">프로필 사진 변경</label>
            <input type="file" id="profileImageUpload" name="profileImageUpload" accept="image/*" style="display: none;">

            <div class="authSection">
                <input type="text" name="id" id="id" placeholder="아이디" value="<%= loggedInUser.getId() %>" required readonly/>
                <input type="password" name="password" class="password" placeholder="비밀번호" required/>
                <button type="submit" class="submit">저장</button>
                <p id="authError" style="color: red; display: none;">아이디 또는 비밀번호가 일치하지 않습니다.</p>
            </div>
        </form>
    </div>
</div>

<script>
    document.getElementById("profileImageUpload").addEventListener("change", function(event) {
        const file = event.target.files[0];
        if (file) {
            const reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById("profileImage").src = e.target.result;
            };
            reader.readAsDataURL(file);
        }
    });
</script>

</body>
</html>
