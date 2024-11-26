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
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            background: #fff;
            margin-bottom: 20px;
        }

        .question-content h3 {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .question-content input[type="text"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            box-sizing: border-box;
        }

        .question-content textarea {
            width: 100%;
            height: 120px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            resize: none;
            margin-bottom: 10px;
            box-sizing: border-box;
        }

        .char-count {
            font-size: 12px;
            color: #888;
            text-align: right;
            margin-bottom: 10px;
        }

        .coaching-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }

        .coaching-buttons button {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background: #f8f8f8;
            cursor: pointer;
            font-size: 14px;
            flex-grow: 1;
            text-align: center;
        }

        .coaching-buttons button:hover {
            background: #eee;
        }

        .result-box {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #f9f9f9;
            color: #333;
            height: 100px;
            overflow-y: auto;
            box-sizing: border-box;
        }
        /* 고정된 하단 영역 스타일 */
        .footer-bar {
            position: fixed; /* 화면 고정 */
            bottom: 0; /* 하단에 위치 */
            left: 0; /* 왼쪽 정렬 */
            width: 100%; /* 전체 화면 너비 */
            background-color: #f1f1f1;
            border-top: 1px solid #ddd;
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 1000; /* 다른 요소 위에 위치 */
            box-sizing: border-box;
        }

        .footer-bar button {
            padding: 10px 20px;
            background-color: #343434;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .footer-bar button:hover {
            background-color: #575757;
        }
    </style>

</head>

<body>

<jsp:include page="header.jsp"/>

<div class="container">
    <!-- 사이드바 -->
    <div class="sidebar">
        <ul>
            <li><a href="resume.jsp">자기소개서 등록</a></li>
            <li><a href="resume_view">자기소개서 조회</a></li>
            <li><a href="resume_analyze.jsp">자기소개서 분석</a></li>
        </ul>
    </div>

    <!-- 메인 콘텐츠 -->
    <div class="content">
        <form action="resume" method="POST">
            <div class="title-input">
                <input type="text" name="resumeTitle" id = "resumeTitle" placeholder="자기소개서 제목을 입력하세요">
            </div>

            <div id="container">
                <div id="controls-container" class="controls">
                    <div class="number-box selected" id="box1" onclick="selectQuestion(1)">1</div>
                    <div class="control-box" id="addQuestion">+</div>
                    <div class="control-box" id="removeQuestion" style="display: none;">-</div>
                </div>

                <div id="question-list" style="flex-grow: 1;">
                    <div class="question-group" id="question1">
                        <div class="question-content">
                            <h3>1번 문항</h3>
                            <input id = "question" name = "question" type="text" placeholder="지원 동기, 입사 후 포부와 같은 문항을 입력해 주세요">
                            <textarea id = "answer" name="answer" placeholder="내용을 입력해 주세요" maxlength="500" oninput="updateCharCount(this)"></textarea>
                            <div class="char-count">0 / 500 자 (공백 포함)</div>
                            <div class="coaching-buttons">
                                <button onclick="getSpellCheck(this)">맞춤법 검사 받기</button>
                                <button onclick="getAICoaching(this)">자기소개서 코칭 받기</button>
                            </div>
                            <div class="result-box" name="resultBox" id = "resultBox1"></div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 하단 고정 버튼 -->
            <div class="footer-bar">
                <span>작성 후 완료 버튼을 눌러주세요.</span>
                <button type="submit">작성완료</button>
            </div>
        </form>
    </div>
</div>


