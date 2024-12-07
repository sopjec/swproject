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

// 감정 데이터 저장 함수 (서버에 전송)
async function saveEmotionsToServer(interviewId, emotionsData) {
    try {
        for (const emotion of emotionsData) {
            await saveExpression(
                interviewId,
                emotion.type,
                emotion.value
            );
        }
    } catch (error) {
        console.error('감정 데이터 저장 중 오류:', error);
    }
}
// 실시간 감정 분석 및 저장
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

                // 감정 데이터 수집
                const emotionData = {
                    type: dominantExpression,
                    value: expressions[dominantExpression],
                    interviewId: interviewId
                };

                expressionOutput.innerHTML = `현재 표정: ${dominantExpression} (${(expressions[dominantExpression] * 100).toFixed(2)}%)`;
                console.log('감정 분석 결과:', expressions);

                // 감정 데이터를 서버에 실시간으로 전송
                saveEmotionsToServer(interviewId, [emotionData]);

            } else {
                expressionOutput.innerHTML = '얼굴이 감지되지 않았습니다.';
                console.warn('얼굴이 감지되지 않았습니다.');
            }
        } catch (error) {
            console.error('감정 분석 중 오류:', error);
        }
    }, 1000); // 1초 간격으로 분석 및 서버에 전송
}



// 감정 데이터 저장 함수
async function saveExpression(interviewId, type, value) {
    try {
        const response = await fetch('/api/save-expression', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json; charset=UTF-8' },
            body: JSON.stringify({ interviewId, type, value })
        });

        if (response.ok) {
            console.log('감정 데이터 저장 성공');
        } else {
            console.error('감정 데이터 저장 실패:', response.statusText);
        }
    } catch (error) {
        console.error('감정 데이터 저장 중 오류:', error);
    }
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
    isRecording = true;

    let previousTranscript = ''; // 이전 텍스트 추적

    recognition.onresult = (event) => {
        let transcript = '';
        for (let i = event.resultIndex; i < event.results.length; ++i) {
            transcript += event.results[i][0].transcript;
        }

        // 새로 인식된 부분만 추가
        if (transcript.trim() !== previousTranscript.trim()) {
            userTextOutput.innerHTML = transcript.trim(); // 텍스트 갱신
            previousTranscript = transcript; // 현재 텍스트를 이전 텍스트로 저장
        }

        console.log('음성 인식 결과:', transcript);
    };

    recognition.onerror = (event) => {
        console.error('음성 인식 오류:', event.error);
    };

    recognition.onend = () => {
        console.log('음성 인식 종료.');
        isRecording = false;
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
async function saveRecording() {
    const blob = new Blob(recordedChunks, { type: 'video/webm' });
    const fileName = `recording_${interviewId || 'unknown'}.webm`; // 인터뷰 ID를 파일명에 포함
    const formData = new FormData();
    formData.append('videoFile', blob, fileName); // 파일명 동기화
    formData.append('resumeId', resumeId); // resumeId를 함께 전송
    formData.append('interviewId', interviewId); // interviewId도 전송

    try {
        const response = await fetch('/upload-video', {
            method: 'POST',
            body: formData,
        });

        if (response.ok) {
            console.log(`녹화본이 서버에 성공적으로 업로드되었습니다.: ${fileName}`);
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


// 질답 저장 함수
async function saveQuestionAndAnswer(question, answer) {
    try {
        const response = await fetch('/interview', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                interviewId: interviewId,
                question: question,
                answer: answer || "", // 답변이 없으면 빈 문자열
            }),
        });

        if (response.ok) {
            console.log(`질문과 답변 저장 성공: ${question}, ${answer}`);
        } else {
            console.error('질문과 답변 저장 실패:', response.statusText);
        }
    } catch (error) {
        console.error('질문과 답변 저장 중 오류:', error);
    }
}
// 질문 및 피드백 생성 및 업데이트 함수
async function generateAndSaveFeedback() {
    // 모달 열기 및 초기 메시지 설정
    openModal('감정 분석 결과를 불러오고 있습니다...');

    try {
        // 1. 데이터베이스에서 감정 분석 데이터 가져오기
        const emotionFetchResponse = await fetch(`/api/get-emotions?interviewId=${interviewId}`);
        if (!emotionFetchResponse.ok) {
            throw new Error(`감정 데이터를 가져오는 데 실패했습니다: ${emotionFetchResponse.statusText}`);
        }

        const emotionsData = await emotionFetchResponse.json();
        console.log('데이터베이스에서 가져온 감정 데이터:', emotionsData);

        // 2. 감정 데이터를 이용해 파이 차트 생성
        drawPieChart(emotionsData);

        // 3. 감정 피드백을 모달에 표시
        let emotionFeedback = '\n';
        //emotionsData.forEach((emotion, index) => {
        //    emotionFeedback += `#${index + 1} ${emotion.type}: ${(emotion.value * 100).toFixed(2)}%\n`;
       // });
        //openModal(`${emotionFeedback}\n피드백을 생성 중입니다. 잠시만 기다려주세요...`);
        openModal(`피드백을 생성 중입니다. 잠시만 기다려주세요...`);

        // 3. 데이터베이스에서 질문과 답변 가져오기
        const fetchResponse = await fetch(`/api/get-questions-and-answers?interviewId=${interviewId}`);
        if (!fetchResponse.ok) {
            throw new Error(`질문과 답변 데이터를 가져오는 데 실패했습니다: ${fetchResponse.statusText}`);
        }

        const questionsAndAnswers = await fetchResponse.json();
        console.log('데이터베이스에서 가져온 질문과 답변 데이터:', questionsAndAnswers);

        // 4. 질문과 답변이 모두 비어 있는지 확인
        const hasValidAnswers = questionsAndAnswers.some(qa => qa.answer.trim() !== "");
        if (!hasValidAnswers) {
            openModal(`${emotionFeedback}\n\n모든 질문에 대한 답변이 비어 있습니다. 피드백을 생성할 수 없습니다.`);
            return; // 피드백 생성 중단
        }

        // 5. GPT API를 통해 피드백 요청
        const response = await fetch('/api/generate-feedback', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                interviewId: interviewId, // 현재 인터뷰 ID
                data: questionsAndAnswers // 질문과 답변 배열
            }),
        });

        if (response.ok) {
            const data = await response.json();
            console.log("피드백 생성 완료:", data.feedback);

            // 6. 모달에 생성된 피드백 표시
            openModal(`${emotionFeedback}\n\n질문 피드백:\n${data.feedback}`);
        } else {
            throw new Error(`피드백 생성 실패: ${response.statusText}`);
        }
    } catch (error) {
        console.error('피드백 생성 중 오류:', error);
        openModal('피드백 생성 중 오류가 발생했습니다. 다시 시도해주세요.');
    }
}

