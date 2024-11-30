
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

        /* 모달창 스타일 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }

        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 300px;
            text-align: center;
            border-radius: 8px;
        }

        .modal-content p {
            margin: 20px 0;
            font-size: 16px;
        }

        .close-btn, .login-btn {
            background-color: #333;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .login-btn {
            background-color: #007bff;
            margin-top: 10px;
        }

        .close-btn:hover, .login-btn:hover {
            opacity: 0.8;
        }

    </style>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const modal = document.getElementById("login-modal");
            const closeModal = document.getElementById("close-modal");
            const goLogin = document.getElementById("go-login");

            closeModal.addEventListener("click", () => {
                modal.style.display = "none";
            });

            goLogin.addEventListener("click", () => {
                window.location.href = "login.jsp";
            });

            function checkSessionAndNavigate(url) {
                const xhr = new XMLHttpRequest();
                xhr.open("GET", "/checkSession", true);
                xhr.onload = function () {
                    if (xhr.status === 200) {
                        const response = JSON.parse(xhr.responseText);
                        if (response.isLoggedIn) {
                            // 세션이 있으면 URL로 이동
                            window.location.href = url;
                        } else {
                            // 세션이 없으면 모달창 표시
                            modal.style.display = "block";
                        }
                    } else {
                        console.error("세션 확인 중 오류 발생");
                    }
                };
                xhr.send();
            }

            // 페이지 내에서 사용하는 함수도 이벤트 리스너 안에 포함
            window.checkSessionAndNavigate = checkSessionAndNavigate;
        });

    </script>
</head>

<body>

<jsp:include page="header.jsp"/>
<!-- 모달창 -->
<div id="login-modal" class="modal">
    <div class="modal-content">
        <p>로그인이 필요한 서비스 입니다.</p>
        <button class="close-btn" id="close-modal">닫기</button>
        <button class="login-btn" id="go-login">로그인 하러가기</button>
    </div>
</div>

<!-- 메인 컨텐츠 -->
<div class="main-container">
    <div class="main-box">
        <div class="box dark-box">
            <h3>자소서 관리</h3>
            <ul>
                <li><a href="#" onclick="checkSessionAndNavigate('resume.jsp'); return false;">자기소개서 등록</a></li>
                <li><a href="#" onclick="checkSessionAndNavigate('resume_view'); return false;">자기소개서 조회</a></li>
                <li><a href="#" onclick="checkSessionAndNavigate('resume_analyze.jsp'); return false;">자기소개서 분석</a></li>
            </ul>
        </div>
        <div class="box dark-box">
            <h3>가상면접</h3>
            <ul>
                <li><a href="#" onclick="checkSessionAndNavigate('/resume?action=interview'); return false;">면접 보러가기</a></li>
                <li><a href="#" onclick="checkSessionAndNavigate('interview_view.jsp'); return false;">면접 녹화기록 조회</a></li>
            </ul>
        </div>
        <div class="box dark-box">
            <h3>채용공고</h3>
            <ul>
                <li><a href="jobPosting.jsp">채용공고 보러가기</a></li>
                <li><a href="#" onclick="checkSessionAndNavigate('scrap'); return false;">저장된 공고 목록</a></li>
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