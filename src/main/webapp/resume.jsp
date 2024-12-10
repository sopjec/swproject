<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="checkSession.jsp"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/layout.css"> <!-- 올바른 경로 설정 -->
    <title>자기소개서 등록</title>
    <style>
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
            font-size: 15px;
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
            box-sizing: border-box;
            overflow: hidden; /* 스크롤을 숨깁니다. */
            min-height: 50px; /* 최소 높이 */
            height: auto; /* 텍스트에 맞게 높이 자동 조정 */
        }

        /* X축 스크롤 제거 */
        textarea {
            overflow: hidden; /* 스크롤을 숨깁니다. */
            white-space: normal; /* 텍스트 줄바꿈 허용 */
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

        .highlight-words {
            color: #007bff;           /* 파란색 글자색 */
            font-weight: bold;        /* 두꺼운 글자 */
        }

        .highlight-words:hover {
            color: #0056b3;           /* 마우스 오버 시 글자색 변경 */
        }

    </style>

</head>

<body>

<jsp:include page="header.jsp"/>

<div class="container">
    <!-- 사이드바 -->
    <div class="sidebar">
        <ul>
            <li><a href="#" onclick="checkSessionAndNavigate('resume.jsp'); return false;">자기소개서 등록</a></li>
            <li><a href="#" onclick="checkSessionAndNavigate('resume_view'); return false;">자기소개서 조회</a></li>
            <li><a href="#" onclick="checkSessionAndNavigate('resume_analyze.jsp'); return false;">자기소개서 분석</a></li>
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
                                <button onclick="getSpellCheck(this, event)">맞춤법 및 어휘 검사</button>
                                <button onclick="getAICoaching(this, event)">자기소개서 코칭 받기</button>
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
        const selectedBox = document.getElementById("box" + number);
        if (selectedBox) {
            selectedBox.classList.add("selected");
        }

        // 선택된 문항 번호 저장
        selectedQuestion = number;

        // 선택된 문항으로 스크롤 (선택적으로 추가 가능)
        const selectedQuestionBox = document.getElementById("question" + number);
        if (selectedQuestionBox) {
            selectedQuestionBox.scrollIntoView({ behavior: "smooth", block: "center" });
        }
    }


    document.getElementById("addQuestion").addEventListener("click", () => {
        totalQuestions++;

        // 새로운 숫자박스 생성
        const newNumberBox = document.createElement("div");
        newNumberBox.classList.add("number-box");
        newNumberBox.id = "box" + totalQuestions;
        newNumberBox.textContent = totalQuestions;

        // 클릭 이벤트 연결 또는 onclick 속성 추가
        newNumberBox.setAttribute("onclick", "selectQuestion(" + totalQuestions + ")");

        document.getElementById("controls-container").insertBefore(newNumberBox, document.getElementById("addQuestion"));

        // 새로운 문항박스 생성
        const newQuestion = document.createElement("div");
        newQuestion.classList.add("question-group");
        newQuestion.id = "question" + totalQuestions;

        newQuestion.innerHTML =
            "<div class='question-content'>" +
            "<h3>" + totalQuestions + "번 문항</h3>" +
            "<input type='text' name='question' placeholder='지원 동기, 입사 후 포부와 같은 문항을 입력해 주세요'>" +
            "<textarea name='answer' placeholder='내용을 입력해 주세요' maxlength='500' oninput='updateCharCount(this)'></textarea>" +
            "<div class='char-count'>0 / 500 자 (공백 포함)</div>" +
            "<div class='coaching-buttons'>" +
            "<button onclick='getSpellCheck(this, event)'>맞춤법 및 어휘 검사</button>" +
            "<button onclick='getAICoaching(this, event)'>자기소개서 코칭 받기</button>" +
            "</div>" +
            "<div class='result-box' name='resultBox' id='resultBox" + totalQuestions + "'></div>" +
            "</div>";

        document.getElementById("question-list").appendChild(newQuestion);
        document.getElementById("removeQuestion").style.display = "flex"; // 삭제 버튼 활성화

        // 새로 추가된 문항 선택
        selectQuestion(totalQuestions);
    });

    document.getElementById("removeQuestion").addEventListener("click", () => {
        if (totalQuestions > 1) {
            // 선택된 숫자박스와 문항박스 삭제
            const selectedBox = document.getElementById("box" + selectedQuestion);
            const selectedQuestionBox = document.getElementById("question" + selectedQuestion);

            if (selectedBox && selectedQuestionBox) {
                selectedBox.remove();
                selectedQuestionBox.remove();

                // 번호 재정렬
                const numberBoxes = document.querySelectorAll(".number-box");
                const questionGroups = document.querySelectorAll(".question-group");

                numberBoxes.forEach((box, index) => {
                    box.id = "box" + (index + 1);
                    box.textContent = index + 1;
                    box.onclick = () => selectQuestion(index + 1); // 번호에 따라 다시 클릭 이벤트 연결
                });

                questionGroups.forEach((group, index) => {
                    group.id = "question" + (index + 1);
                    group.querySelector("h3").textContent = (index + 1) + "번 문항";
                });

                totalQuestions--;

                // 남아 있는 문항 중 첫 번째 문항 선택
                selectedQuestion = Math.min(selectedQuestion, totalQuestions);
                selectQuestion(selectedQuestion);

                // 문항이 하나 남으면 삭제 버튼 비활성화
                if (totalQuestions === 1) {
                    document.getElementById("removeQuestion").style.display = "none";
                }
            }
        }
    });

    function adjustResultBoxHeight(resultBox) {
        resultBox.style.height = 'auto'; // 높이를 자동으로 조정
        resultBox.style.height = resultBox.scrollHeight + 'px'; // 텍스트 크기에 맞게 높이 설정
    }

    // 글자 수 업데이트
    function updateCharCount(textarea) {
        const charCountElement = textarea.parentElement.querySelector(".char-count");
        charCountElement.textContent = textarea.value.length +"/"+ textarea.maxLength + "자 (공백 포함)";
    }

    // 초기 숫자 박스 선택 상태 설정
    document.querySelector(".number-box").classList.add("selected");

    //글자수 세기
    function updateCharCount(textarea) {
        const charCountElement = textarea.parentElement.querySelector(".char-count");
        charCountElement.textContent = textarea.value.length+"/"+ textarea.maxLength + " 자 (공백 포함)";
    }

    // 맞춤법 검사 및 어휘 교체
    function getSpellCheck(button, event) {
        event.preventDefault(); // 기본 폼 제출 동작 방지
        const questionGroup = button.closest('.question-group');
        const answerTextarea = questionGroup.querySelector('textarea');
        const answerText = answerTextarea.value;
        const resultBoxId = questionGroup.querySelector('.result-box').id; // Result Box ID 가져오기
        console.log(resultBoxId);
        const resultBox = document.getElementById(resultBoxId);
        resultBox.innerHTML = "검사 중 ...";

        console.log("answer : " + answerText);

        fetch('/spellcheck', {
            method: 'POST',
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

                    const formattedText = data.replacedText
                        .replace(/\[/g, "<span class='highlight-words'>")  // [를 <div>로 교체
                        .replace(/\]/g, "</span>");  // ]를 </div>로 교체

                    resultBox.innerHTML = formattedText;  // 텍스트가 아닌 HTML을 렌더링

                   // resultBox.textContent = formattedText; // 결과 텍스트 삽입
                    adjustResultBoxHeight(resultBox);
                } else {
                    alert('어휘 교체 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert('어휘 교체 요청 실패.');
            });
    }
    function getAICoaching(button, event) {
        event.preventDefault(); // 기본 폼 제출 동작 방지
        const questionGroup = button.closest('.question-group');
        const answerTextarea = questionGroup.querySelector('textarea');
        const answerText = answerTextarea.value;
        const resultBoxId = questionGroup.querySelector('.result-box').id; // Result Box ID 가져오기
        const resultBox = document.getElementById(resultBoxId);
        resultBox.innerHTML = "AI 분석 중 ...";

        console.log("answer : " + answerText);

        fetch('/aiCoaching', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8'
            },
            body: JSON.stringify({ text: answerText }) // 답변 텍스트 전송
        })
            .then(response => {
                // 응답 Content-Type 확인
                const contentType = response.headers.get('Content-Type');
                if (contentType && contentType.includes('application/json')) {
                    // JSON 응답 처리
                    return response.json();
                } else {
                    // HTML 응답일 경우 로그인 페이지로 이동
                    return response.text().then(html => {
                        console.error('HTML 응답 반환:', html);
                        alert('로그인이 필요합니다. 로그인 페이지로 이동합니다.');
                        window.location.href = '/login.jsp'; // 로그인 페이지로 리다이렉트
                        throw new Error('HTML 응답 반환');
                    });
                }
            })
            .then(data => {
                if (data && data.replacedText) {
                    console.log("Response Text:", data.replacedText);
                    const questionGroup = button.closest('.question-group'); // 현재 버튼이 포함된 문항 찾기
                    const resultBoxId = questionGroup.querySelector('.result-box').id; // Result Box ID 가져오기

                    const resultBox = document.getElementById(resultBoxId); // Result Box 찾기

                    // 줄바꿈 문자(\n)를 <br> 태그로 변환
                    const formattedText = data.replacedText.replace(/\n/g, "<br>");

                    // HTML 형식으로 결과 삽입
                    resultBox.innerHTML = formattedText;
                    adjustResultBoxHeight(resultBox);
                } else {
                    alert('AI 코칭 중 오류가 발생했습니다.');
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert('AI 코칭 요청 실패: ' + error.message);
            });

    }

    function adjustTextareaHeight(textarea) {
        textarea.style.height = 'auto'; // 기존 높이 초기화
        textarea.style.height = textarea.scrollHeight + 'px'; // 텍스트 크기에 맞게 높이 설정
    }

    // 이벤트 리스너 추가
    document.querySelectorAll('textarea[name="answer"]').forEach(textarea => {
        textarea.addEventListener('input', function() {
            adjustTextareaHeight(this);
        });

        // 페이지 로드 시 초기화
        adjustTextareaHeight(textarea);
    });


</script>
</body>
</html>
