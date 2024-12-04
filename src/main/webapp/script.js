let mediaRecorder;
let recordedChunks = [];
let webcamStream;
let expressionInterval;
let questions = [];
let currentQuestionIndex = 0;
let isFirstQuestionDisplayed = false; // 첫 질문 출력 여부 플래그
let isSpeaking = false; // 음성 재생 상태 플래그
let recognition; // 음성 인식 객체

// URL에서 resumeId 가져오기
const urlParams = new URLSearchParams(window.location.search);
const resumeId = urlParams.get('resumeId'); // URL에서 resumeId 값 추출

if (!resumeId) {
    alert('resumeId가 URL에 포함되지 않았습니다. URL을 확인하세요.');
    throw new Error('resumeId가 누락되었습니다.');
}

// 텍스트 음성 읽기 함수
function readTextAloud(text, onEndCallback) {
    if (!window.speechSynthesis) {
        console.error('이 브라우저는 Web Speech API를 지원하지 않습니다.');
        return;
    }

    if (isSpeaking) {
        window.speechSynthesis.cancel(); // 현재 음성 정지
    }

    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = 'ko-KR';
    utterance.rate = 1; // 읽는 속도
    utterance.pitch = 1; // 음 높이

    utterance.onstart = () => {
        isSpeaking = true;
    };

    utterance.onend = () => {
        isSpeaking = false;
        if (onEndCallback) onEndCallback();
    };

    speechSynthesis.speak(utterance);
}

// Face-api.js 모델 로드
async function loadModels() {
    try {
        console.log('Face-api.js 모델 로드 시작');
        await faceapi.nets.tinyFaceDetector.loadFromUri('/models');
        console.log('tinyFaceDetector 모델 로드 성공');
        await faceapi.nets.faceExpressionNet.loadFromUri('/models');
        console.log('faceExpressionNet 모델 로드 성공');
    } catch (error) {
        console.error('Face-api.js 모델 로드 중 오류:', error);
    }
}

// 실시간 감정 분석
async function analyzeExpressions() {
    const video = document.getElementById('user-webcam');
    const expressionOutput = document.getElementById('user-expression-output'); // 웹캠 아래 텍스트 출력

    expressionInterval = setInterval(async () => {
        try {
            const detections = await faceapi
                .detectSingleFace(video, new faceapi.TinyFaceDetectorOptions())
                .withFaceExpressions();

            if (detections) {
                const expressions = detections.expressions;
                const dominantExpression = Object.keys(expressions).reduce((a, b) =>
                    expressions[a] > expressions[b] ? a : b
                );

                expressionOutput.innerHTML = `현재 표정: ${dominantExpression} (${(expressions[dominantExpression] * 100).toFixed(2)}%)`;
                console.log('감정 분석 결과:', expressions);
            } else {
                expressionOutput.innerHTML = '얼굴이 감지되지 않았습니다.';
                console.warn('얼굴이 감지되지 않았습니다.');
            }
        } catch (error) {
            console.error('감정 분석 중 오류:', error);
        }
    }, 500); // 500ms 간격으로 분석
}

// 음성 인식 초기화
function initSpeechRecognition() {
    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    if (!SpeechRecognition) {
        console.error('이 브라우저는 SpeechRecognition API를 지원하지 않습니다.');
        return null;
    }

    const recognizer = new SpeechRecognition();
    recognizer.lang = 'ko-KR';
    recognizer.interimResults = true;
    recognizer.continuous = true;
    return recognizer;
}

// 음성 인식 시작
function startSpeechRecognition() {
    const userTextOutput = document.getElementById('user-text-output');
    recognition = initSpeechRecognition();

    if (!recognition) return;

    recognition.start();
    console.log('음성 인식 시작');

    recognition.onresult = (event) => {
        let transcript = '';
        for (let i = event.resultIndex; i < event.results.length; ++i) {
            transcript += event.results[i][0].transcript;
        }
        userTextOutput.innerHTML += ' ' + transcript; // 텍스트를 누적하여 출력
        console.log('음성 인식 결과:', transcript);
    };

    recognition.onerror = (event) => {
        console.error('음성 인식 오류:', event.error);
    };

    recognition.onend = () => {
        console.log('음성 인식 종료');
    };
}

