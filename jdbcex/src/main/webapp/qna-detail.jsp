<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.zerock.jdbcex.dto.QnADTO" %>
<%@ page import="org.zerock.jdbcex.service.QnAService" %>
<%@ page import="org.zerock.jdbcex.dao.QnADAO" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    QnAService qnaService = new QnAService(new QnADAO());
    QnADTO qna = qnaService.getQnAById(id); // QnAService에 getQnAById 메서드 추가 필요
%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>QnA Detail</title>
    <!-- Add CSS if needed -->
</head>
<style>
    /* 공통 스타일 */
    body {
        font-family: Arial, sans-serif;
        background-color: #f9f9f9;
        margin: 0;
        padding: 0;
        color: #333;
    }

    .container {
        width: 80%;
        max-width: 1100px;
        margin: 50px auto;
        padding: 20px;
        background-color: white;
        border: 1px solid #ddd;
        box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        border-radius: 8px;
    }

    /* 제목 스타일 */
    .title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    /* 버튼 스타일 */
    button {
        background-color: #e47b8d;
        color: white;
        border: none;
        padding: 10px 15px;
        cursor: pointer;
        border-radius: 5px;
        transition: background-color 0.3s ease;
    }

    button:hover {
        background-color: #d46a80;
    }

    .back-button {
        background-color: #333;
        color: white;
        padding: 8px 12px;
        border-radius: 5px;
        text-decoration: none;
        font-size: 14px;
        transition: background-color 0.3s ease;
        display: inline-block;
    }

    .back-button:hover {
        background-color: #555;
    }

    /* 상세 정보 박스 스타일 */
    .detail-box {
        margin-bottom: 20px;
        padding: 15px;
        background-color: #f8f8f8;
        border: 1px solid #e6e6e6;
        border-radius: 5px;
    }

    .detail-box h3 {
        font-size: 18px;
        color: #666;
        margin-bottom: 10px;
    }

    .detail-box p {
        font-size: 16px;
        line-height: 1.6;
        color: #333;
    }

    /* 파일 다운로드 링크 스타일 */
    .file-link {
        display: inline-block;
        margin-top: 10px;
        font-size: 14px;
        color: #e47b8d;
        text-decoration: none;
    }

    .file-link:hover {
        text-decoration: underline;
    }

    /* 답변 상자 스타일 */
    .answer-section {
        margin-top: 30px;
    }

    .answer-section h3 {
        font-size: 20px;
        margin-bottom: 15px;
        color: #333;
    }

    .answer-box {
        background-color: #f1f1f1;
        padding: 15px;
        border: 1px solid #ddd;
        border-radius: 5px;
        margin-bottom: 15px;
    }

    .answer-box p {
        font-size: 16px;
        line-height: 1.6;
        color: #555;
    }

    .no-answer {
        font-size: 16px;
        color: #999;
        text-align: center;
        padding: 20px 0;
    }

    /* 댓글 입력 스타일 */
    .comment-section {
        margin-top: 30px;
    }

    .comment-input {
        width: 100%;
        padding: 10px;
        font-size: 16px;
        border: 1px solid #ddd;
        border-radius: 5px;
        margin-bottom: 15px;
    }

    .comment-button {
        display: block;
        background-color: #e47b8d;
        color: white;
        padding: 10px 15px;
        border: none;
        font-size: 16px;
        border-radius: 5px;
        cursor: pointer;
        width: 100%;
        transition: background-color 0.3s ease;
    }

    .comment-button:hover {
        background-color: #d46a80;
    }

    /* 반응형 스타일 */
    @media (max-width: 768px) {
        .container {
            width: 90%;
        }

        .title {
            flex-direction: column;
            align-items: flex-start;
        }

        .back-button {
            margin-top: 10px;
        }
    }

</style>
<body>
<div class="container">
    <h2>문의 상세 정보</h2>
    <p><strong>제목:</strong> <%= qna.getTitle() %></p>
    <p><strong>아이디:</strong> <%= qna.getUserId() %></p>
    <p><strong>날짜:</strong> <%= qna.getQnaDate() %></p>
    <p><strong>내용:</strong> <%= qna.getContent() %></p>
    <% if (qna.getFilePath() != null) { %>
    <p><strong>첨부 파일:</strong> <a href="<%= qna.getFilePath() %>">다운로드</a></p>
    <% } %>
    <button onclick="location.href='qna.jsp'">목록으로 돌아가기</button>
</div>
</body>
</html>
