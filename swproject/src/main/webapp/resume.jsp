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
            box-sizing: border-box;
        }

        .title-input {
            margin-bottom: 20px;
        }

        .title-input input {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #DDD;
            border-radius: 4px;
            box-sizing: border-box;
        }

        #container {
            display: flex;
            align-items: flex-start;
            width: 100%;
            box-sizing: border-box;
        }

        .controls {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
            margin-right: 20px;
        }

        .number-box {
            width: 40px;
            height: 40px;
            background-color: #f0f0f0;
            color: #343434;
            font-size: 14px;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
            border-radius: 4px;
            border: 1px solid #ddd;
            cursor: pointer;
        }

        .number-box.selected {
            background-color: #343434;
            color: white;
        }

        .control-box {
            width: 40px;
            height: 40px;
            background-color: white;
            color: #2c2c2c;
            border: 1px solid #343434;
            border-radius: 4px;
            font-size: 18px;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
            cursor: pointer;
        }

        .control-box:hover {
            background-color: #343434;
            color: white;
        }

        .question-group {
            flex-grow: 1;
            border: 1px solid #DDD;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            background-color: #FFF;
            box-sizing: border-box;
        }

        .question-content h3 {
            margin: 10px 0;
            font-size: 16px;
            font-weight: bold;
        }

        .question-content input {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            font-size: 14px;
            border: 1px solid #DDD;
            border-radius: 4px;
        }

        .question-content textarea {
            width: 100%;
            height: 100px;
            padding: 10px;
            margin-top: 3px;
            margin-bottom: 10px;
            font-size: 14px;
            border: 1px solid #DDD;
            border-radius: 4px;
            resize: none;
        }

        .question-content button {
            padding: 8px 12px;
            background-color: #343434;
            color: #FFF;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 3px;
        }

        .question-content button:hover {
            background-color: #343434;
        }

        .char-count {
            font-size: 10px;
            color: #888;
            text-align: right;
            margin-top: -5px;
        }

        /* 하단 고정 영역 */
        .footer-bar {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background-color: #f1f1f1;
            border-top: 1px solid #ddd;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            box-sizing: border-box;
            z-index: 100;
        }

        .footer-bar button {
            padding: 10px 20px;
            background-color: #343434;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }

        .footer-bar button:hover {
            background-color: #343434;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 사이드바 -->
    <div class="sidebar">
        <ul>
            <li><a href="resume.jsp">자기소개서 등록</a></li>
            <li><a href="resume_view.jsp">자기소개서 조회</a></li>
            <li><a href="resume_analyze.jsp">자기소개서 분석</a></li>
        </ul>
    </div>
    <!-- 메인 콘텐츠 -->
    <div class="content">
        <!-- 자소서 제목 입력 -->
        <div class="title-input">
            <input type="text" placeholder="자기소개서 제목을 입력하세요" id="resumeTitle">
        </div>
        <div id="container">
            <!-- 숫자 박스와 +, - 버튼 -->
            <div id="controls-container" class="controls">
                <div class="number-box selected" id="box1" onclick="selectQuestion(1)">1</div>
                <div class="control-box" id="addQuestion">+</div>
                <div class="control-box" id="removeQuestion" style="display: none;">-</div>
            </div>

            <!-- 문항 리스트 -->
            <div id="question-list" style="flex-grow: 1;">
                <div class="question-group" id="question1">
                    <div class="question-content">
                        <h3>1번 문항</h3>
                        <input type="text" placeholder="지원 동기, 입사 후 포부와 같은 문항을 입력해 주세요">
                        <textarea name="answer" placeholder="내용을 입력해 주세요" maxlength="500" oninput="updateCharCount(this)"></textarea>
                        <div class="char-count">0 / 500 자 (공백 포함)</div>
                        <button>문항 예시보기</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 하단 고정 버튼 -->
<div class="footer-bar">
    <span>작성 후 완료 버튼을 눌러주세이.</span>
    <button id="saveButton">작성완료</button>
</div>

<script>
    let totalQuestions = 1;
    let selectedQuestion = 1;

    function selectQuestion(number) {
        document.querySelectorAll(".number-box").forEach(box => box.classList.remove("selected"));
        const selectedBox = document.getElementById(`box${number}`);
        selectedBox.classList.add("selected");
        selectedQuestion = number;
    }

    document.getElementById("addQuestion").addEventListener("click", () => {
        totalQuestions++;
        const newNumberBox = document.createElement("div");
        newNumberBox.classList.add("number-box");
        newNumberBox.id = `box${totalQuestions}`;
        newNumberBox.textContent = totalQuestions;
        newNumberBox.onclick = () => selectQuestion(totalQuestions);
        document.getElementById("controls-container").insertBefore(newNumberBox, document.getElementById("addQuestion"));

        const newQuestion = document.createElement("div");
        newQuestion.classList.add("question-group");
        newQuestion.id = `question${totalQuestions}`;
        newQuestion.innerHTML = `
            <div class="question-content">
                <h3>${totalQuestions}번 문항</h3>
                <input type="text" placeholder="지원 동기, 입사 후 포부와 같은 문항을 입력해 주세요">
                <textarea name="answer" placeholder="내용을 입력해 주세요" maxlength="500" oninput="updateCharCount(this)"></textarea>
                <div class="char-count">0 / 500 자 (공백 포함)</div>
                <button>문항 예시보기</button>
            </div>
        `;
        document.getElementById("question-list").appendChild(newQuestion);
        document.getElementById("removeQuestion").style.display = "flex";
    });

    document.getElementById("removeQuestion").addEventListener("click", () => {
        if (totalQuestions > 1) {
            document.getElementById(`question${totalQuestions}`).remove();
            document.getElementById(`box${totalQuestions}`).remove();
            totalQuestions--;
            if (totalQuestions === 1) document.getElementById("removeQuestion").style.display = "none";
        }
    });

    function updateCharCount(textarea) {
        const charCountElement = textarea.parentElement.querySelector(".char-count");
        charCountElement.textContent = `${textarea.value.length} / ${textarea.maxLength} 자 (공백 포함)`;
    }
</script>
</body>
</html>