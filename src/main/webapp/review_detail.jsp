<%@ page import="java.util.List" %>
<%@ page import="org.zerock.jdbcex.dto.ReviewDTO" %>
<%@ page import="org.zerock.jdbcex.dto.CommentDTO" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>리뷰 상세 보기</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f9;
      margin: 0;
      padding: 0;
    }
    .container {
      max-width: 800px;
      margin: 20px auto;
      padding: 20px;
      background-color: #fff;
      border-radius: 10px;
      box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    }
    .review-header {
      margin-bottom: 20px;
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
    .like-section {
      margin-top: 20px;
      padding-top: 10px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .like-button {
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 4px;
      padding: 8px 16px;
      cursor: pointer;
      font-size: 14px;
    }
    .like-button:hover {
      background-color: #0056b3;
    }
    .comment-section {
      margin-top: 30px;
      padding-top: 10px;
      border-top: 1px solid #ddd;
    }
    .comment-form textarea {
      width: 100%;
      padding: 10px;
      margin-top: 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 14px;
    }
    .comment-form button {
      margin-top: 10px;
      background-color: #28a745;
      color: white;
      border: none;
      border-radius: 4px;
      padding: 8px 12px;
      cursor: pointer;
      font-size: 14px;
    }
    .comment-form button:hover {
      background-color: #218838;
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
      background-color: #007bff;
      color: white;
      border: none;
      border-radius: 4px;
      padding: 5px 10px;
      cursor: pointer;
      font-size: 14px;
    }
    .reply-button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>
<div class="container">
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
        작성자: <%= review.getUserId() %> | 지역: <%= review.getRegion() %> | 경력: <%= review.getExperience()%>
      </div>
      <span id="like-count-<%= review.getId() %>">공감수: <%= review.getLikes() %></span>
    </div>
  </div>
  <div class="review-content">
    <p><%= review.getContent() %></p>
  </div>

  <!-- 공감 버튼 -->
  <div class="like-section">
    <button class="like-button" data-id="<%= review.getId() %>" data-action="<%= isLikedByUser ? "unlike" : "like" %>">
      <%= isLikedByUser ? "공감 취소" : "공감" %>
    </button>

  </div>

  <!-- 댓글 쓰기 -->
  <div class="comment-section">
    <h4>댓글</h4>
    <form action="reviewDetail?action=addComment" method="post" class="comment-form">
      <input type="hidden" name="parentCommentId" value="">
      <input type="hidden" name="reviewId" value="<%= review.getId() %>">
      <textarea name="content" placeholder="댓글을 입력하세요..." required></textarea>
      <button type="submit">댓글 등록</button>
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

<script>
  document.querySelectorAll('.like-button').forEach(function(button) {
    button.addEventListener('click', function() {
      const reviewId = button.getAttribute('data-id');
      const currentAction = button.getAttribute('data-action');

      console.log("reviewId: " + reviewId);

      fetch('/reviewDetail?action=' + currentAction, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ reviewId: reviewId }) // reviewId만 전송
      })
              .then(response => {
                if (!response.ok) {
                  throw new Error("HTTP status " + response.status);
                }
                return response.json();
              })
              .then(data => {
                console.log("Response data:", data);

                // 공감 수 업데이트
                const likeCountSpan = document.getElementById('like-count-' + reviewId);
                if (likeCountSpan) {
                  likeCountSpan.innerText = data.likes;
                }

                // 버튼 상태 업데이트
                if (currentAction === 'like') {
                  button.innerText = '공감 취소';
                  button.setAttribute('data-action', 'unlike');
                } else {
                  button.innerText = '공감';
                  button.setAttribute('data-action', 'like');
                }
              })
              .catch(error => {
                console.error('Error:', error);
              });
    });
  });


  function toggleReplyForm(id) {
    const replyForm = document.getElementById('reply-form-' + id);
    replyForm.style.display = replyForm.style.display === 'none' ? 'block' : 'none';
  }
</script>
</body>
</html>
