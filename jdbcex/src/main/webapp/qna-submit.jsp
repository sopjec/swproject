<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 24. 10. 29.
  Time: 오전 2:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>QnA Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            width: 1100px;
            margin: 0 auto;
            margin-top: 20px;
            border: 1px solid rgb(27, 27, 27);
            padding: 20px;
        }
        .title {
            font-size: 24px;
            margin-bottom: 20px;
            display: flex; /* 플렉스 박스로 변경 */
            justify-content: space-between; /* 양쪽 정렬 */
            align-items: center; /* 세로 정렬 */
        }
        button {
            border: none; /* 테두리 없음 */
            padding: 10px 15px; /* 패딩 */
            cursor: pointer; /* 커서 변경 */
            border-radius: 5px; /* 모서리 둥글게 */
        }
        button:hover {
            opacity: 0.8; /* 호버 시 불투명도 변경 */
        }
        .file-select-button {
            background-color: white; /* 파일 선택 버튼 배경 색상 */
            color: #e47b8d; /* 파일 선택 버튼 글자 색상 */
        }
        .submit-button {
            background-color: #e47b8d; /* 제출 버튼 배경 색상 */
            color: white; /* 제출 버튼 글자 색상 */
        }
        .form-group {
            margin-bottom: 15px; /* 각 입력 그룹 간의 여백 추가 */
        }
        select,
        input[type="text"],
        textarea {
            padding: 5px; /* 입력 필드 안쪽 여백 */
            margin-top: 5px; /* 라벨과 입력 필드 간의 위쪽 여백 */
            border: 1px solid #000; /* 입력 필드 테두리 */
            display: block; /* 블록 요소로 설정하여 라벨 아래 배치 */
        }
        select {
            width: 200px; /* 문의 유형 선택 드롭다운 너비 */
        }
        input[type="text"] {
            width: 500px; /* 제목 입력 필드의 너비 설정 */
            height: 30px; /* 제목 입력 필드의 세로 길이 설정 */
        }
        textarea {
            width: 100%; /* 텍스트 영역 너비 고정 */
            height: 200px; /* 텍스트 영역 높이 고정 */
            resize: none; /* 사용자가 크기 조절 불가능하게 설정 */
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th,
        td {
            border: 1px solid white;
            text-align: center;
            padding: 10px;
        }
        th {
            background-color: #e47b8d;
        }
        td {
            height: 40px;
        }
        /* 각 열의 넓이 조정 */
        th:nth-child(1) {
            width: 5%;
        } /* 순번 */
        th:nth-child(2) {
            width: 60%;
        } /* 제목 */
        th:nth-child(3) {
            width: 15%;
        } /* 아이디 */
        th:nth-child(4) {
            width: 10%;
        } /* 날짜 */
        th:nth-child(5) {
            width: 10%;
        } /* 답변수 */
        /* 페이지 번호 영역 스타일 */
        .pagination {
            text-align: center; /* 페이지 번호 가운데 정렬 */
            margin-top: 50px; /* 테이블과 페이지 번호 사이의 여백 */
            margin-bottom: 20px; /* 페이지 번호와 화면 하단 사이의 여백 */
        }
        .pagination a {
            display: inline-block;
            padding: 10px 15px;
            margin: 0 5px;
            text-decoration: none;
            border: 1px solid #ccc;
            color: #333;
        }
        .pagination a.active {
            background-color: #e47b8d;
            color: white;
            border: 1px solid #e47b8d;
        }
        .pagination a:hover {
            background-color: #ddd;
        }
        .button-container {
            display: flex; /* 버튼들을 플렉스 박스로 배치 */
            justify-content: space-between; /* 버튼을 양 끝에 배치 */
            margin-top: 10px; /* 버튼 상단 여백 */
        }
    </style>
</head>
<body>
<!-- header.html 파일을 불러와서 삽입할 헤더 공간 -->
<div id="header"></div>

<!-- 문의 작성하기 폼을 담고 있는 컨테이너 -->
<div class="container">
    <div class="title">
        <h2>· 문의 작성하기</h2>
    </div>

    <!-- QnASubmitController로 폼 데이터 전송 -->
    <form action="submit" method="post" enctype="multipart/form-data">
        <!-- 문의 유형 선택 드롭다운 -->
        <div class="form-group">
            <label for="query-type">문의유형 선택</label>
            <select id="query-type" name="category"> <!-- name 속성 추가 -->
                <option value="type1">문의유형1</option>
                <option value="type2">문의유형2</option>
                <option value="type3">문의유형3</option>
            </select>
        </div>

        <!-- 제목 입력 필드 -->
        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" id="title" name="title" placeholder="제목" /> <!-- name="title" 확인 -->
        </div>

        <!-- 내용 작성 텍스트 영역 -->
        <div class="form-group">
            <label for="content">작성하기</label>
            <textarea id="content" name="content" placeholder="내용을 작성하세요"></textarea>
        </div>

        <!-- 파일 선택 및 제출 버튼 -->
        <div class="button-container">
            <button type="button" class="file-select-button">파일선택</button>
            <button type="submit" class="submit-button">제출</button>
        </div>
    </form>

</div>

<!-- header.html 파일을 불러와서 #header div에 삽입하는 스크립트 -->
<script>
    fetch("header.jsp") // header.html 파일을 요청
        .then((response) => response.text()) // 파일 내용을 텍스트로 변환
        .then((data) => {
            document.getElementById("header").innerHTML = data; // 파일 내용을 #header div에 삽입
        });
</script>
</body>
</html>