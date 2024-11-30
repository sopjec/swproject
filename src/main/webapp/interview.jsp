<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.zerock.jdbcex.dto.ResumeDTO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
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
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        /* 메인 레이아웃 설정 */
        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        /* 메인 컨텐츠 */
        .content {
            flex-grow: 1;
            padding-left: 20px;
        }
        /* 왼쪽 사이드바 스타일 */
        .sidebar {
            width: 200px;
            padding: 20px;
            background-color: white;
            border-right: 1px solid #ddd;
        }
        .sidebar ul {
            list-style-type: none;
            padding: 0;
        }
        .sidebar ul li {
            margin-bottom: 10px;
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
        /*오른쪽 컨텐츠 스타일*/
        h2 {
            color: #333;
            margin-bottom: 10px;
        }
        .video-section {
            width: 48%;
            text-align: center;
            justify-content: space-between;
            height: 100%;
        }
        .video-section-container {
            display: flex;
            justify-content: space-between;
            gap: 20px;
        }
        video, img {
            width: 100%;
            max-height: 500px;
            border: 2px solid #333;
            border-radius: 8px;
            box-sizing: border-box;
        }
        .text-output {
            width: 100%;
            height: 200px;
            border: 2px solid #333;
            border-radius: 8px;
            box-sizing: border-box;
            padding: 10px;
            overflow-y: auto;
            text-align: left;
            font-size: 15px;
            color: #333;
        }
        .expression-output {
            margin-top: 10px;
            font-size: 18px;
            font-weight: bold;
            color: #333;
            text-align: center;
        }
        .button-controls {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-top: 20px;
        }
        .button-controls button {
            padding: 10px 15px;
            background-color: #333;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
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

    <!-- 메인 컨텐츠 -->
    <div class="content">
        <div class="video-section-container">
            <div class="video-section">
                <h2>면접관 화면</h2>
                <img id="interviewer-video" src="ai-character.png" alt="가상 면접관 AI 캐릭터">
                <h2>면접관 텍스트 창</h2>
                <div class="text-output" id="interviewer-text-output"></div>
            </div>
            <div class="video-section">
                <h2>면접자 화면</h2>
                <video id="user-webcam" autoplay playsinline muted></video>
                <!-- 웹캠 아래에 감정 분석 결과를 표시 -->
                <div class="expression-output" id="user-expression-output">표정 분석 결과가 여기에 표시됩니다.</div>
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
    // URL에서 resumeId 가져오기
    const urlParams = new URLSearchParams(window.location.search);
    const resumeId = urlParams.get('resumeId'); // URL에서 resumeId 값 추출

    // 면접 시작 버튼 클릭 시 면접 질문 생성
    document.getElementById('start-interview').addEventListener('click', async () => {
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
                body: new URLSearchParams({ resumeId }) // 동적으로 resumeId 가져옴
            });

            if (response.ok) {
                const data = await response.json();
                const question = data.question || '질문 생성 실패';
                document.getElementById('interviewer-text-output').innerText = question;
            } else {
                document.getElementById('interviewer-text-output').innerText = '질문 생성 중 오류 발생';
            }
        } catch (error) {
            console.error('질문 생성 중 오류:', error);
            document.getElementById('interviewer-text-output').innerText = '질문 생성 중 오류 발생';
        }
    });

    // 녹화 종료 버튼 이벤트 핸들러 (기존 유지)
    document.getElementById('stop-recording').addEventListener('click', () => {
        alert('녹화 종료!');

    });
</script>

</body>
</html>