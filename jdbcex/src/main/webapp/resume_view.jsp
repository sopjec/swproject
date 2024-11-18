<%@ page import="org.zerock.jdbcex.dto.ResumeDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자기소개서 조회</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
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
        .auth-links a {
            text-decoration: none;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            color: #333;
        }
        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
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
        }
        .resume-list table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .resume-list th, .resume-list td {
            border: 1px solid #ddd;
            padding: 10px;
        }
        .resume-list th {
            background-color: #f0f0f0;
        }
        .resume-list tr:hover {
            background-color: #f9f9f9;
            cursor: pointer;
        }
    </style>
    <script>
        // header.html 파일을 불러오는 함수
        function loadHeader() {
            fetch("header.jsp")
                .then(response => response.text())
                .then(data => {
                    document.getElementById("header-container").innerHTML = data;
                })
                .catch(error => console.error("Error loading header:", error));
        }

        window.onload = loadHeader; // 페이지가 로드될 때 헤더를 불러옴
    </script>
</head>

<body>

<!-- 헤더가 로드될 위치 -->
<div id="header-container"></div>

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="resume.jsp">자기소개서 등록</a></li>
            <li><a href="resume">자기소개서 조회</a></li>
            <li><a href="resume_analyze.jsp">자기소개서 분석</a></li>
        </ul>
    </div>
    <div class="content">
        <h2>자기소개서 조회</h2>
        <div class="resume-list">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>제목</th>
                </tr>
                </thead>
                <tbody>
                <% List<ResumeDTO> resumes = (List<ResumeDTO>) request.getAttribute("resumes"); %>
                <% if (resumes != null && !resumes.isEmpty()) { %>
                <% for (ResumeDTO resume : resumes) { %>
                <tr onclick="viewDetail('<%= resume.getId() %>')">
                    <td><%= resume.getId() %></td>
                    <td><%= resume.getTitle() %></td>
                </tr>
                <% } %>
                <% } else { %>
                <tr>
                    <td colspan="2">등록된 자기소개서가 없습니다.</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script>
    function viewDetail(id) {
        window.location.href = '/resume_detail?id=' + id;
    }
</script>
</body>
</html>