// 감정 데이터를 바탕으로 파이 차트를 그리는 함수 (감정 빈도 합이 100%가 되도록 조정)
function drawPieChart(emotionsData) {
    const svg = document.querySelector('#emotion-pie-chart svg');
    svg.innerHTML = ''; // 이전 차트 내용 초기화

    // 1. 감정 빈도 계산
    const frequencyMap = emotionsData.reduce((acc, emotion) => {
        acc[emotion.type] = (acc[emotion.type] || 0) + 1;
        return acc;
    }, {});

    // 2. 감정 빈도를 비율로 변환 (각 감정의 빈도를 전체 빈도로 나누어 100%로 맞춤)
    const total = Object.values(frequencyMap).reduce((sum, count) => sum + count, 0);
    let currentAngle = 0;

    Object.entries(frequencyMap).forEach(([type, count], index) => {
        const sliceAngle = (count / total) * 2 * Math.PI;

        // 각 슬라이스의 경로 그리기
        const x1 = 200 + 150 * Math.cos(currentAngle);
        const y1 = 200 + 150 * Math.sin(currentAngle);
        const x2 = 200 + 150 * Math.cos(currentAngle + sliceAngle);
        const y2 = 200 + 150 * Math.sin(currentAngle + sliceAngle);

        const largeArcFlag = sliceAngle > Math.PI ? 1 : 0;
        const pathData = `M200,200 L${x1},${y1} A150,150 0 ${largeArcFlag} 1 ${x2},${y2} Z`;

        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute('d', pathData);
        path.setAttribute('fill', `hsl(${index * 360 / Object.keys(frequencyMap).length}, 70%, 50%)`);

        svg.appendChild(path);

        // 텍스트 라벨 추가
        const labelAngle = currentAngle + sliceAngle / 2;
        const labelX = 200 + 180 * Math.cos(labelAngle);
        const labelY = 200 + 180 * Math.sin(labelAngle);

        const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        text.setAttribute('x', labelX);
        text.setAttribute('y', labelY);
        text.setAttribute('text-anchor', 'middle');
        text.setAttribute('font-size', '14');
        text.textContent = `${type}: ${((count / total) * 100).toFixed(2)}%`;

        svg.appendChild(text);

        currentAngle += sliceAngle;
    });
}

// 랜덤 색상 생성 함수
function getRandomColor() {
    const letters = '0123456789ABCDEF';
    let color = '#';
    for (let i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
}


// 이벤트 리스너 설정
document.getElementById('start-interview').addEventListener('click', startInterview);
// 음성 인식 종료
function stopSpeechRecognition() {
    if (recognition && isRecording) {
        recognition.stop();
        isRecording = false;
        console.log('음성 녹음 종료');
    }
}

document.getElementById('next-question').addEventListener('click', async () => {
    const userTextOutput = document.getElementById('user-text-output');
    const currentAnswer = userTextOutput.innerText.trim(); // 사용자가 입력한 답변 가져오기

    // 질문 데이터가 존재할때만 처리함
    if (currentQuestionIndex < questions.length) {
        const currentQuestion = questions[currentQuestionIndex];
        // 음성 녹음 종료
        stopSpeechRecognition();

        // 질문과 답변을 저장
        await saveQuestionAndAnswer(currentQuestion, currentAnswer);

        // 다음 질문으로 이동
        currentQuestionIndex++;
        if (currentQuestionIndex < questions.length) {
            const nextQuestion = `질문 ${currentQuestionIndex + 1}: ${questions[currentQuestionIndex]}`;
            document.getElementById('interviewer-text-output').innerText = nextQuestion;

            // 면접자 텍스트창 내용 초기화
            userTextOutput.innerText = '';

            // 새 질문 읽어주고 음성 녹음 시작
            readTextAloud(nextQuestion, startSpeechRecognition);
        } else {
            document.getElementById('interviewer-text-output').innerText = '모든 질문이 완료되었습니다.';
            alert('면접이 종료되었습니다.');
            await generateAndSaveFeedback();
        }
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


