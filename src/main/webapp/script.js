let webcamStream;
let expressionInterval;

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

// 감정 분석 실행
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

// 면접 시작
async function startInterview() {
    try {
        console.log('웹캠 연결 시도 중...');
        webcamStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
        const userWebcam = document.getElementById('user-webcam');
        if (userWebcam) userWebcam.srcObject = webcamStream;
        console.log('웹캠 스트림이 성공적으로 연결되었습니다.');

        await loadModels(); // 모델 로드
        analyzeExpressions(); // 감정 분석 시작
    } catch (error) {
        console.error('웹캠 연결 또는 Face-api.js 로드 중 오류:', error);
    }
}

// 녹화 종료
function stopRecording() {
    if (expressionInterval) {
        clearInterval(expressionInterval);
        console.log('감정 분석 중지');
    }
    if (webcamStream) {
        webcamStream.getTracks().forEach(track => track.stop());
        console.log('웹캠 스트림 중지');
    }
}

// 이벤트 리스너 설정
document.getElementById('start-interview').addEventListener('click', startInterview);
document.getElementById('stop-recording').addEventListener('click', stopRecording);

