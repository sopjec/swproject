<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="org.zerock.jdbcex.dao.ResumeDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="org.zerock.jdbcex.model.Resume" %>

<%
  // introId 파라미터 가져오기
  String introIdParam = request.getParameter("introId");
  String title = "";
  List<Resume> resumes = null;

  if (introIdParam != null && !introIdParam.trim().isEmpty()) {
    int introId = Integer.parseInt(introIdParam);

    ResumeDAO resumeDAO = new ResumeDAO();
    try {
      // 특정 introId에 해당하는 제목 가져오기
      title = resumeDAO.getIntroductionTitleById(introId);

      // 특정 introId에 해당하는 질문과 답변 리스트 가져오기
      resumes = resumeDAO.getResumesByIntroId(introId);
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>자기소개서 수정</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f9f9f9;
      margin: 0;
      padding: 0;
      overflow-x: hidden;
    }
    .header {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      padding: 10px 20px;
      background-color: white;
      border-bottom: 1px solid #ddd;
    }
    .header .logo {
      font-size: 24px;
      font-weight: bold;
      margin-right: auto;
    }
    .header nav a {
      margin-left: 20px;
      color: #333;
      text-decoration: none;
      font-size: 16px;
    }
    .auth-links {
      display: flex;
      gap: 10px;
    }
    .auth-links a {
      text-decoration: none;
      padding: 10px 15px;
      border: 1px solid #ddd;
      border-radius: 4px;
      color: #333;
    }
    .auth-links a:hover {
      background-color: #f0f0f0;
    }
    .container {
      display: flex;
      width: 100%;
      max-width: 1200px;
      margin: 20px auto;
      padding: 0 20px;
      box-sizing: border-box;
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
    .content {
      flex-grow: 1;
      padding-left: 20px;
      max-width: 100%;
      width: 100%;
      box-sizing: border-box;
    }
    .resume-item {
      border: 1px solid #ddd;
      padding: 15px;
      margin-bottom: 15px;
      border-radius: 4px;
      background-color: white;
    }
    .resume-item h3 {
      font-size: 20px;
      color: #333;
    }
    .question-box {
      margin-bottom: 15px;
    }
    .question-box p, .question-box textarea, .question-box input {
      margin: 5px 0;
    }
    .question-box .question, .question-box .answer {
      font-weight: bold;
      color: #555;
      margin-bottom: 5px;
      width: 100%;
    }
    .edit-button, .save-button {
      padding: 8px 15px;
      background-color: #333;
      color: white;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 14px;
      margin-top: 10px;
    }
    .edit-button:hover, .save-button:hover {
      background-color: black;
    }
  </style>
</head>

<body>
<div class="header">
  <div class="logo">로고</div>
  <nav>
    <a href="jobPosting.html">채용공고</a>
    <a href="interview.html">면접보기</a>
    <a href="resume.html">자소서등록</a>
    <a href="review.html">기업분석</a>
  </nav>
  <div class="auth-links">
    <a href="login.html">Sign in</a>
    <a href="mypage.html">Mypage</a>
  </div>
</div>

<div class="container">
  <div class="sidebar">
    <ul>
      <li><a href="resume.html">자기소개서 등록</a></li>
      <li><a href="resume_view.jsp">자기소개서 조회</a></li>
    </ul>
  </div>

  <div class="content">
    <h2>자기소개서 수정</h2>
    <form id="resumeForm" method="post" action="updateResume">
      <input type="hidden" name="introId" value="<%= introIdParam %>">
      <div class="resume-item" id="resumeItem">
        <!-- 제목 수정 가능하도록 설정 -->
        <input type="text" name="title" value="<%= title %>" class="title" readonly>

        <!-- 기존에 등록된 질문과 답변을 보여줍니다 -->
        <%
          if (resumes != null) {
            for (int i = 0; i < resumes.size(); i++) {
              Resume resume = resumes.get(i);
        %>
        <div class="question-box">
          <input type="text" name="questions" value="<%= resume.getQuestion() %>" class="question" readonly>
          <textarea name="answers" class="answer" readonly><%= resume.getAnswer() %></textarea>
        </div>
        <%
            }
          }
        %>

        <!-- 수정하기, 저장하기 버튼 -->
        <button type="button" id="editButton" class="edit-button" onclick="editContent()">수정하기</button>
        <button type="submit" id="saveButton" class="save-button" onclick="saveContent()">저장하기</button>
      </div>
    </form>
  </div>
</div>

<script>
  function editContent() {
    // 클릭 시 제목, 질문과 답변을 수정 가능하도록 변경
    document.querySelector('.title').removeAttribute('readonly');
    const questions = document.querySelectorAll('.question');
    const answers = document.querySelectorAll('.answer');
    questions.forEach(q => q.removeAttribute('readonly'));
    answers.forEach(a => a.removeAttribute('readonly'));
  }

  function saveContent() {
    // 저장 버튼 클릭 시 읽기 전용으로 변경
    document.querySelector('.title').setAttribute('readonly', 'true');
    const questions = document.querySelectorAll('.question');
    const answers = document.querySelectorAll('.answer');
    questions.forEach(q => q.setAttribute('readonly', 'true'));
    answers.forEach(a => a.setAttribute('readonly', 'true'));
  }
</script>
</body>
</html>
