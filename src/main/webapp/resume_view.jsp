<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.zerock.jdbcex.dao.ResumeDAO" %>
<%@ page import="java.util.ArrayList" %>

<%
    ResumeDAO resumeDAO = new ResumeDAO();
    List<String[]> titlesAndUserIds = new ArrayList<>();
    try {
        titlesAndUserIds = resumeDAO.getAllIntroductionTitlesAndUserIds();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자기소개서 조회</title>
    <style>
        /* 공통 스타일 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }
        /* 상단바 스타일 */
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
        /* 메인 레이아웃 설정 */
        .container {
            display: flex;
            width: 100%;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
            box-sizing: border-box;
        }
        /* 왼쪽 사이드바 스타일 */
        .sidebar {
            width: 200px;
            padding: 20px;
            background-color: white;
            border-right: 1px solid #ddd;
            box-sizing: border-box;
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
        }
        /* 자기소개서 조회 테이블 스타일 */
        .resume-list {
            position: relative;
        }
        .resume-list table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .resume-list th, .resume-list td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: left;
        }
        .resume-list th {
            background-color: #f0f0f0;
        }
        .resume-actions {
            margin-top: 10px;
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

<!-- 메인 콘텐츠 -->
<div class="container">
    <!-- 왼쪽 사이드바 -->
    <div class="sidebar">
        <ul>
            <li><a href="resume.html">자기소개서 등록</a></li>
            <li><a href="resume_view.html">자기소개서 조회</a></li>
        </ul>
    </div>


    <div class="content">
        <h2>자기소개서 조회 및 수정</h2>
        <div class="resume-list">
            <table>
                <thead>
                <tr>
                    <th><input type="checkbox" class="checkbox" onclick="toggleAll(this)"></th>
                    <th>이름</th>
                    <th>작성자</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (String[] data : titlesAndUserIds) {
                        String title = data[0];
                        String userId = data[1];
                %>
                <tr>
                    <td><input type="checkbox" class="checkbox"></td>
                    <td><%= title %></td>
                    <td><%= userId %></td>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
            <div class="resume-actions">
                <button onclick="deleteSelected()">삭제</button>
            </div>
        </div>
    </div>
</div>

<script>
    // 모두선택 기능
    function toggleAll(checkbox) {
        const checkboxes = document.querySelectorAll('.checkbox');
        checkboxes.forEach(cb => cb.checked = checkbox.checked);
    }

    // 선택된 항목 삭제 (로컬에서 사용하던 기능은 주석 처리)
    function deleteSelected() {
        alert("선택된 항목을 삭제하는 기능은 백엔드에서 구현되어야 합니다.");
    }
</script>
</body>
</html>
