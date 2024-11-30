let mediaRecorder;
let recordedChunks = [];
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
document.getElementById('start-interview').addEventListener('click', () => {
    startInterview();
    startPageRecording();
});
document.getElementById('stop-recording').addEventListener('click', stopRecording);
