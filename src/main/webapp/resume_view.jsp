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
        /* 기존 CSS 스타일 유지 */
    </style>
</head>

<body>
<div class="header">
    <!-- 기존 상단바 코드 유지 -->
</div>

<div class="container">
    <div class="sidebar">
        <!-- 기존 사이드바 코드 유지 -->
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