<script>
    let totalQuestions = 1; // 전체 문항 수
    let selectedQuestion = 1; // 현재 선택된 문항 번호

    // 숫자박스 선택 함수
    function selectQuestion(number) {
        // 모든 숫자박스에서 선택 해제
        document.querySelectorAll(".number-box").forEach(box => box.classList.remove("selected"));

        // 선택된 숫자박스 강조
        const selectedBox = document.getElementById(`box${number}`);
        selectedBox.classList.add("selected");

        // 선택된 문항 번호 저장
        selectedQuestion = number;
    }

    //문항 추가 기능
    document.getElementById("addQuestion").addEventListener("click", () => {
        totalQuestions++;
        //새로운 숫자 박스 생성
        const newNumberBox = document.createElement("div");
        newNumberBox.classList.add("number-box");
        newNumberBox.id = `box${totalQuestions}`;
        newNumberBox.textContent = totalQuestions;
        newNumberBox.onclick = () => selectQuestion(totalQuestions);
        document.getElementById("controls-container").insertBefore(newNumberBox, document.getElementById("addQuestion"));

        //새로운 문항 박스 생성
        const newQuestion = document.createElement("div");
        newQuestion.classList.add("question-group");
        newQuestion.id = "question"+totalQuestions;

        newQuestion.innerHTML =
            "<div class='question-content'>" +
            "<h3>" + totalQuestions + "번 문항</h3>" +
            "<input type='text' name='question' placeholder='지원 동기, 입사 후 포부와 같은 문항을 입력해 주세요'>" +
            "<textarea name='answer' placeholder='내용을 입력해 주세요' maxlength='500' oninput='updateCharCount(this)'></textarea>" +
            "<div class='char-count'>0 / 500 자 (공백 포함)</div>" +
            "<div class='coaching-buttons'>" +
            "<button onclick='getSpellCheck(this)'>맞춤법 검사 받기</button>" +
            "<button onclick='getAICoaching(this)'>자기소개서 코칭 받기</button>" +
            "</div>" +
            "<div class='result-box' name='resultBox' id='resultBox" + totalQuestions + "'></div>" +
            "</div>";


        document.getElementById("question-list").appendChild(newQuestion); // 문학 박스 추가
        document.getElementById("removeQuestion").style.display = "flex"; // 삭제 버튼 활성화
        selectQuestion(totalQuestions);
    });

    // 문항 삭제 기능
    document.getElementById("removeQuestion").addEventListener("click", () => {
        if (totalQuestions > 1) {
            // 선택된 숫자박스와 문항박스 삭제
            const selectedBox = document.getElementById(`box${selectedQuestion}`);
            const selectedQuestionBox = document.getElementById(`question${selectedQuestion}`);

            if (selectedBox && selectedQuestionBox) {
                selectedBox.remove();
                selectedQuestionBox.remove();

                // 번호 재정렬
                const numberBoxes = document.querySelectorAll(".number-box");
                const questionGroups = document.querySelectorAll(".question-group");

                numberBoxes.forEach((box, index) => {
                    box.id = `box${index + 1}`;
                    box.textContent = index + 1;
                    box.onclick = () => selectQuestion(index + 1); // 번호에 따라 다시 클릭 이벤트 연결
                });

                questionGroups.forEach((group, index) => {
                    group.id = `question${index + 1}`;
                    group.querySelector("h3").textContent = `${index + 1}번 문항`;
                });

                totalQuestions--;

                // 선택된 문항이 삭제된 이후 다른 문항 선택
                selectedQuestion = totalQuestions >= selectedQuestion ? selectedQuestion : totalQuestions;
                if (selectedQuestion > 0) {
                    selectQuestion(selectedQuestion); // 다음 문항 선택
                }

                // 문항이 하나도 남지 않으면 삭제 버튼 비활성화
                if (totalQuestions === 1) {
                    document.getElementById("removeQuestion").style.display = "none";
                }
            }
        }
    });


    // 글자 수 업데이트
    function updateCharCount(textarea) {
        const charCountElement = textarea.parentElement.querySelector(".char-count");
        charCountElement.textContent = `${textarea.value.length} / ${textarea.maxLength} 자 (공백 포함)`;
    }

    // 초기 숫자 박스 선택 상태 설정
    document.querySelector(".number-box").classList.add("selected");

    //글자수 세기
    function updateCharCount(textarea) {
        const charCountElement = textarea.parentElement.querySelector(".char-count");
        charCountElement.textContent = `${textarea.value.length} / ${textarea.maxLength} 자 (공백 포함)`;
    }

    // 맞춤법 검사 및 어휘 교체
    function getSpellCheck(button) {
        // 버튼 기준으로 현재 문항의 Question Group 찾기
        const questionGroup = button.closest('.question-group');

        // 해당 Question Group 안에서 textarea 찾기
        const answerTextarea = questionGroup.querySelector('textarea');
        const answerText = answerTextarea.value; // 답변 내용 가져오기

        console.log("answer : " + answerText);

        fetch('/spellcheck', {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({ text: answerText }) // 답변 텍스트 전송
        })
            .then(response => response.json())
            .then(data => {
                if (data && data.replacedText) {
                    // 결과를 Result Box에 출력
                    console.log("Response Text:", data.replacedText);
                    const questionGroup = button.closest('.question-group'); // 현재 버튼이 포함된 문항 찾기
                    const resultBoxId = questionGroup.querySelector('.result-box').id; // Result Box ID 가져오기

                    const resultBox = document.getElementById(resultBoxId); // Result Box 찾기
                    resultBox.textContent = data.replacedText; // 결과 텍스트 삽입
                } else {
                    alert('어휘 교체 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert('어휘 교체 요청 실패.');
            });
    }
    //자소서 분석 코칭ㅇ긴응
    function getAICoaching(button) {
        const resultBox = button.parentElement.nextElementSibling;
        resultBox.textContent = "AI 코칭 결과: 자기소개서 내용이 훌륭합니다!";
    }


</script>
</body>
</html>
