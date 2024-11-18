<%@ page import="org.zerock.jdbcex.dto.ResumeQnaDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자기소개서 세부 정보</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
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
        .sidebar ul li a {
            text-decoration: none;
            color: #333;
            font-size: 16px;
            display: block;
            padding: 10px 0;
        }
        .sidebar ul li a:hover {
            background-color: #c6c6c6;
        }
        .resume-container {
            width: 100%;
            margin: 0;
            padding: 20px;
            max-width: 800px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .title-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .question-box {
            margin-bottom: 15px;
        }
        .question {
            font-weight: bold;
            color: #333;
        }
        .answer {
            margin-top: 5px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #f9f9f9;
        }
        .edit-button, .save-button {
            padding: 8px 15px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .edit-button:hover, .save-button:hover {
            background-color: black;
        }

        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
    </style>
    <script>
        function enableEditing() {
            // 제목을 텍스트박스로 변경
            const titleElement = document.getElementById("resumeTitle");
            const titleValue = titleElement.textContent;
            titleElement.innerHTML = `<input type="text" id="titleInput" value="${titleValue}" style="width: 100%; padding: 5px;">`;

            // 질문/답변을 텍스트박스로 변경
            const questions = document.querySelectorAll('.question');
            const answers = document.querySelectorAll('.answer');
            questions.forEach((q, index) => {
                const questionValue = q.textContent.replace('질문: ', '');
                q.innerHTML = `<input type="text" class="question-input" value="${questionValue}" style="width: 100%; padding: 5px;">`;
            });
            answers.forEach((a, index) => {
                const answerValue = a.textContent.replace('답변: ', '');
                a.innerHTML = `<textarea class="answer-input" style="width: 100%; padding: 5px;">${answerValue}</textarea>`;
            });

            // 저장 버튼 표시
            const saveButton = document.createElement("button");
            saveButton.textContent = "저장하기";
            saveButton.className = "save-button";
            saveButton.onclick = saveChanges;
            document.querySelector(".resume-container").appendChild(saveButton);
        }

        function saveChanges() {
            const title = document.getElementById("titleInput").value;
            const questions = Array.from(document.querySelectorAll('.question-input')).map(input => input.value);
            const answers = Array.from(document.querySelectorAll('.answer-input')).map(input => input.value);
            const resumeId = '<%= request.getParameter("id") %>';

            // 데이터 전송
            fetch('/update_resume', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ id: resumeId, title, questions, answers })
            })
                .then(response => {
                    if (response.ok) {
                        alert("수정이 완료되었습니다.");
                        location.reload(); // 새로고침
                    } else {
                        alert("수정 중 오류가 발생했습니다.");
                    }
                });
        }

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

<!-- 헤더가 로드될 위치 -->
<div id="header-container"></div>


<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="resume.jsp">자기소개서 등록</a></li>
            <li><a href="resume">자기소개서 조회</a></li>
            <li><a href="resume_analyze.jsp">자기소개서 분석</a></li>
        </ul>
    </div>

    <div class="resume-container">
        <div class="title-row">
            <h2 id="resumeTitle"><%= request.getAttribute("title") %></h2>
            <button class="edit-button" onclick="enableEditing()">수정하기</button>
        </div>
        <hr>
        <% List<ResumeQnaDTO> qnaList = (List<ResumeQnaDTO>) request.getAttribute("qnaList"); %>
        <% if (qnaList != null) {
            for (ResumeQnaDTO qna : qnaList) { %>
        <div class="question-box">
            <p class="question">질문: <%= qna.getQuestion() %></p>
            <p class="answer">답변: <%= qna.getAnswer() %></p>
        </div>
        <% } } else { %>
        <p>질문과 답변이 없습니다.</p>
        <% } %>
    </div>
</div>
</body>
</html>
