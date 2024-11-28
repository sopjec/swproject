// 질문과 답변 입력란 추가 기능
// '질답 추가' 버튼을 클릭했을 때 새로운 질문과 답변 입력란을 추가함
function addQuestion() {
    const container = document.getElementById('questions-container');// 질문과 답변을 포함할 컨테이너를 선택
    const newQuestionAnswer = document.createElement('div');// 새로운 'div' 요소를 생성
    newQuestionAnswer.classList.add('question-answer');// 'question-answer' 클래스를 추가하여 스타일 적용
    newQuestionAnswer.innerHTML = `
        <textarea name="question" placeholder="질문"></textarea>
        <textarea name="answer" placeholder="답변"></textarea>
    `;// HTML 코드를 추가하여 질문과 답변 입력란을 생성
    container.appendChild(newQuestionAnswer);// 컨테이너에 새로운 질문/답변 박스를 추가
    initializeTextareas(); //새로 추가된 textarea에도 자동 높이 조절 기능을 적용
}

// 모든 textarea에 대해 자동 높이 조절 설정
function initializeTextareas() {
    const textareas = document.querySelectorAll('textarea');
    textareas.forEach(textarea => {
        textarea.style.height = 'auto';
        textarea.style.overflowY = 'hidden'; // 스크롤바 숨김
        adjustTextareaHeight(textarea);

        // 입력 이벤트 발생 시 높이를 다시 조정하여 입력 내용에 맞게 크기를 변경
        textarea.addEventListener('input', function() {
            adjustTextareaHeight(this);
        });
    });
}

// 높이를 자동으로 조절하는 함수
// textarea의 높이를 내용에 맞게 조절
function adjustTextareaHeight(element) {
    element.style.height = 'auto'; // 높이를 초기화하여 스크롤 높이를 정확히 계산
    element.style.height = (element.scrollHeight) + 'px'; // 내용에 맞게 높이 조절
}

// 등록 버튼 클릭 시 알림창 표시 기능
// 사용자가 '등록' 버튼을 클릭하면, 등록 완료 메시지를 표시
function submitForm() {
    const title = document.getElementById("resume-title").value;
    if (title.trim() === "") {
        alert("자기소개서 제목을 입력해주세요.");
        return;
    }
    alert("자기소개서가 등록되었습니다.");
}
