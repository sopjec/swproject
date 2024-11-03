<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.zerock.jdbcex.dao.ResumeDAO" %>
<%@ page import="java.util.ArrayList" %>
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
            .resume-list th:first-child {
                border-right: none; /* 첫 번째 열의 오른쪽 테두리 제거 */
            }
            .resume-list th + th {
                padding-left: 0; /* 이름 셀을 체크박스 옆에 붙이기 */
            }
            .resume-actions {
                position: absolute;
                top: -40px;
                right: 0;
            }
            .content-preview {
                white-space: nowrap;
                overflow: hidden;
                text-overflow: ellipsis;
                max-width: 150px; /* 필요한 최대 너비 설정 */
            }
    </style>
</head>
<body>
<!-- 상단바 -->
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
    <!-- 오른쪽 메인 콘텐츠 -->
    <div class="content">
        <h2>자기소개서 조회 및 수정</h2>
        <div class="resume-list">
            <table>
                <thead>
                <tr>
                    <th><input type="checkbox" class="checkbox" onclick="toggleAll(this)"></th>
                    <th>이름</th>
                    <th>등록일</th>
                    <th>최종 수정일</th>
                    <th>내용 일부</th>
                </tr>
                </thead>
                <tbody id="resumeTable"></tbody>
            </table>
            <div class="resume-actions">
                <button onclick="deleteSelected()">삭제</button>
            </div>
        </div>
    </div>
</div>
<script>
    // 로컬 스토리지에서 자기소개서 로드 및 표시 >> 백엔드 연동
    function loadResumes() {
        const resumes = JSON.parse(localStorage.getItem('resumes') || '[]');
        const table = document.getElementById('resumeTable');
        table.innerHTML = '';
        resumes.forEach((resume, index) => {
            const row = document.createElement('tr');
            row.innerHTML = `
                    <td><input type="checkbox" class="checkbox" data-index="${index}"></td>
                    <td>${resume.title}</td>
                    <td>${resume.registerDate || ''}</td>
                    <td>${resume.modifiedDate || ''}</td>
                    <td class="content-preview">${resume.content ? resume.content.slice(0, 50) : ''}...</td>
                `;
            table.appendChild(row);
        });
        // 빈 공백 셀 추가
        for (let i = 0; i < 8; i++) {
            const emptyRow = document.createElement('tr');
            emptyRow.innerHTML = `
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                `;
            table.appendChild(emptyRow);
        }
    }
    /* 상단바 스타일 */
    .header {
        // 모두선택 기능 ????? 지금 셀 분할 체크박스 까지 포함해서 된건데 이거  수정해야뎀 아 전난 으앙아아아ㅏㅇ아아졸려
        function toggleAll(checkbox) {
            const checkboxes = document.querySelectorAll('.checkbox');
            checkboxes.forEach(cb => cb.checked = checkbox.checked);
        }
        // 선택된 항목 삭제
        function deleteSelected() {
            const resumes = JSON.parse(localStorage.getItem('resumes') || '[]');
            const checkboxes = document.querySelectorAll('.checkbox[data-index]:checked');
            const indicesToRemove = Array.from(checkboxes).map(cb => parseInt(cb.getAttribute('data-index')));
            indicesToRemove.sort((a, b) => b - a).forEach(index => {
                resumes.splice(index, 1);
            });
            localStorage.setItem('resumes', JSON.stringify(resumes));
            loadResumes();
        }
        // 페이지 로드 시 자기소개서 리스트 로드
        window.onload = loadResumes;
</script>
</body>
</html>