// 질문 생성 및 음성 출력
async function generateQuestionAndSpeak() {
    try {
        const response = await fetch('/api/generate-question', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: new URLSearchParams({ resumeId }),
        });

        if (response.ok) {
            const data = await response.json();
            console.log("서버 응답 데이터:", data); // 서버 응답 확인

            // 인터뷰 ID 저장
            interviewId = data.interviewId;
            console.log("인터뷰 ID:", interviewId);

            // 응답 데이터 처리
            if (data.questions && Array.isArray(data.questions)) {
                questions = data.questions; // 질문 배열 저장
                currentQuestionIndex = 0; // 첫 번째 질문으로 초기화

                if (questions.length > 0) {
                    const question = `질문 ${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]}`;
                    // 질문 텍스트를 interviewer-text-output에 출력
                    document.getElementById('interviewer-text-output').innerText = question;
                    console.log('현재 질문 출력:', question);

                    // 음성으로 읽기 및 음성 인식 시작
                    readTextAloud(question, startSpeechRecognition);
                } else {
                    console.error('질문 데이터가 비어 있습니다.');
                    document.getElementById('interviewer-text-output').innerText = '질문 데이터가 없습니다.';
                }
            } else {
                console.error('서버 응답에 질문 데이터가 없습니다:', data);
                document.getElementById('interviewer-text-output').innerText = '질문 데이터 처리 중 오류 발생';
            }
        } else {
            console.error('서버 오류:', response.statusText);
            document.getElementById('interviewer-text-output').innerText = '질문 생성 중 서버 오류 발생';
        }
    } catch (error) {
        console.error('질문 생성 중 오류:', error);
        document.getElementById('interviewer-text-output').innerText = '질문 생성 중 오류 발생';
    }
}

// 페이지 녹화 시작
async function startPageRecording() {
    try {
        const screenStream = await navigator.mediaDevices.getDisplayMedia({
            video: { cursor: "always" },
            audio: false,
        });

        const micStream = await navigator.mediaDevices.getUserMedia({
            audio: true,
        });

        const combinedStream = new MediaStream([
            ...screenStream.getVideoTracks(),
            ...micStream.getAudioTracks(),
        ]);

        mediaRecorder = new MediaRecorder(combinedStream);
        recordedChunks = [];

        mediaRecorder.ondataavailable = (event) => {
            if (event.data.size > 0) {
                recordedChunks.push(event.data);
            }
        };

        mediaRecorder.onstop = () => {
            saveRecording();
            console.log('녹화 중지');
            // 녹화 종료 후 interview_view.jsp로 이동
            window.location.href = 'interviewView';
        };

        mediaRecorder.start();

        // 화면 녹화가 시작된 후 질문 생성 및 음성 출력
        generateQuestionAndSpeak();

        console.log('페이지 녹화가 시작되었습니다.');
    } catch (error) {
        console.error('녹화 시작 중 오류:', error);
    }
}

// 녹화 저장
async function saveRecording() {
    const blob = new Blob(recordedChunks, { type: 'video/webm' });
    const fileName = `recording_${interviewId || 'unknown'}.webm`; // 인터뷰 ID를 파일명에 포함
    const formData = new FormData();
    formData.append('videoFile', blob, 'recording.webm');
    formData.append('resumeId', resumeId); // resumeId를 함께 전송

    try {
        const response = await fetch('/upload-video', {
            method: 'POST',
            body: formData,
        });

        if (response.ok) {
            console.log('녹화본이 서버에 성공적으로 업로드되었습니다.');
        } else {
            console.error('녹화본 업로드 실패:', response.statusText);
        }
    } catch (error) {
        console.error('녹화본 업로드 중 오류:', error);
    }
}

// 면접 시작
async function startInterview() {
    try {
        webcamStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
        document.getElementById('user-webcam').srcObject = webcamStream;

        console.log('웹캠 스트림 연결 성공');
        startPageRecording(); // 녹화 시작과 동시에 질문 생성

        await loadModels(); // 모델 로드
        console.log('감정 분석 시작...');
        analyzeExpressions(); // 감정 분석 시작
    } catch (error) {
        console.error('웹캠 연결 오류:', error);
        alert('웹캠과 마이크 접근 권한을 확인하세요.');
    }
}

