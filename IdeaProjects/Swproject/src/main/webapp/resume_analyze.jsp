<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자기소개서 분석</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }
        .auth-links {
            display: flex;
            gap: 10px;
        }
        .auth-links a {
            text-decoration: none;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            color: #333;
        }
        .auth-links a:hover {
            background-color: #f0f0f0;
        }
        .container {
            display: flex;
            width: 100%;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
            box-sizing: border-box;
        }
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
        .sidebar ul li a {
            text-decoration: none;
            color: #333;
            font-size: 16px;
            display: block;
            padding: 10px 0;
        }
        .sidebar ul li a:hover {
            background-color: #c6c6c6;
        }
        .content {
            flex-grow: 1;
            padding-left: 20px;
            max-width: 100%;
            width: 100%;
            box-sizing: border-box;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }
        .box-container {
            display: flex;
            gap: 20px;
        }
        .input-section, .analysis-section {
            flex: 1;
            padding: 20px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .input-section h3, .analysis-section h3 {
            margin-top: 0;
            font-size: 18px;
        }
        .input-section textarea, .analysis-section textarea {
            width: 100%;
            height: 300px;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 4px;
            resize: none;
            box-sizing: border-box;
        }
        .input-section .character-count {
            font-size: 12px;
            color: #777;
            text-align: right;
            margin-top: 5px;
        }
        .analyze-button {
            padding: 8px 15px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
            align-self: center;
        }
        .analyze-button:hover {
            background-color: black;
        }
    </style>
    <script>
        // header.html 파일을 불러오는 함수
        function loadHeader() {
            fetch("header.jsp")
                .then(response => response.text())
                .then(data => {
                    document.getElementById("header-container").innerHTML = data;
                })
                .catch(error => console.error("Error loading header:", error));
        }

        window.onload = loadHeader; // 페이지가 로드될 때 헤더를 불러옴
    </script>
</head>

<body>
<!-- 헤더가 로드될 위치 -->
<div id="header-container"></div>

<div class="container">
        <div class="sidebar">
            <ul>
                <li><a href="resume.jsp">자기소개서 등록</a></li>
                <li><a href="resume_view.jsp">자기소개서 조회</a></li>
                <li><a href="resume_analyze.jsp">자기소개서 분석</a></li>
            </ul>
        </div>

        <div class="content">
            <div class="box-container">
                <!-- 변경 전 입력 섹션 -->
                <div class="input-section">
                    <h3>분석 전</h3>
                    <textarea id="coverLetterInput" placeholder="자기소개서를 입력하세요."></textarea>
                    <div class="character-count" id="charCount">0/2000</div>
                </div>

                <!-- 변경 후 분석 결과 섹션 -->
                <div class="analysis-section">
                    <h3>분석 후</h3>
                    <textarea id="analysisOutput" placeholder="분석 결과가 여기에 표시됩니다." readonly></textarea>
                </div>
            </div>

            <!-- 분석하기 버튼 -->
            <button class="analyze-button" onclick="analyzeCoverLetter()">분석하기</button>
        </div>
    </div>

    <script>
        const textarea = document.getElementById("coverLetterInput");
        const charCount = document.getElementById("charCount");

        // 글자 수 카운트 업데이트
        textarea.addEventListener("input", () => {
            charCount.textContent = `${textarea.value.length}/2000`;
        });

        function analyzeCoverLetter() {
            const inputText = textarea.value;
            const analysisOutput = document.getElementById("analysisOutput");

            // 분석 결과 예시 (단순 예제)
            if (inputText.length > 0) {
                analysisOutput.value = `분석 결과: 자기소개서에서 발견된 주요 키워드: 책임감, 성실성, 팀워크\n추천 수정 사항: 첫 문장을 더 간결하게 수정해보세요.`;
            } else {
                analysisOutput.value = "분석할 내용을 입력해 주세요.";
            }
        }
    </script>
</body>
</html>
