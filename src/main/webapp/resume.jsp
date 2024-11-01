<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            overflow-x: hidden; /* 가로 스크롤 제거 */
        }
        .section {
            display: none;
            width: 100%;
        }

        .section.active {
            display: block;
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
        .sidebar ul li {
            margin-bottom: 10px;
            cursor: pointer;
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
        .question-answer {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            width: 100%;
        }
        .question-answer textarea {
            width: 100%;
            max-width: 100%;
            min-height: 60px;
            resize: none;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
            overflow: hidden;
        }
        .remove-btn {
            padding: 5px 10px;
            margin-right: 10px;
            background-color: red;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
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
            <li onclick="showSection('section1')">자기소개서 등록</li>
            <li onclick="showSection('section2')">자기소개서 조회</li>
        </ul>
    </div>

    <div class="content">
        <div id="section1" class="section active">
            <h2>자기소개서 등록</h2>
            <form id="question-form" action="${pageContext.request.contextPath}/resume" method="post">
                <div class="title-input" style="display: flex; align-items: center; gap: 10px;">
                    <input type="text" name="title" placeholder="자기소개서 제목을 입력하세요" id="resume-title" style="flex: 1; padding: 10px; font-size: 14px; height: 42px; box-sizing: border-box;">
                    <button type="button" onclick="submitForm()" style="height: 42px; padding: 0 20px;">등록</button>
                </div>
                <div id="questions-container">
                    <div class="question-answer" style="display: block; margin-bottom: 20px;">
                        <textarea name="question" placeholder="질문" style="width: 100%; max-width: 100%; min-height: 80px; padding: 10px; font-size: 14px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; overflow: hidden;"></textarea>
                        <textarea name="answer" placeholder="답변" style="width: 100%; max-width: 100%; min-height: 80px; padding: 10px; font-size: 14px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; overflow: hidden; margin-top: 10px;"></textarea>
                    </div>
                </div>
                <button type="button" onclick="addQuestion()"> + 질답 추가</button>

            </form>
        </div>

        <div id="section2" class="section">
            <h2>자기소개서 조회</h2>
            <p>이력서 조회하기</p>
        </div>
    </div>
</div>

<script>
    function showSection(sectionId) {
        var sections = document.querySelectorAll('.section');
        sections.forEach(function (section) {
            section.classList.remove('active');
        });
        var activeSection = document.getElementById(sectionId);
        activeSection.classList.add('active');
    }

    function submitForm() {
        const title = document.getElementById("resume-title").value;
        if (title.trim() === "") {
            alert("자기소개서 제목을 입력해주세요.");
            return;
        }
        document.getElementById("question-form").submit();
    }

    function addQuestion() {
        const container = document.getElementById('questions-container');
        const newQuestionAnswer = document.createElement('div');
        newQuestionAnswer.classList.add('question-answer');
        newQuestionAnswer.style.display = 'block';
        newQuestionAnswer.style.marginBottom = '20px';
        newQuestionAnswer.innerHTML = `
        <textarea name="question" placeholder="질문" style="width: 100%; max-width: 100%; min-height: 80px; padding: 10px; font-size: 14px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; overflow: hidden;"></textarea>
        <textarea name="answer" placeholder="답변" style="width: 100%; max-width: 100%; min-height: 80px; padding: 10px; font-size: 14px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; overflow: hidden; margin-top: 10px;"></textarea>
    `;
        container.appendChild(newQuestionAnswer);
    }

    function removeQuestion(button) {
        const questionAnswerDiv = button.parentElement;
        questionAnswerDiv.remove();
    }
</script>
</body>
</html>
