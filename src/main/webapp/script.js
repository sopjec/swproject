let mediaRecorder;
let recordedChunks = [];
let webcamStream;
let expressionInterval;
let questions = []; // 서버에서 받아온 질문 배열
let currentQuestionIndex = 0; // 현재 질문 인덱스

// Face-api.js 모델 로드
async function loadModels() {
    try {
        console.log('Face-api.js 모델 로드 시작');
        await faceapi.nets.tinyFaceDetector.loadFromUri('/models');
        console.log('tinyFaceDetector 모델 로드 성공');
        await faceapi.nets.faceExpressionNet.loadFromUri('/models');
        console.log('faceExpressionNet 모델 로드 성공');
    } catch (error) {x``
        console.error('Face-api.js 모델 로드 중 오류:', error);
    }
}

// 실시간 감정 분석
async function analyzeExpressions() {
    const video = document.getElementById('user-webcam');
    const expressionOutput = document.getElementById('user-expression-output'); // 웹캠 아래 텍스트 출력

    expressionInterval = setInterval(async () => {
        try {
            // 얼굴 및 감정 감지
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

// 면접 시작 버튼 클릭 시 질문 데이터를 가져오는 함수
document.getElementById('start-interview').addEventListener('click', async () => {
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
            questions = questions.map(q => q.replace(/^\d+\.\s*/, ''));  //질문 생성에서 접두어 제거

            if (questions.length > 0) {
                // 첫 번째 질문 출력
                document.getElementById('interviewer-text-output').innerHTML =
                    `질문 ${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]}`;
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
        // 다음 질문 출력
        document.getElementById('interviewer-text-output').innerHTML =
            `질문 ${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]}`;
    } else {
        // 질문이 더 이상 없을 경우 메시지 출력
        document.getElementById('interviewer-text-output').innerText = '모든 질문을 완료했습니다.';
        currentQuestionIndex--; // 인덱스 유지

        // 녹화 종료 및 안내창 표시
        stopRecording(); // 녹화 종료 함수 호출
        alert('면접이 끝났습니다.'); // 안내창 표시
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
        console.error('웹캠 연결 또는 Face-api.js 로드 중 오류:', error);
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
        alert('페이지와 웹캠 녹화가 시작되었습니다.');
    } catch (error) {
        console.error('페이지 녹화 중 오류:', error);
        alert('페이지 녹화 중 문제가 발생했습니다.');
    }
}

// 녹화 저장
function saveRecording() {
    const blob = new Blob(recordedChunks, { type: 'video/webm' });
    const url = URL.createObjectURL(blob);
    const downloadLink = document.createElement('a');
    downloadLink.href = url;
    downloadLink.download = 'recording.webm'; // 저장할 파일명
    document.body.appendChild(downloadLink);
    downloadLink.click();
    console.log('녹화본 저장 완료');
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
