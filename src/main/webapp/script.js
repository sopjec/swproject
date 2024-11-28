// 웹캠 및 녹화 설정
let stream;
let mediaRecorder;
let recordedChunks = [];

async function startInterview() {
    try {
        // 사용자에게 비디오 및 오디오 권한 요청
        stream = await navigator.mediaDevices.getUserMedia({
            video: true,
            audio: true
        });

        // 비디오 요소에 스트림 연결
        const userWebcam = document.getElementById('user-webcam');
        userWebcam.srcObject = stream;
        userWebcam.play();

        // 미디어 녹화를 위한 설정
        mediaRecorder = new MediaRecorder(stream);
        recordedChunks = [];

        mediaRecorder.ondataavailable = function(event) {
            if (event.data.size > 0) {
                recordedChunks.push(event.data);
            }
        };

        mediaRecorder.start();
        console.log('면접 시작');

        // 권한 요청 성공 후 첫 질문 생성
        const initialQuestion = "자기소개를 해주세요.";
        displayQuestion(initialQuestion);
        /*await generateInitialQuestion();    ->이렇게 수정하기*/
    } catch (err) {
        console.error('웹캠 접근 오류: ', err);
        alert('웹캠과 마이크에 접근할 수 없습니다. 권한을 확인해주세요.');
    }
}

function stopRecording() {
    if (mediaRecorder && mediaRecorder.state !== 'inactive') {
        mediaRecorder.stop();
        console.log('녹화 종료');
        saveRecording();
    }
}

function saveRecording() {
    const blob = new Blob(recordedChunks, { type: 'video/webm' });
    const url = URL.createObjectURL(blob);
    const downloadLink = document.createElement('a');
    downloadLink.href = url;
    downloadLink.download = 'interview_recording.webm';
    downloadLink.textContent = '녹화 영상 다운로드';
    document.body.appendChild(downloadLink);
    downloadLink.click();
}

// 이벤트 리스너 설정
document.getElementById('start-interview').addEventListener('click', startInterview);
document.getElementById('stop-recording').addEventListener('click', stopRecording);
document.getElementById('next-question').addEventListener('click', () => {
    alert('다음 질문으로 이동합니다.');
});

// OpenAI API URL 및 키 설정
const OPENAI_API_URL = "https://api.openai.com/v1/completions";
const OPENAI_API_KEY = "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"; // OpenAI에서 발급받은 키

// 텍스트 출력 영역 가져오기
const interviewerTextOutput = document.getElementById("interviewer-text-output");

// 면접 질문 생성 함수 (GPT API 호출)
async function generateQuestion(previousQuestion) {
    const prompt = `
        다음 면접 질문을 생성해주세요.
        이전 질문: "${previousQuestion}"
        새로운 면접 질문:
    `;

    try {
        // GPT API 요청
        const response = await fetch(OPENAI_API_URL, {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
                "Authorization": `Bearer ${OPENAI_API_KEY}`,
            },
            body: JSON.stringify({
                model: "text-davinci-003",
                prompt: prompt,
                max_tokens: 100,
                temperature: 0.7,
            }),
        });

        // 응답 처리
        if (response.ok) {
            const data = await response.json();
            const newQuestion = data.choices[0].text.trim();
            displayQuestion(newQuestion);
        } else {
            console.error("Error generating question:", response.status, response.statusText);
            displayQuestion("질문 생성 중 오류가 발생했습니다.");
        }
    } catch (error) {
        console.error("Fetch error:", error);
        displayQuestion("질문 생성 중 오류가 발생했습니다.");
    }
}

// 질문 표시 함수
function displayQuestion(question) {
    interviewerTextOutput.innerText = question;
}

// "다음 질문" 클릭 이벤트
document.getElementById('next-question').addEventListener('click', async () => {
    const questions = await fetchQuestionFromDB(); // DB에서 질문 가져오기
    const previousQuestion = interviewerTextOutput.innerText;

    // 이전 질문과 다른 질문을 가져옴
    const nextQuestion = questions.find(q => q.question !== previousQuestion);
    if (nextQuestion) {
        displayQuestion(nextQuestion.question);
    } else {
        alert('모든 질문이 표시되었습니다.');
    }
});

// "면접 시작" 버튼 클릭 이벤트
document.getElementById('start-interview').addEventListener('click', startInterview);

// "녹화 종료" 버튼 클릭 이벤트
document.getElementById('stop-recording').addEventListener('click', stopRecording);

// DB에서 질문 가져오기
async function fetchQuestionFromDB() {
    try {
        const response = await fetch('/api/questions'); // 경로가 서버와 일치하도록 설정
        if (response.ok) {
            const questions = await response.json(); // JSON 형식의 질문 데이터
            return questions; // 질문 배열 반환
        } else {
            console.error('질문 조회 실패:', response.status, response.statusText);
            return [];
        }
    } catch (error) {
        console.error('Fetch 에러:', error);
        return [];
    }
}

// 초기 질문 생성 함수
async function generateInitialQuestion() {
    const questions = await fetchQuestionFromDB(); // DB에서 질문 가져오기
    if (questions.length > 0) {
        displayQuestion(questions[0].question); // 첫 번째 질문 표시
    } else {
        displayQuestion('질문이 없습니다.'); // 질문이 없을 경우
    }
}
