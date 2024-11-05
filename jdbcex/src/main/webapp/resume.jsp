<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자기소개서 등록</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }
        .header {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 10px 20px;
            background-color: white;
            border-bottom: 1px solid #ddd;
        }
        .header .logo {
            font-size: 24px;
            font-weight: bold;
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
        .container {
            display: flex;
            width: 100%;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
            box-sizing: border-box;
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
        .content {
            flex-grow: 1;
            padding-left: 20px;
            max-width: 100%;
            width: 100%;
            box-sizing: border-box;
        }
        button {
            padding: 5px 10px;
            margin: 5px 0;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        button:hover {
            background-color: black;
        }
        .question-answer-wrapper {
            display: flex;
            align-items: flex-start;
            margin-bottom: 10px;
        }
        .question-checkbox {
            margin-right: 10px;
            margin-top: 10px;
        }
        .question-answer {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .question-answer textarea {
            width: 100%;
            max-width: 100%;
            resize: none;
            padding: 8px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            overflow: hidden;
            margin-bottom: 5px;
        }
        .title-input {
            display: flex;
            align-items: center;
            margin-top: 10px;
            gap: 10px;
            max-width: 100%;
        }
        .title-input input {
            flex: 1;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 4px;
            height: 42px;
            box-sizing: border-box;
        }
        .title-input button {
            height: 42px;
            padding: 0 20px;
            box-sizing: border-box;
        }
    </style>
</head>

<body>
    <div class="header">
        <div class="logo">로고</div>
        <nav>
            <a href="jobPosting.html">채용공고</a>
            <a href="interview.html">면접보기</a>
            <a href="resume.html">자소서등록</a>
            <a href="review.html">기업분석</a>
        </nav>
        <div class="auth-links">
            <a href="login.html">Sign in</a>
            <a href="mypage.html">Mypage</a>
        </div>
    </div>

    <div class="container">
        <div class="sidebar">
            <ul>
                <li><a href="resume.html">자기소개서 등록</a></li>
                <li><a href="resume_view.html">자기소개서 조회</a></li>
                <li><a href="resume_analyze.html">자기소개서 분석</a></li>
            </ul>
        </div>

        <div class="content">
            <h2>자기소개서 등록</h2>
            <div class="title-input">
                <input type="text" placeholder="자기소개서 제목을 입력하세요" id="resume-title">
                <button type="button" onclick="submitForm()">등록</button>
            </div>

            <form id="question-form">
                <div id="questions-container">
                    <div class="question-answer-wrapper">
                        <input type="checkbox" class="question-checkbox">
                        <div class="question-answer">
                            <textarea name="question" placeholder="질문"></textarea>
                            <textarea name="answer" placeholder="답변"></textarea>
                        </div>
                    </div>
                </div>
                <button type="button" onclick="addQuestion()">+ 질답 추가</button>
                <button type="button" onclick="deleteSelectedQuestions()">삭제</button>
            </form>
        </div>
    </div>

    <script>
        function submitForm() {
            alert("등록이 완료되었습니다.");
        }

        function addQuestion() {
            const container = document.getElementById('questions-container');
            const newQuestionAnswerWrapper = document.createElement('div');
            newQuestionAnswerWrapper.classList.add('question-answer-wrapper');
            newQuestionAnswerWrapper.innerHTML = `
                <input type="checkbox" class="question-checkbox">
                <div class="question-answer">
                    <textarea name="question" placeholder="질문"></textarea>
                    <textarea name="answer" placeholder="답변"></textarea>
                </div>
            `;
            container.appendChild(newQuestionAnswerWrapper);
            initializeTextareas();
        }

        function initializeTextareas() {
            const textareas = document.querySelectorAll('textarea');
            textareas.forEach(textarea => {
                textarea.style.height = 'auto';
                textarea.style.overflowY = 'hidden';
                adjustTextareaHeight(textarea);
                textarea.addEventListener('input', function() {
                    adjustTextareaHeight(this);
                });
            });
        }

        function adjustTextareaHeight(element) {
            element.style.height = 'auto';
            element.style.height = element.scrollHeight + 'px';
        }

        function deleteSelectedQuestions() {
            const checkboxes = document.querySelectorAll('.question-checkbox:checked');
            checkboxes.forEach(checkbox => {
                const questionAnswerWrapper = checkbox.closest('.question-answer-wrapper');
                questionAnswerWrapper.remove();
            });
        }

        window.onload = initializeTextareas;
    </script>
</body>
</html>
