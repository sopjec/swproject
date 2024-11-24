<%@ page import="org.zerock.jdbcex.dto.ResumeQnaDTO" %>
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
        .resume-container {
            margin: 20px auto;
            padding: 20px;
            max-width: 800px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 4px;
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
    </style>
</head>
<body>
<div class="resume-container">
    <h2>자기소개서 세부 정보</h2>
    <h3>제목: <%= request.getAttribute("title") %></h3>
    <hr>
    <% List<ResumeQnaDTO> qnaList = (List<ResumeQnaDTO>) request.getAttribute("qnaList"); %>
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
</body>
</html>
