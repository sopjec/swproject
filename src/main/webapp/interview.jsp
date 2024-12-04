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
    <style>
        .container {
            display: flex;
            position: relative;
            max-width: 1200px;
            margin: 0 auto;
            padding-right: 10px;
        }

        .content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: 20px;
            flex: 1;
        }

        .row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            width: 100%;
        }

        .video-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

       .video-section img {
            width: 100%;
            max-height: 300px;
            box-sizing: border-box;
        }
        .video-section video {
              width: 100%;
              max-height: 300px;
              border: 1px solid #333;
              box-sizing: border-box;
        }

        .text-output {
            width: 100%;
            height: 300px; /* 면접자 화면 높이와 맞춤 */
            border: 1px solid #333;
            box-sizing: border-box;
            padding: 10px;
            overflow-y: auto;
            text-align: left;
            font-size: 15px;
            line-height: 1.5;
            font-family: 'Arial', sans-serif;
            color: #333;
            background-color: #f9f9f9;
        }

        .expression-output {
            margin-top: 10px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
            text-align: center;
        }

        .button-container {
            position: absolute;
            display: flex;
            flex-direction: column;
            gap: 10px;
            left: 100%; /* 컨테이너 오른쪽에 딱 붙이기 */
            top: 25%;
            transform: translate(-10px, -50%); /* 살짝 간격을 두기 위해 조정 */
        }

        .button-container button {
            padding: 10px 15px;
            background-color: #333;
            border: none;
            color: white;
            border-radius: 0 10px 10px 0; /* 왼쪽 직선, 오른쪽 둥근 모서리 */
            cursor: pointer;
            font-size: 16px;
            text-align: center;
            box-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2); /* 살짝 그림자 추가 */
        }

        .button-container button:hover {
            background-color: #555;
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

    <!-- 메인 컨텐츠 -->
    <div class="content">
        <!-- 첫 번째 행: 면접관 화면과 면접관 텍스트 창 -->
        <div class="row">
            <div class="video-section">
                <h2>면접관 화면</h2>
                <img id="interviewer-video" src="ai-character.png" alt="가상 면접관 AI 캐릭터">
            </div>
            <div class="video-section">
                <h2>면접관 텍스트 창</h2>
                <div class="text-output" id="interviewer-text-output"></div>
            </div>
        </div>

        <!-- 두 번째 행: 면접자 화면과 면접자 텍스트 창 -->
        <div class="row">
            <div class="video-section">
                <h2>
                    면접자:
                    <%= session.getAttribute("loggedInUser") != null
                            ? ((UserDTO) session.getAttribute("loggedInUser")).getName()
                            : "Unknown" %>
                </h2>
                <video id="user-webcam" autoplay playsinline muted></video>
                <!-- 표정 분석 결과 추가 -->
                <div class="expression-output" id="user-expression-output">표정 분석 결과가 여기에 표시됩니다.</div>
            </div>
            <div class="video-section">
                <h2>면접자 텍스트 창</h2>
                <div class="text-output" id="user-text-output"></div>
            </div>
        </div>
    </div>

    <!-- 버튼 컨테이너 -->
    <div class="button-container">
        <button id="start-interview">면접 시작</button>
        <button id="next-question">다음 질문</button>
        <button id="stop-recording">녹화 종료</button>
    </div>
</div>

<script src="script.js"></script>

</body>
</html>
