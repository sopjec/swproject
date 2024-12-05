<%@ page import="java.util.List" %>
<%@ page import="org.zerock.jdbcex.dto.ReviewDTO" %>
<%@ page import="org.zerock.jdbcex.dto.CommentDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <jsp:include page="checkSession.jsp"/>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>리뷰 상세 보기</title>
  <link rel="stylesheet" type="text/css" href="layout.css">
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
      margin: 0;
      padding: 0;
    }

    .review-header h3 {
      font-size: 24px;
      margin: 0;
      color: #333;
    }

    .review-meta {
      display: flex;
      justify-content: space-between;
      color: #888;
      font-size: 14px;
      margin-top: 5px;
    }

    .review-content {
      margin-top: 20px;
      padding-top: 10px;
      border-top: 1px solid #ddd;
      color: #555;
      line-height: 1.6;
    }

    .like-button {
      display: flex;
      align-items: center;
      background: none;
      border: none;
      cursor: pointer;
      font-size: 16px;
      color: #555;
      transition: all 0.3s ease;
    }

    .like-button:hover {
      color: #333;
    }

    .like-icon {
      width: 20px;
      height: 20px;
      margin-right: 8px;
      transition: transform 0.3s ease;
    }

    .like-button:hover .like-icon {
      transform: scale(1.2);
    }

    .like-text {
      margin-right: 5px;
    }

    .like-count {
      font-weight: bold;
    }


    .comment-section {
      margin-top: 30px;
      padding-top: 10px;
      border-top: 1px solid #ddd;
    }

    .comment-form {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 10px;
    }

    .comment-form textarea {
      width: calc(100% - 120px); /* 텍스트 영역과 버튼 간격 유지 */
      padding: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }

    .comment-form button {
      background-color: black;
      color: white;
      border: none;
      border-radius: 4px;
      padding: 8px 12px;
      cursor: pointer;
      font-size: 14px;
      transition: background-color 0.3s;
      margin-left: 10px; /* 버튼과 텍스트 필드 간격 추가 */
    }

    .comment-form button:hover {
      background-color: gray;
    }

    .comment-box {
      margin-top: 15px;
      padding: 15px;
      border: 1px solid #ddd;
      border-radius: 5px;
      background-color: #f9f9f9;
    }

    .comment-header {
      font-weight: bold;
      margin-bottom: 10px;
      color: #333;
    }

    .comment-content {
      color: #555;
      margin-bottom: 10px;
    }

    .reply-box {
      margin-left: 20px;
      margin-top: 10px;
      border-left: 2px solid #ddd;
      padding-left: 10px;
    }

    .reply-button {
      background-color: black;
      color: white;
      border: none;
      border-radius: 4px;
      padding: 5px 10px;
      cursor: pointer;
      font-size: 14px;
      transition: background-color 0.3s;
    }

    .reply-button:hover {
      background-color: gray;
    }

  </style>
</head>
<body>
<jsp:include page="header.jsp"/>
<div class="container">
  <div class="sidebar">
    <ul>
      <li><a href="reviewUpload">기업 면접 후기</a></li>
    </ul>
  </div>
