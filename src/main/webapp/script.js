// 면접 시작, 녹화 및 웹캠 접근
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
