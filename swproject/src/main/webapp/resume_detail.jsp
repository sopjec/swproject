<%@ page import="org.zerock.jdbcex.dto.ResumeQnaDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자기소개서 세부 정보</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
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
        .resume-container {
            width: 100%;
            margin: 0;
            padding: 20px;
            max-width: 800px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .title-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .question-box {
            margin-bottom: 15px;
        }
        .question {
            font-weight: bold;
            color: #333;
        }
        .answer {
            margin-top: 5px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #f9f9f9;
        }
        .edit-button, .save-button, .vocab-button {
            padding: 8px 15px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .edit-button:hover, .save-button:hover, .vocab-button:hover {
            background-color: black;
        }
        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        #vocabularyResult {
            display: none;
            margin-top: 20px;
            padding: 15px;
            background-color: #f4f4f4;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp"/>


<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="resume.jsp">자기소개서 등록</a></li>
            <li><a href="resume_view">자기소개서 조회</a></li>
            <li><a href="resume_analyze.jsp">자기소개서 분석</a></li>
        </ul>
    </div>

    <div class="resume-container">
        <div class="title-row">
            <h2 id="resumeTitle"><%= request.getAttribute("title") %></h2>
            <button class="edit-button" onclick="enableEditing()">수정하기</button>
        </div>
        <hr>
        <% List<ResumeQnaDTO> qnaList = (List<ResumeQnaDTO>) request.getAttribute("qnaList"); %>
        <% System.out.println(qnaList); %>
        <% if (qnaList != null) {
            for (ResumeQnaDTO qna : qnaList) { %>
        <div class="question-box">
            <p class="question">질문: <%= qna.getQuestion() %></p>
            <p class="answer">답변: <%= qna.getAnswer() %></p>
        </div>
        <% } } else { %>
        <p>질문과 답변이 없습니다.</p>
        <% } %>
    </div>


</div>

</body>
</html>