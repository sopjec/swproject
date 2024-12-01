<%@ page import="org.zerock.jdbcex.dto.InterviewDTO" %>
<%@ page import="java.util.List" %>
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

        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0;
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

        .content {
            flex-grow: 1;
            padding: 20px;
        }

        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
        }

        table th,
        table td {
            border: 1px solid #ddd;
            padding: 15px;
            text-align: center;
        }

        table th {
            background-color: #333;
            color: white;
        }

        table tr:hover {
            background-color: #f2f2f2;
            cursor: pointer;
        }

        table tbody tr {
            height: 50px;
        }

        table tbody tr td {
            word-break: break-word;
        }

        /* 면접 기록이 없는 경우 메시지 스타일 */
        .no-records {
            text-align: center;
            font-size: 16px;
            color: #555;
            padding: 20px 0;
        }
    </style>
</head>

<body>
<jsp:include page="header.jsp" />

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="/resume?action=interview">면접 보기</a></li>
            <li><a href="interview">면접 기록 조회</a></li>
        </ul>
    </div>

    <div class="content">
        <h2>면접기록</h2>
        <table class="interviewTable">
            <thead>
            <tr>
                <th>순번</th>
                <th>제목</th>
                <th>날짜</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<InterviewDTO> interviews = (List<InterviewDTO>) request.getAttribute("interviewList");
                if (interviews != null && !interviews.isEmpty()) {
                    int index = 1; // 순번을 위한 변수
                    for (InterviewDTO interview : interviews) {
            %>
            <tr>
                <td><%= index++ %></td>
                <td>
                    <a href="/download/interview/<%= interview.getId() %>" target="_blank">
                        <%= interview.getTitle() %>
                    </a>
                </td>
                <td><%= interview.getInterviewDate() %></td>
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="3" class="no-records">면접 기록이 없습니다.</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>
