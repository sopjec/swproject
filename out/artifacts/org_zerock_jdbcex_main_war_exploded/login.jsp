<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        /* 모달 스타일 */
        .modal {
            display: none; /* 기본적으로 숨김 */
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 30%;
            text-align: center;
            border-radius: 8px;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }

        .button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-top: 10px;
        }

        .button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<h2>로그인 페이지</h2>
<form action="login" method="post">
    <label for="id">Username:</label>
    <input type="text" id="id" name="id" required><br>
    <label for="pwd">Password:</label>
    <input type="password" id="pwd" name="pwd" required><br>
    <button type="submit">로그인</button>
</form>

<!-- 모달 창 구조 -->
<div id="loginErrorModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <p>로그인에 실패했습니다. 다시 시도해주세요.</p>
        <a href="login.jsp" class="button">로그인으로 돌아가기</a>
        <a href="signup.jsp" class="button">회원가입</a>
    </div>
</div>

<% if (request.getAttribute("loginError") != null) { %>
<script>
    document.getElementById("loginErrorModal").style.display = "block";
</script>
<% } %>


<script>
    // 로그인 실패 시 모달을 보여줌
    window.onload = function () {
        var modal = document.getElementById("loginErrorModal");
        var span = document.getElementsByClassName("close")[0];

        <% if (request.getAttribute("loginError") != null) { %>
        modal.style.display = "block";
        <% } %>

        // 모달 닫기
        span.onclick = function () {
            modal.style.display = "none";
        }

        // 모달 바깥 클릭 시 닫기
        window.onclick = function (event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    };
</script>

</body>
</html>
