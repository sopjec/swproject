<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>스크랩된 채용 공고</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f9fc;
            margin: 0;
            padding: 0;
        }

        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }

        .sidebar {
            width: 220px;
            padding: 20px;
            background-color: white;
            border-right: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.05);
        }

        .sidebar ul {
            list-style-type: none;
            padding: 0;
        }

        .sidebar ul li {
            margin-bottom: 15px;
        }

        .sidebar ul li a {
            text-decoration: none;
            color: #333;
            font-size: 16px;
            cursor: pointer;
            transition: color 0.3s ease;
        }

        .sidebar ul li a:hover {
            color: #007bff;
        }

        .content {
            flex-grow: 1;
            padding-left: 20px;
        }

        .job-listing {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .job-card {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            text-align: left;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .job-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }

        .job-card h2 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #333;
        }

        .job-card p {
            color: #666;
            font-size: 14px;
            margin: 5px 0;
        }

        .job-card a {
            color: #007bff;
            text-decoration: none;
        }

        .filters {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        #search-keyword, .filters select, #apply-filters {
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        #apply-filters {
            background-color: #007bff;
            color: white;
            border: none;
            cursor: pointer;
        }

        .pagination {
            margin-top: 20px;
            text-align: center;
        }

        .pagination button {
            margin: 0 5px;
            padding: 8px 12px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            cursor: pointer;
        }

        .pagination button.active {
            background-color: #007bff;
            color: white;
        }

        /* 모달 */
        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.4);
            z-index: 1000;
        }

        .modal-content {
            background-color: white;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            width: 300px;
            text-align: center;
        }

        .modal-content button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background-color: #007bff;
            color: white;
            cursor: pointer;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="jobPosting.jsp">기업 채용 공고</a></li>
            <li><a href="jobScrap.jsp">저장된 공고 목록</a></li>
        </ul>
    </div>
    <div class="content">
        <!-- 필터 UI -->
        <div class="filters">
            <input type="text" id="search-keyword" placeholder="검색어 입력">
            <select id="region-filter">
                <option value="">지역 선택</option>
                <option value="서울">서울</option>
                <option value="부산">부산</option>
            </select>
            <button id="apply-filters">필터 적용</button>
        </div>

        <!-- 채용 공고 리스트 -->
        <div class="job-listing">
            <c:forEach var="job" items="${jobData}">
                <div class="job-card">
                    <h2>${job.title}</h2>
                    <p>직무: ${job.duty}</p>
                    <p>고용 형태: ${job.employmentType}</p>
                    <p>근무 지역: ${job.region}</p>
                    <p>마감일: ${job.deadline}</p>
                    <a href="${job.url}" target="_blank">공고 보러가기</a>
                </div>
            </c:forEach>
        </div>
        <!-- 페이지네이션 -->
        <div class="pagination">
            <button>1</button>
            <button>2</button>
        </div>
    </div>
</div>

<!-- 모달 -->
<div id="login-modal" class="modal">
    <div class="modal-content">
        <p>로그인이 필요합니다.</p>
        <button id="login-btn">로그인</button>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const modal = document.getElementById("login-modal");
        const loginBtn = document.getElementById("login-btn");

        // 모달 표시
        function showLoginModal() {
            modal.style.display = "block";
        }

        // 로그인 페이지로 이동
        loginBtn.addEventListener("click", function () {
            window.location.href = "login.jsp";
        });

        // 필터 적용 버튼 클릭 시
        document.getElementById("apply-filters").addEventListener("click", function () {
            const keyword = document.getElementById("search-keyword").value;
            const region = document.getElementById("region-filter").value;
            window.location.href = `/scrap?keyword=${keyword}&region=${region}`;
        });
    });
</script>
</body>
</html>
