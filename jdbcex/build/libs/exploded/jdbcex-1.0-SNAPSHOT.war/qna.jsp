<%--
  Created by IntelliJ IDEA.
  User: User
  Date: 24. 10. 29.
  Time: 오전 2:05
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.zerock.jdbcex.dto.QnADTO" %>
<%@ page import="org.zerock.jdbcex.service.QnAService" %>
<%@ page import="java.util.List" %>
<%@ page import="org.zerock.jdbcex.dao.QnADAO" %>


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
            margin-top: 50px;
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
            background-color: #e47b8d; /* 버튼 배경 색상 */
            color: white; /* 버튼 글자 색상 */
            border: none; /* 테두리 없음 */
            padding: 10px 15px; /* 패딩 */
            cursor: pointer; /* 커서 변경 */
            border-radius: 5px; /* 모서리 둥글게 */
        }
        button:hover {
            background-color: #d46a80; /* 호버 시 색상 변경 */
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
    </style>
</head>
<body>
<div id="header"></div>

<div class="container">
    <div class="title">
        <span>· 문의하기</span>
        <button onclick="location.href='qna-submit.jsp'">문의하기</button>
    </div>
    <table>
        <thead>
        <tr>
            <th>NO</th>
            <th>제목</th>
            <th>아이디</th>
            <th>날짜</th>
            <th>답변수</th>
        </tr>
        </thead>
        <tbody>
        <%
            QnAService qnaService = new QnAService(new QnADAO());
            List<QnADTO> qnaList = qnaService.getAllQnA();
            int no = 1;
            for (QnADTO qna : qnaList) {
        %>
        <tr>
            <td><%= no++ %></td>
            <td><a href="qna-detail.jsp?id=<%= qna.getId() %>"><%= qna.getTitle() %></a></td>
            <td><%= qna.getUserId() %></td>
            <td><%= qna.getQnaDate() %></td>
            <td>0</td> <!-- 답변 수는 0으로 임시 설정 -->
        </tr>
        <%
            }
        %>
        </tbody>
    </table>

    <!-- 페이지 번호 영역 (생략 가능) -->
    <div class="pagination">
        <a href="#">&laquo;</a>
        <a href="#" class="active">1</a>
        <a href="#">2</a>
        <a href="#">3</a>
        <a href="#">4</a>
        <a href="#">5</a>
        <a href="#">&raquo;</a>
    </div>
</div>

<script>
    fetch("header.jsp")
        .then((response) => response.text())
        .then((data) => {
            document.getElementById("header").innerHTML = data;
        });
</script>
</body>
</html>