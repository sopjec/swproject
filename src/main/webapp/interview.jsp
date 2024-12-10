<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.zerock.jdbcex.dto.UserDTO" %>
<%@ page import="org.zerock.jdbcex.dto.ResumeDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/layout.css"> <!-- 올바른 경로 설정 -->
    <title>면접 보기</title>
    <!-- TensorFlow.js 및 Face-api.js -->
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@2.0.1/dist/tf.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        .container {
            display: flex;
            position: relative;
            max-width: 1200px;
            margin: 0 auto;
            padding-right: 10px;
        }


        #feedback-modal {
            display: none;
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 600px;
            padding: 20px;
            background-color: white;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            z-index: 1000;
            text-align: center;
        }

        #feedback-modal h3 {
            margin-bottom: 10px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
        }

        #feedback-modal p {
            margin-bottom: 20px;
            font-size: 14px;
            color: #555;
        }

        #modal-message {
            text-align: left;
            white-space: pre-wrap; /* 줄 바꿈 유지 */
        }


        #feedback-modal button {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        #feedback-modal button:hover {
            background-color: #0056b3;
        }

        .content {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding : 0;
            justify-content: center;
            flex: 1;
        }

        .video-section {
            flex: 1;
            display: flex;
            width: 100%;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .video-section img {
            width: 100%;
            height: 300px;
            box-sizing: border-box;
        }
        .video-section video {
            width: 100%;
            height: 300px;
            border: 1px solid #333;
            box-sizing: border-box;
        }

        .text-output {
            border: 1px #333333 solid; /* 테두리 색상 유지 */
            border-radius: 10px; /* 모서리를 둥글게 */
            margin-top: 10px;
            margin-bottom: 10px;
            width: 90%;
            height: 100px; /* 세로 길이를 줄임 */
            padding: 10px;
            overflow-y: auto;
            text-align: left;
            font-size: 15pt; /* 폰트 크기를 15pt로 설정 */
            line-height: 1.5;
            font-family: 'Arial', sans-serif;
            color: #333;
            background-color: #f7f7f7; /* 약간 어두운 흰색 */
        }



        .expression-output {
            margin-top: 10px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
            text-align: center;
        }

        .button-container {
            display: flex;
            margin: 10px 0 0 0; /* 위쪽 마진을 30px에서 10px으로 줄임 */
            gap: 10px;
        }

        .button-container button {
            padding: 10px 15px;
            background-color: #333;
            border: none;
            color: white;
            border-radius: 10px; /* 모서리를 둥글게 */
            cursor: pointer;
            font-size: 16px;
            text-align: center;
        }

        .button-container button:hover {
            background-color: #555;
        }

        .row {
            display: flex;
            width: 100%;
        }
    </style>
</head>

<body>


<jsp:include page="header.jsp"/>

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="/resume?action=interview">면접 보기</a></li>
            <li><a href="interviewView">면접 기록 조회</a></li>
        </ul>
    </div>

    <!-- 모달 창 -->
    <div class="modal" id="feedback-modal">
        <h3>피드백</h3>
        <div id="emotion-pie-chart" style="width: 400px; height: 400px; margin: 0 auto;">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 400">
                <g transform="translate(200, 200)">
                    <g class="slice">
                        <path d="M0,0V-150A150,150,0,1,1,-147.27,-54.98Z" fill="#99c2ff"></path>
                        <text transform="translate(0, -110)" text-anchor="middle" font-size="14">neutral: 99.96%</text>
                    </g>
                    <g class="slice">
                        <path d="M-147.27,-54.98A150,150,0,0,1,0,-150L0,0Z" fill="#7fb6ff"></path>
                        <text transform="translate(-110, -40)" text-anchor="middle" font-size="14">neutral: 94.79%</text>
                    </g>
                    <g class="slice">
                        <path d="M0,-150A150,150,0,0,1,-147.27,54.98L0,0Z" fill="#66abff"></path>
                        <text transform="translate(0, 120)" text-anchor="middle" font-size="14">neutral: 95.84%</text>
                    </g>
                    <g class="slice">
                        <path d="M-147.27,54.98A150,150,0,0,1,147.27,54.98L0,0Z" fill="#4da0ff"></path>
                        <text transform="translate(110, 40)" text-anchor="middle" font-size="14">neutral: 98.40%</text>
                    </g>
                    <g class="slice">
                        <path d="M147.27,54.98A150,150,0,0,1,147.27,-54.98L0,0Z" fill="#3495ff"></path>
                        <text transform="translate(110, -40)" text-anchor="middle" font-size="14">neutral: 99.42%</text>
                    </g>
                    <g class="slice">
                        <path d="M147.27,-54.98A150,150,0,0,1,0,150L0,0Z" fill="#1b8aff"></path>
                        <text transform="translate(0, -120)" text-anchor="middle" font-size="14">neutral: 99.89%</text>
                    </g>
                    <g class="slice">
                        <path d="M0,150A150,150,0,0,1,-147.27,54.98L0,0Z" fill="#0279ff"></path>
                        <text transform="translate(-110, 40)" text-anchor="middle" font-size="14">happy: 99.92%</text>
                    </g>
                    <g class="slice">
                        <path d="M-147.27,54.98A150,150,0,0,1,-147.27,-54.98L0,0Z" fill="#0070f3"></path>
                        <text transform="translate(-110, -40)" text-anchor="middle" font-size="14">sad: 99.97%</text>
                    </g>
                </g>
            </svg>
        </div>

        <p id="modal-message">피드백을 생성 중입니다. 잠시만 기다려주세요...</p>



        <button id="close-modal" onclick="closeModalAndRedirect()">닫기</button>
    </div>


    <!-- 메인 컨텐츠 -->
    <div class="content">
        <h3 id="current-status">면접 시작버튼을 눌러주세요</h3>
        <div class="row">
            <div class="video-section">
                <img id="interviewer-video" src="img/ai-character.png" alt="가상 면접관 AI 캐릭터">
            </div>

            <div class="video-section">
                <video id="user-webcam" autoplay playsinline muted></video>
                <!-- 표정 분석 결과 추가 -->
                <div class="expression-output" id="user-expression-output">표정 분석 결과가 여기에 표시됩니다.</div>
            </div>
        </div>
        <div class="video-section">
            <span class="text-output" id="interviewer-text-output">질문이 이곳에 표시됩니다.</span>
        </div>
        <div class="video-section">
            <div class="text-output" id="user-text-output">질문이 끝난 후 답변해주세요.</div>
        </div>

        <!-- 버튼 컨테이너 -->
        <div class="button-container">
            <button id="start-interview">면접 시작</button>
            <button id="next-question">다음 질문</button>
        </div>
    </div>


</div>

<script src="script.js"></script>
<script>
    // 모달 열기 함수
    function openModal(message) {
        const modal = document.getElementById('feedback-modal');
        const modalMessage = document.getElementById('modal-message');
        modal.style.display = 'block';
        modalMessage.innerText = message;
    }


    function closeModalAndRedirect() {
        if (mediaRecorder && mediaRecorder.state === 'recording') {
            mediaRecorder.stop();
            console.log('녹화 중지');
        }
        if (webcamStream) {
            webcamStream.getTracks().forEach(track => track.stop());
            console.log('웹캠 스트림 중지');
        }
    }
</script>


</body>
</html>