<div class="content">

  <%
    // 리뷰 데이터
    ReviewDTO review = (ReviewDTO) request.getAttribute("review");
    List<CommentDTO> comments = (List<CommentDTO>) request.getAttribute("comments");
    boolean isLikedByUser = (boolean) request.getAttribute("likedByUser");
  %>
  <!-- 리뷰 상세 정보 -->
  <div class="review-header">
    <h3><%= review.getComname() %></h3>
    <div class="review-meta">
      <div>
        작성자: <%= review.getUserId() %> | 지역: <%= review.getRegion() %> | 경력: <%= review.getExperience() %>| 등록일:<%=review.getCreatedDate()%>
      </div>
      <span id="like-count-<%= review.getId() %>">공감수: <%= review.getLikes() %></span>
    </div>
  </div>
  <div class="review-content">
    <p><%= review.getContent() %></p>
  </div>

  <!-- 공감 버튼 (폼 방식) -->
  <div class="like-section">
    <form action="reviewDetail" method="post">
      <input type="hidden" name="action" value="like">
      <input type="hidden" name="reviewId" value="6">
      <button class="like-button" type="button" onclick="toggleLike(this)">
        <img
                src="noheart.png"
                class="like-icon"
                alt="like-icon">
        <span class="like-text">공감</span>
        <span class="like-count">0</span>
      </button>
    </form>
  </div>






  <!-- 댓글 쓰기 -->
  <div class="comment-section">
    <h4>댓글</h4>
    <form action="reviewDetail?action=addComment" method="post" class="comment-form">
      <input type="hidden" name="parentCommentId" value="">
      <input type="hidden" name="reviewId" value="<%= review.getId() %>">
      <textarea name="content" placeholder="댓글을 입력하세요..." required></textarea>
      <button style="right: 20px"type="submit">댓글 등록</button>
    </form>

    <!-- 댓글과 대댓글 -->
    <%
      if (comments != null && !comments.isEmpty()) {
        for (CommentDTO comment : comments) {
          if (comment.getParentCommentId() == null) { // 댓글만 렌더링
    %>
    <div class="comment-box">
      <div class="comment-header">작성자: <%= comment.getAuthor() %></div>
      <div class="comment-content"><%= comment.getContent() %></div>
      <button class="reply-button" onclick="toggleReplyForm('<%= comment.getId() %>')">답글</button>

      <!-- 대댓글 -->
      <div class="reply-box">
        <%
          for (CommentDTO reply : comments) {
            if (reply.getParentCommentId() != null && reply.getParentCommentId().equals(comment.getId())) {
        %>
        <div class="comment-box">
          <div class="comment-header">작성자: <%= reply.getAuthor() %></div>
          <div class="comment-content"><%= reply.getContent() %></div>
        </div>
        <%
            }
          }
        %>
      </div>

      <!-- 대댓글 작성 폼 -->
      <div class="reply-form" id="reply-form-<%= comment.getId() %>" style="display:none;">
        <form action="reviewDetail?action=addComment" method="post" class="comment-form">
          <input type="hidden" name="parentCommentId" value="<%= comment.getId() %>">
          <input type="hidden" name="reviewId" value="<%= review.getId() %>">
          <textarea name="content" placeholder="대댓글을 입력하세요..." required></textarea>
          <button type="submit">대댓글 등록</button>
        </form>
      </div>
    </div>

    <%
        }
      }
    } else {
    %>
    <p>댓글이 없습니다. 첫 댓글을 작성해보세요!</p>
    <% } %>
  </div>
</div>

</div>
<script>
  function toggleLike(button) {
    const form = button.closest('form'); // 버튼의 부모 form을 찾습니다.
    if (!form) {
      console.error("Form not found for the like button.");
      return;
    }

    const likeIcon = button.querySelector('.like-icon');
    const likeCount = button.querySelector('.like-count');
    const actionInput = form.querySelector("input[name='action']");
    if (!actionInput) {
      console.error("Action input not found in the form.");
      return;
    }

    const currentAction = actionInput.value;
    const isLiked = currentAction === "unlike";

    // 상태 전환
    actionInput.value = isLiked ? "like" : "unlike";

    // 서버 요청
    fetch(form.action, {
      method: 'POST',
      body: new FormData(form),
    })
            .then(response => {
              if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
              }
              return response.json();
            })
            .then(data => {
              if (data.error) {
                alert(data.error);
              } else {
                likeCount.textContent = data.likes; // 공감수 업데이트
                likeIcon.src = isLiked ? "noheart.png" : "yesheart.png"; // 아이콘 업데이트
              }
            })
            .catch(error => {
              console.error("서버 요청 중 오류 발생:", error);
              alert("서버와 통신 중 문제가 발생했습니다.");
            });
  }

</script>

</body>
</html>