// 면접 종료 알림 모달 생성 함수
function createEndInterviewModal() {
    // 모달 요소가 이미 있다면 제거
    const existingModal = document.getElementById('end-interview-modal');
    if (existingModal) {
        existingModal.remove();
    }

    // 모달 요소 생성
    const modal = document.createElement('div');
    modal.id = 'end-interview-modal';
    modal.style.position = 'fixed';
    modal.style.top = '30%'; // 위치 조정
    modal.style.left = '30%'; // 위치 조정
    modal.style.width = '600px'; // 기존 가로 크기의 두 배
    modal.style.height = '450px'; // 기존 세로 크기의 세 배
    modal.style.backgroundColor = 'white';
    modal.style.padding = '20px';
    modal.style.boxShadow = '0 0 15px rgba(0, 0, 0, 0.5)';
    modal.style.zIndex = '1000';
    modal.style.textAlign = 'center';
    modal.style.cursor = 'move'; // 드래그 시 손 모양으로 변경
    modal.style.display = 'flex';
    modal.style.flexDirection = 'column';
    modal.style.justifyContent = 'space-between';

    // 피드백 타이틀 생성
    const feedbackTitle = document.createElement('h3');
    feedbackTitle.innerText = '피드백 내용';
    feedbackTitle.style.marginBottom = '10px'; // 타이틀과 텍스트창 사이 여백 추가
    modal.appendChild(feedbackTitle);

    // 피드백 입력 텍스트 창 생성
    const feedbackTextarea = document.createElement('textarea');
    feedbackTextarea.style.width = '100%';
    feedbackTextarea.style.height = '200px';
    feedbackTextarea.style.resize = 'none'; // 크기 조절 불가
    feedbackTextarea.placeholder = '여기에 피드백을 입력하세요...';
    modal.appendChild(feedbackTextarea);

    // 확인 버튼 생성
    const closeButton = document.createElement('button');
    closeButton.innerText = '확인';
    closeButton.style.alignSelf = 'center'; // 버튼을 중앙으로 정렬
    closeButton.style.marginBottom = '10px'; // 모달 하단에서 약간의 여백 추가
    closeButton.addEventListener('click', () => {
        modal.remove(); // 모달 닫기
    });
    modal.appendChild(closeButton);

    // 드래그 가능하도록 마우스 이벤트 추가
    let offsetX, offsetY;

    modal.addEventListener('mousedown', (e) => {
        offsetX = e.clientX - modal.getBoundingClientRect().left;
        offsetY = e.clientY - modal.getBoundingClientRect().top;

        function mouseMoveHandler(e) {
            modal.style.left = `${e.clientX - offsetX}px`;
            modal.style.top = `${e.clientY - offsetY}px`;
        }

        function mouseUpHandler() {
            document.removeEventListener('mousemove', mouseMoveHandler);
            document.removeEventListener('mouseup', mouseUpHandler);
        }

        document.addEventListener('mousemove', mouseMoveHandler);
        document.addEventListener('mouseup', mouseUpHandler);
    });

    // 모달을 body에 추가
    document.body.appendChild(modal);
}

// 이벤트 리스너 설정
document.getElementById('start-interview').addEventListener('click', startInterview);

document.getElementById('next-question').addEventListener('click', () => {
    if (currentQuestionIndex + 1 < questions.length) {
        currentQuestionIndex++;
        const question = `질문 ${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]}`;
        document.getElementById('interviewer-text-output').innerHTML = question;

        // 면접자 텍스트창 내용 초기화
        setTimeout(() => {
            document.getElementById('user-text-output').innerHTML = '';
        }, 100); // 약간의 지연시간을 주어 초기화가 확실히 되도록 함

        readTextAloud(question, startSpeechRecognition);
    } else {
        document.getElementById('interviewer-text-output').innerText = '모든 질문이 완료되었습니다.';
        alert('면접이 종료되었습니다');
        createEndInterviewModal(); // 질문이 더 이상 없을 때 모달 띄우기
    }
});

document.getElementById('stop-recording').addEventListener('click', () => {
    if (mediaRecorder && mediaRecorder.state === 'recording') {
        mediaRecorder.stop();
        console.log('녹화 중지');
    }
    if (webcamStream) {
        webcamStream.getTracks().forEach(track => track.stop());
        console.log('웹캠 스트림 중지');
    }
});