<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>면접 보기</title>
    <!-- TensorFlow.js 및 Face-api.js -->
    <script src="https://cdn.jsdelivr.net/npm/@tensorflow/tfjs@2.0.1/dist/tf.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/face-api.js@0.22.2/dist/face-api.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"></script>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        .sidebar {
            width: 200px;
            padding: 20px;
            background-color: white;
            border-right: 1px solid #ddd;
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
        }
        .sidebar ul li {
            margin-bottom: 15px;
        }
        .sidebar ul li a {
            text-decoration: none;
            color: #333;
            font-size: 16px;
            cursor: pointer;
        }
        .sidebar li:hover {
            background-color: #e0e0e0;
        }
        .content {
            flex-grow: 1;
            padding: 20px;
        }
        .video-section-container {
            display: flex;
            justify-content: space-between;
            gap: 20px;
        }
        .video-section {
            width: 48%;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        .video-section h2 {
            font-size: 18px;
            color: #333;
            margin-bottom: 10px;
            text-align: center;
        }
        video, img {
            width: 100%;
            max-height: 350px;
            border-radius: 10px;
            border: 1px solid #ddd;
            margin-bottom: 15px;
        }
        .text-output {
            width: 100%;
            height: 150px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-sizing: border-box;
            padding: 10px;
            overflow-y: auto;
            font-size: 14px;
            line-height: 1.5;
            background-color: #f9f9f9;
            color: #333;
        }
        .expression-output {
            font-size: 16px;
            font-weight: bold;
            color: #555;
            text-align: center;
            margin-top: 10px;
        }
        .button-controls {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 15px;
        }
        .button-controls button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .button-controls button:hover {
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
            <li><a href="interview_view.jsp">면접 기록 조회</a></li>
        </ul>
    </div>

    <div class="content">
        <div class="video-section-container">
            <!-- 면접관 화면 -->
            <div class="video-section">
                <h2>면접관 화면</h2>
                <img id="interviewer-video" src="ai-character.png" alt="가상 면접관 AI 캐릭터">
                <h2>면접관 텍스트 창</h2>
                <div class="text-output" id="interviewer-text-output">질문 내용이 여기에 표시됩니다.</div>
            </div>

            <!-- 면접자 화면 -->
            <div class="video-section">
                <h2>면접자 화면</h2>
                <video id="user-webcam" autoplay playsinline muted></video>
                <div class="expression-output" id="user-expression-output">표정 분석 결과가 여기에 표시됩니다.</div>
                <h2>면접자 텍스트 창</h2>
                <div class="text-output" id="user-text-output">면접자의 대답이 여기에 표시됩니다.</div>
            </div>
        </div>

        <div class="button-controls">
            <button id="start-interview">면접 시작</button>
            <button id="next-question">다음 질문</button>
            <button id="stop-recording">녹화 종료</button>
        </div>
    </div>
</div>

<script src="script.js"></script>
<script>
    document.getElementById('start-interview').addEventListener('click', () => {
        console.log("면접 시작");
    });

    document.getElementById('stop-recording').addEventListener('click', () => {
        console.log("녹화 종료");
    });
</script>

</body>
</html>
