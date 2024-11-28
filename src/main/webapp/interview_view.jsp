<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>면접 녹화 기록 조회</title>

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
        .content input {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
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
        .interviewTable {
            color: black;
            width: 100%;
            text-align: center;
            border: 1px solid #333;
            border-collapse: collapse;
        }
        .interviewTable th {
            color:white;
            background-color: #333;
            padding: 5px;
        }
        .interviewTable td {
            padding: 5px;
            border: 1px solid #333;
            border-collapse: collapse;
            /*border-bottom: 1px solid #ddd; /* 행 구분선 */
        }
        .interviewTable tbody tr:hover td {
            background-color: #c6c6c6;
        }
        .interviewTable tr {
            height: 50px;
            cursor: pointer;
        }

    </style>

</head>

<body>

<!-- 헤더 JSP 파일 포함 -->
<jsp:include page="header.jsp" />

    <div class="container">
        <div class="sidebar">
            <ul>
                <li><a href="/resume?action=interview">면접 보기</a></li>
                <li><a href="interview_view.jsp">면접 기록 조회</a></li>
            </ul>
        </div>

        <!-- 메인 컨텐츠 -->
        <div class="content">
            <h2>면접기록</h2>
            <table class="interviewTable">
                <thead>
                    <tr>
                        <th width="100">순번</th>
                        <th>제목</th>
                        <th width="200">날짜</th>
                        <th width="150">영상 길이</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>예시</td>
                        <td>예시</td>
                        <td>예시</td>
                        <td>예시</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <script src="script.js"></script>
  
</body>
</html>
