<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이 페이지</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .section {
            display: none;
            text-align: center;
            padding: 30px;
            width: 100%;
        }
        .section input {
            display: block;
            margin: 10px auto;
            width: 80%;
        }
        /* 상단바 스타일 */
        .header {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding: 10px 20px;
            background-color: white;
            border-bottom: 1px solid #ddd;
        }
        .header .logo {
            font-size: 24px;
            font-weight: bold;
            margin-right: auto;
        }
        .header nav a {
            margin-left: 20px;
            color: #333;
            text-decoration: none;
            font-size: 16px;
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
        /* 메인 레이아웃 설정 */
        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
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
            background-color: #c6c6c6
        }
        .active {
            display: block;
        }
        h2 {
            text-align: left;
        }
        /* 오른쪽 메인 컨텐츠 */
        .content {
            flex-grow: 1;
            padding-left: 20px;
        }
        .content input {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        /*프로필수정*/
        #profileImage{
            width: 100px;
            height: 100px;
            display: block;
            margin: 0 auto 20px auto;
            border-radius: 50%;
        }
        .custom-file-upload {
            padding: 10px 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #333;
            color: white;
            cursor: pointer;
            margin-left: 10px;
        }
        .custom-file-upload:hover{
            background-color: #000;
        }
        .authSection {
            width: 100%;
            max-width: 400px; /* 최대 너비 설정 */
            margin: 0 auto; /* 가운데 정렬 */
            padding: 20px;
            text-align: center; /* 텍스트와 입력 필드를 가운데 정렬 */
        }
        .authSection input[type="text"],
        .authSection input[type="password"] {
            width: 100%; /* 입력 필드의 너비를 부모 요소에 맞춤 */
            padding: 10px;
            margin: 10px 0; /* 입력 필드 사이에 여백 */
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box; /* 패딩과 보더를 너비 계산에 포함 */
        }
        .authSection button {
            width: 100%; /* 버튼도 부모 요소에 맞춤 */
            height: 50%;
            padding: 10px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .authSection button:hover{
            background-color: #000;
        }
        /* 이메일 텍스트 스타일 */
        #account-info span {
            font-size: 16px; /* 이메일 텍스트 크기 */
            color: #555; /* 이메일 텍스트 색상 */
        }
        /*문의 기록 표스타일*/
        table {
            color: black;
            width: 100%;
            text-align: center;
            border: 1px solid #333;
            border-collapse: collapse;
        }
        table tr {
            height: 50px;
            cursor: pointer;
        }
        thead th {
            color:white;
            background-color: #333;
            padding: 5px;
        }
        td {
            padding: 5px; /* 셀 안쪽 여백 */
            border: 1px solid #333; /* 테이블 외곽 테두리 */
            border-collapse: collapse;
            /*border-bottom: 1px solid #ddd; /* 행 구분선 */
        }
        table tbody tr:hover td {
            background-color: #c6c6c6;
        }
    </style>
</head>
<body>
<div class="header">
    <div class="logo">로고</div>
    <nav>
        <a href="jobPosting.jsp">채용공고</a>
        <a href="interview.jsp">면접보기</a>
        <a href="resume.jsp">자소서등록</a>
        <a href="review.jsp">기업분석</a>
    </nav>
    <div class="auth-links">
        &nbsp;
        <a href="login.jsp">Sign in</a>
        <a href="mypage.jsp">Mypage</a>
    </div>
</div>
<!-- 나머지 페이지 내용 -->
<div class="container">
    <div class="sidebar">
        <ul>
            <li onclick="showSection('section1')">내계정</li>
            <li onclick="showSection('section2')">문의기록</li>
        </ul>
    </div>
    <div class="content">
        <!-- 내계정 섹션 -->
        <div id="section1" class="section">
            <h2>내계정</h2>
            <p> </p>
            <img src="user.jpg" alt="프로필 이미지" id="profileImage">
            <label for="profileImageUpload" class="custom-file-upload">프로필 사진 변경</label>
            <input type="file" id="profileImageUpload" accept="image/*" style="display: none;">
            <!-- 아이디와 비밀번호 확인 섹션
            <div class="authSection">
                <input type="text" name="id" id="id" placeholder="아이디" required/>
                <input type="password" name="password" class="password" placeholder="비밀번호" required/>
                <button class="submit" value="아이디/비밀번호 확인" required>아이디/비밀번호 확인</button>
                <p id="authError" style="color: red; display: none;">아이디 또는 비밀번호가 일치하지 않습니다.</p>
            </div>
            -->
            <p> </p>
            <P>이메일</P>
            <!-- 서버에서 이메일 데이터 표시 -->
        </div>
        <!-- 문의기록 섹션 -->
        <div id="section2" class="section">
            <h2>나의 문의 기록</h2>
            <table>
                <thead>
                <tr>
                    <th width="100">순번</th>
                    <th>제목</th>
                    <th width="200">날짜</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td>1</td>
                    <td>김철수</td>
                    <td>2024-09-15</td>
                </tr>
                <tr>
                    <td>2</td>
                    <td>김영희</td>
                    <td>2024-09-14</td>
                </tr>
                <!-- 행을 JavaScript로 동적 추가 -->
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
    // header.html 파일을 불러와서 #header div에 삽입
    fetch('header.jsp')
        .then(response => response.text())
        .then(data => {
            document.getElementById('header').innerHTML = data;
        });
    window.onload = function() {
        showSection('section1');
    }
    function showSection(sectionId) {
        // 모든 섹션을 숨김
        var sections = document.querySelectorAll('.section');
        sections.forEach(function (section) {
            section.classList.remove('active');
        });
        // 선택된 섹션만 표시
        var activeSection = document.getElementById(sectionId);
        activeSection.classList.add('active');
    }
    // 문의 기록 데이터 (예시)
    const inquiries = [
        { 순번: 1, 제목: "로그인 오류", 날짜: "2024-09-20", 답변수: 2 },
        { 순번: 2, 제목: "비밀번호 변경 요청", 날짜: "2024-09-18", 답변수: 1 },
        { 순번: 3, 제목: "회원가입 문제", 날짜: "2024-09-15", 답변수: 3 }
    ];
    //나의 문의 기록 테이블에 행 추가 함수
    function populateTable() {
        const tableBody = document.querySelector("#inquiryTable tbody");
        // 문의 데이터 배열을 순회하며 테이블에 행을 추가
        inquiries.forEach((inquiry) => {
            const row = document.createElement("tr");
            // 각 데이터(순번, 제목, 날짜, 답변수)를 셀로 추가
            for (let key in inquiry) {
                const cell = document.createElement("td");
                cell.textContent = inquiry[key];
                row.appendChild(cell);
            }
            tableBody.appendChild(row); // 행을 테이블에 추가
        });
    }
</script>
</body>
</html>
