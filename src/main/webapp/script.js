let mediaRecorder;
let recordedChunks = [];
let webcamStream;
let expressionInterval;
let questions = [];
let currentQuestionIndex = 0;
let isFirstQuestionDisplayed = false; // 첫 질문 출력 여부 플래그
let isSpeaking = false; // 음성 재생 상태 플래그

// URL에서 resumeId 가져오기
const urlParams = new URLSearchParams(window.location.search);
const resumeId = urlParams.get('resumeId'); // URL에서 resumeId 값 추출

if (!resumeId) {
    alert('resumeId가 URL에 포함되지 않았습니다. URL을 확인하세요.');
    throw new Error('resumeId가 누락되었습니다.');
}

// 텍스트 음성 읽기 함수
function readTextAloud(text) {
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

// 면접 시작 버튼 클릭 시 질문 데이터를 가져오는 함수
document.getElementById('start-interview').addEventListener('click', async () => {
    if (isFirstQuestionDisplayed) {
        console.warn('첫 질문이 이미 출력되었습니다.');
        return; // 중복 실행 방지
    }

    startInterview(); // 면접 시작
    startPageRecording();
});

// 다음 질문 버튼 클릭 시 동작
document.getElementById('next-question').addEventListener('click', () => {
    if (questions.length === 0) {
        document.getElementById('interviewer-text-output').innerText = '먼저 면접을 시작하세요.';
        return;
    }

    currentQuestionIndex++;
    if (currentQuestionIndex < questions.length) {
        const question = `질문 ${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]}`;
        document.getElementById('interviewer-text-output').innerHTML = question;
        readTextAloud(question); // 다음 질문 음성으로 읽기
    } else {
        document.getElementById('interviewer-text-output').innerText = '모든 질문을 완료했습니다.';
        currentQuestionIndex--;

        stopRecording(); // 녹화 종료
        alert('면접이 끝났습니다.');
    }
});

// 면접 시작
async function startInterview() {
    try {
        console.log('웹캠 연결 시도 중...');
        webcamStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
        const userWebcam = document.getElementById('user-webcam');
        if (userWebcam) userWebcam.srcObject = webcamStream;
        console.log('웹캠 스트림이 성공적으로 연결되었습니다.');

        await loadModels(); // 모델 로드
        console.log('감정 분석 시작...');
        analyzeExpressions(); // 감정 분석 시작
    } catch (error) {
        console.error('웹캠 연결 오류:', error);
        alert('웹캠과 마이크에 접근할 수 없습니다. 권한을 확인해주세요.');
    }
}

// 페이지 녹화 시작
async function startPageRecording() {
    try {
        // 화면 스트림 요청
        const screenStream = await navigator.mediaDevices.getDisplayMedia({
            video: { cursor: "always" }, // 마우스 커서 포함
            audio: false
        });

        // 화면 스트림과 웹캠 스트림 병합
        const combinedStream = new MediaStream([
            ...screenStream.getVideoTracks(),
            ...webcamStream.getVideoTracks(),
            ...webcamStream.getAudioTracks()
        ]);

        // MediaRecorder로 병합된 스트림 녹화
        mediaRecorder = new MediaRecorder(combinedStream);
        recordedChunks = [];

        mediaRecorder.ondataavailable = function (event) {
            if (event.data.size > 0) {
                recordedChunks.push(event.data);
            }
        };

        mediaRecorder.onstop = saveRecording; // 녹화 종료 시 저장
        mediaRecorder.start();

        console.log('페이지 녹화가 시작되었습니다.');
    } catch (error) {
        console.error('페이지 녹화 중 오류:', error);
        alert('페이지 녹화 중 문제가 발생했습니다.');
    }
    try {
        const response = await fetch('/api/generate-question', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({ resumeId }),
        });

        if (response.ok) {
            const data = await response.json();
            questions = data.question.split('\n').filter(q => q.trim() !== '');
            questions = questions.map(q => q.replace(/^\d+\.\s*/, '')); // 접두어 제거
            currentQuestionIndex = 0; // 첫 질문 인덱스 초기화

            if (questions.length > 0) {
                const question = `질문 ${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]}`;
                document.getElementById('interviewer-text-output').innerHTML = question;
                readTextAloud(question); // 질문 음성으로 읽기
                isFirstQuestionDisplayed = true; // 첫 질문 출력 플래그 설정
            } else {
                document.getElementById('interviewer-text-output').innerText = '질문 데이터가 없습니다.';
            }
        } else {
            console.error('서버 오류:', response.statusText);
            document.getElementById('interviewer-text-output').innerText = '질문 생성 중 오류 발생 (서버 문제)';
        }
    } catch (error) {
        console.error('질문 생성 중 오류:', error);
        document.getElementById('interviewer-text-output').innerText = '질문 생성 중 오류 발생 (클라이언트 문제)';
    }
}

// 녹화 저장
async function saveRecording() {
    const blob = new Blob(recordedChunks, { type: 'video/webm' });
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

// 녹화 종료
function stopRecording() {
    if (mediaRecorder && mediaRecorder.state !== 'inactive') {
        mediaRecorder.stop();
        console.log('녹화 중지');
    }
    if (expressionInterval) {
        clearInterval(expressionInterval);
        console.log('감정 분석 중지');
    }
    if (webcamStream) {
        webcamStream.getTracks().forEach(track => track.stop());
        console.log('웹캠 스트림 중지');
    }
}

// 버튼 이벤트 리스너 설정
document.getElementById('stop-recording').addEventListener('click', stopRecording);