<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.zerock.jdbcex.dto.ReviewDTO" %>
<%@ page import="org.zerock.jdbcex.dto.CommentDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="/layout.css"> <!-- 올바른 경로 설정 -->
  <title>면접 후기 상세보기</title>
  <style>
    .review-title {
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 20px;
      border-bottom: 2px solid #ddd;
      padding-bottom: 10px;
    }

    .review-meta {
      color: #666;
      font-size: 14px;
      margin-bottom: 20px;
    }

    .review-content {
      font-size: 16px;
      line-height: 1.6;
      margin-bottom: 40px;
      background-color: #f9f9f9;
      padding: 20px;
      border-radius: 5px;
      border: 1px solid #ddd;
    }
    .like-section {
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 10px;
    }

    .like-section button {
      padding: 10px 20px;
      border: 1px solid #ddd;
      border-radius: 4px;
      background-color: #333;
      color: white;
      cursor: pointer;
    }

    .like-section button:hover {
      background-color: #000;
    }

    .comment-section {
      margin-top: 40px;
    }

    .comment-section h3 {
      font-size: 20px;
      margin-bottom: 15px;
    }

    .comment-form textarea {
      width: 100%;
      height: 100px;
      margin-bottom: 10px;
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 14px;
      resize: none;
    }

    .comment-form button {
      padding: 10px 20px;
      border: none;
      background-color: #333;
      color: white;
      font-weight: bold;
      border-radius: 4px;
      cursor: pointer;
    }

    .comment-form button:hover {
      background-color: #000;
    }

    .comment-list {
      margin-top: 20px;
    }

    .comment-item {
      border-bottom: 1px solid #ddd;
      padding: 15px 0;
    }

    .comment-author {
      font-weight: bold;
      margin-bottom: 5px;
    }

    .comment-content {
      color: #555;
      margin-bottom: 10px;
    }

    .reply-section {
      margin-top: 10px;
      padding-left: 20px;
      display: none; /* 기본적으로 숨김 */
    }

    .reply-section textarea {
      width: 90%;
      height: 50px;
      margin-bottom: 10px;
      padding: 5px;
      border: 1px solid #ddd;
      border-radius: 5px;
      font-size: 14px;
    }

    .reply-section button {
      padding: 5px 15px;
      border: 1px solid black;
      background-color: white;
      font-weight: bold;
      border-radius: 4px;
      cursor: pointer;
    }

    .reply-section button:hover {
      background-color: #f0f0f0;
    }
  </style>

  <script>
    function toggleReplyForm(commentId) {
      const replyForm = document.getElementById('reply-form-' + commentId);
      replyForm.style.display = replyForm.style.display === 'block' ? 'none' : 'block';
    }
  </script>
</head>
<body>

<jsp:include page="header.jsp" />

<div class="container">
  <!-- 사이드바 -->
  <div class="sidebar">
    <ul>
      <li><a href="review.jsp">기업 면접 후기</a></li>
    </ul>
  </div>

  <!-- 메인 콘텐츠 -->
  <div class="content">
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

    <%
      Boolean isLikedByUser = (Boolean) request.getAttribute("likedByUser");
      if (isLikedByUser == null) {
        isLikedByUser = false; // 기본값 설정
      }
    %>
    <!-- 공감 버튼 -->
    <div class="like-section">
      <button onclick="location.href='<%= isLikedByUser ? "unlikeReview" : "likeReview" %>?review_id=<%= review.getId() %>'">
        <%= isLikedByUser ? "공감 취소" : "공감하기" %> (<%= review.getLikes() %>)
      </button>
    </div>

    <!-- 댓글 입력 -->
    <div class="comment-section">
      <h3>댓글 달기</h3>
      <form action="comment" method="post" class="comment-form">
        <input name="review_id" value="<%= review.getId() %>" type="hidden">
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
        <li class="comment-item">
          <div class="comment-author"><%= comment.getAuthor() %></div>
          <div class="comment-content"><%= comment.getContent() %></div>
          <small>(작성일: <%= comment.getCreatedDate() %>)</small>

          <!-- 답글 버튼 -->
          <button onclick="toggleReplyForm('<%= comment.getId() %>')">답글</button>

          <!-- 대댓글 입력 -->
          <div id="reply-form-<%= comment.getId() %>" class="reply-section">
            <form action="reviewDetail" method="post">
              <input type="hidden" name="action" value="replyComment">
              <input type="hidden" name="parent_comment_id" value="<%= comment.getId() %>">
              <input type="hidden" name="review_id" value="<%= review.getReviewId() %>">
              <textarea name="reply_content" placeholder="답글을 입력하세요..." required></textarea>
              <button type="submit">답글 등록</button>
            </form>
          </div>
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
</div>

</body>
</html>
