<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.zerock.jdbcex.dto.ReviewDTO" %>
<%@ page import="org.zerock.jdbcex.dto.CommentDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>면접 후기 상세보기</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
      margin: 0;
      padding: 0;
    }

    .container {
      max-width: 800px;
      margin: 20px auto;
      padding: 20px;
      background-color: white;
      border: 1px solid #ddd;
      border-radius: 5px;
    }

    .review-title {
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 10px;
    }

    .review-meta {
      color: #555;
      font-size: 14px;
      margin-bottom: 20px;
    }

    .review-content {
      font-size: 16px;
      line-height: 1.6;
      margin-bottom: 30px;
    }

    .comment-section {
      margin-top: 40px;
    }

    .comment-section h3 {
      font-size: 20px;
      margin-bottom: 10px;
    }

    .comment-form textarea {
      width: 100%;
      height: 100px;
      margin-bottom: 10px;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 14px;
    }

    .comment-form button {
      padding: 10px 20px;
      border: 1px solid black;
      background-color: white;
      font-weight: bold;
      border-radius: 4px;
      cursor: pointer;
    }

    .comment-form button:hover {
      background-color: #f0f0f0;
    }

    .comment-list {
      margin-top: 20px;
    }

    .comment-item {
      border-bottom: 1px solid #ddd;
      padding: 10px 0;
    }

    .comment-author {
      font-weight: bold;
      margin-bottom: 5px;
    }

    .comment-content {
      color: #555;
    }
  </style>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">

  <%
    // 글 상세 정보 및 댓글 리스트 가져오기
    ReviewDTO review = (ReviewDTO) request.getAttribute("review");
    List<CommentDTO> comments = (List<CommentDTO>) request.getAttribute("comments");
  %>

  <% if (review != null) { %>
  <!-- 글 상세 정보 -->
  <div class="review-title"><%= review.getComname() %> - <%= review.getJob() %></div>
  <div class="review-meta">
    작성자: <%= review.getUserId() %> | 지역: <%= review.getRegion() %> | 경력: <%= review.getExperience() %>
  </div>
  <div class="review-content">
    <%= review.getContent() %>
  </div>

  <!-- 댓글 입력 -->
  <div class="comment-section">
    <h3>댓글 달기</h3>
    <form action="comment" method="post" class="comment-form">
      <input name="review_id" value="<%= review.getId() %>">
      <textarea name="content" placeholder="댓글 내용을 입력하세요..." required></textarea>
      <button type="submit">댓글 등록</button>
    </form>
  </div>

  <!-- 댓글 리스트 -->
  <div class="comment-list">
    <h3>댓글</h3>
    <ul>
      <% if (comments != null && !comments.isEmpty()) { %>
      <% for (CommentDTO comment : comments) { %>
      <li>
        <strong><%= comment.getAuthor() %>:</strong> <%= comment.getContent() %>
        <small>(작성일: <%= comment.getCreatedDate() %>)</small>
      </li>
      <% } %>
      <% } else { %>
      <li>댓글이 없습니다.</li>
      <% } %>
    </ul>
  </div>
  <% } else { %>
  <p>리뷰 정보를 불러올 수 없습니다. 잘못된 요청입니다.</p>
  <% } %>

</div>

</body>
</html>
