
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메인 페이지</title>
    <style>
        /* 스타일 설정 (기존 코드와 동일) */

        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
        }
        /* 메인 컨텐츠 스타일 */

        .main-container {
            display: flex;
            justify-content: center;
            align-items: center;
            height: calc(100vh - 80px);
            /* 헤더의 높이를 제외한 화면 중앙 배치 */
            padding: 0 20px;
        }

        .main-box {
            display: flex;
            gap: 20px;
            max-width: 1200px;
            width: 100%;
        }

        .box {
            flex: 1;
            padding: 30px;
            text-align: center;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: white;
            /* 기본 배경색 */
            font-size: 18px;
            /* 글자 크기 조정 */
            transition: background-color 0.3s ease;
            /* 배경색 변환 시 부드럽게 */
        }

        .box:hover {
            background-color: #e0e0e0;
            /* 마우스 호버 시 배경색 변경 */
        }

        .box h3 {
            margin-bottom: 10px;
            font-size: 22px;
            /* 타이틀 글자 크기 조정 */
        }

        .box ul {
            list-style-type: none;
            padding: 0;
            margin-bottom: 20px;
        }

        .box ul li {
            margin-bottom: 5px;
            font-size: 18px;
        }

        .box a {
            text-decoration: none;
            color: inherit;
            /* 링크가 일반 텍스트처럼 보이도록 설정 */
        }

        .box a:hover {
            text-decoration: underline;
            /* 마우스 호버 시 밑줄 */
        }

        .dark-box {
            background-color: white;
            /* 기본 배경색을 흰색으로 설정 */
            color: #333;
            /* 기본 글자색 */
        }

        .dark-box:hover {
            background-color: #333;
            /* 마우스 호버 시 어두운 색으로 변경 */
            color: white;
            /* 글자색을 흰색으로 변경 */
        }

        .dark-box a {
            color: inherit;
            /* 링크 색상도 기본 텍스트 색상과 동일 */
        }

        .dark-box a:hover {
            text-decoration: underline;
            /* 마우스 호버 시 밑줄 */
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

<!-- 메인 컨텐츠 -->
<div class="main-container">
    <div class="main-box">
        <div class="box dark-box">
            <h3>자소서 관리</h3>
            <ul>
                <li><a href="resume.jsp">자기소개서 등록</a></li>
                <li><a href="resume">자기소개서 조회</a></li>
                <li><a href="resume">자기소개서 분석</a></li>
            </ul>
        </div>
        <div class="box dark-box">
            <h3>가상면접</h3>
            <ul>
                <li><a href="interview.jsp">면접 보러가기</a></li>
                <li><a href="interview.jsp">면접 녹화기록 조회</a></li>
            </ul>
        </div>
        <div class="box dark-box">
            <h3>채용공고</h3>
            <ul>
                <li><a href="jobPosting.jsp">채용공고 보러가기</a></li>
                <li><a href="jobScrap.jsp">저장된 공고 목록</a></li>
            </ul>
        </div>
        <div class="box dark-box">
            <h3>커뮤니티</h3>
            <ul>
                <li><a href="review.jsp">기업 면접 후기</a></li>
            </ul>
        </div>
    </div>
</div>

</body>

</html>