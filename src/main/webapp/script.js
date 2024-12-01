let mediaRecorder;
let recordedChunks = [];
let webcamStream;
let expressionInterval;
let questions = []; // 서버에서 받아온 질문 배열
let currentQuestionIndex = 0; // 현재 질문 인덱스

// Web Speech API 음성 인식 객체 생성
let recognition = null;

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

                // 감정 분석 결과를 웹캠 아래에 출력
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

// 텍스트 음성 읽기 함수
function readTextAloud(text) {
    if (!window.speechSynthesis) {
        console.error('이 브라우저는 Web Speech API를 지원하지 않습니다.');
        return;
    }

    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = 'ko-KR';
    utterance.rate = 1;
    utterance.pitch = 1;
    speechSynthesis.speak(utterance);
}

// 질문 표시 함수
function displayQuestion() {
    if (currentQuestionIndex < questions.length) {
        const question = questions[currentQuestionIndex];
        const formattedQuestion = `질문 ${currentQuestionIndex + 1}: ${question}`;
        document.getElementById('interviewer-text-output').innerHTML = formattedQuestion;
        readTextAloud(question); // 질문 읽기 추가
    } else {
        document.getElementById('interviewer-text-output').innerText = '모든 질문을 완료했습니다.';
        listenToUserAnswer(); // 마지막 질문 이후 음성 입력 받기 시작
    }
}

// 음성을 텍스트로 변환하는 함수
function listenToUserAnswer() {
    if (!window.webkitSpeechRecognition && !window.SpeechRecognition) {
        alert('이 브라우저는 음성 인식을 지원하지 않습니다.');
        return;
    }

    const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
    recognition = new SpeechRecognition();
    recognition.lang = 'ko-KR';

    // 음성 인식 시작
    recognition.start();
    console.log('음성 인식 시작');

    recognition.onresult = function (event) {
        const userAnswer = event.results[0][0].transcript;
        console.log('음성 인식 결과:', userAnswer);

        // 면접자 텍스트 창에 표시
        document.getElementById('user-text-output').innerHTML = userAnswer;

        // 다음 질문으로 넘어가거나 녹화 종료
        if (currentQuestionIndex < questions.length - 1) {
            currentQuestionIndex++;
            displayQuestion();
        } else {
            stopRecording();
            alert('면접이 완료되었습니다.');
        }
    };

    recognition.onerror = function (event) {
        console.error('음성 인식 오류:', event.error);
        alert('음성 인식 중 오류가 발생했습니다.');
    };

    recognition.onend = function () {
        console.log('음성 인식 종료');
    };
}

// 면접 시작 버튼 클릭 시 질문 데이터를 가져오는 함수
async function startInterviewProcess() {
    const urlParams = new URLSearchParams(window.location.search);
    const resumeId = urlParams.get('resumeId'); // URL에서 resumeId 값 추출

    if (!resumeId) {
        alert('resumeId가 없습니다. URL을 확인하세요.');
        return;
    }

    try {
        // API 요청을 통해 질문 가져오기
        const response = await fetch('/api/generate-question', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({ resumeId }), // 동적으로 resumeId 가져옴
        });

        if (response.ok) {
            const data = await response.json(); // JSON 데이터 파싱
            console.log('API 응답 데이터:', data);

            // 질문 데이터를 줄바꿈 기준으로 분리하여 배열로 저장
            questions = data.question.split('\n').filter(q => q.trim() !== '');
            currentQuestionIndex = 0; // 초기화
            questions = questions.map(q => q.replace(/^\d+\.\s*/, '')); // 질문 접두어 제거

            if (questions.length > 0) {
                // 첫 번째 질문 출력
                displayQuestion();
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

    startInterview();
    setTimeout(() => {
        startPageRecording();
        console.log('3초 후 녹화 시작');
    }, 3000); // 3초 대기 후 녹화 시작
}

// 녹화 저장
function saveRecording() {
    const blob = new Blob(recordedChunks, { type: 'video/webm' });
    const url = URL.createObjectURL(blob);

    const downloadLink = document.createElement('a');
    downloadLink.href = url;

    // 파일명에 자소서 제목 포함 (현재 `resumeId` 사용)
    const resumeId = new URLSearchParams(window.location.search).get('resumeId');
    downloadLink.download = `interview_record_resume_${resumeId}.webm`;

    document.body.appendChild(downloadLink);
    downloadLink.click();
    console.log('녹화본 저장 완료');
}

// 기타 녹화, 감정 분석, 버튼 이벤트 리스너는 기존 코드 유지
document.getElementById('start-interview').addEventListener('click', startInterviewProcess);
document.getElementById('stop-recording').addEventListener('click', stopRecording);
