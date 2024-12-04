<!--왜 나만 안되는건지fkfwlfkwlf-->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="org.zerock.jdbcex.dto.ReviewDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="checkSession.jsp"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/layout.css"> <!-- 올바른 경로 설정 -->
    <title>면접후기</title> <!--커뮤니티/실제 기업 면접 후기 -->
    <style>
        .search-bar {
            display: flex;
            margin-bottom: 20px;
        }
        .search-bar input {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .search-bar button {
            padding: 10px 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #333;
            color: white;
            cursor: pointer;
            margin-left: 10px;
        }
        .search-bar button:hover {
            background-color: #000;
        }

        .filters {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .filters select {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        /* 테이블과 등록하기 버튼을 포함한 컨테이너 */
        .table-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .register-button {
            padding: 10px 15px;
            border: 1px solid black;
            background-color: white;
            color: black;
            cursor: pointer;
            font-weight: bold;
            border-radius: 4px;
        }
        .register-button:hover {
            background-color: #f0f0f0;
        }
        /* 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>

</head>

<body>

<jsp:include page="header.jsp"/>

<%
    // 데이터베이스에서 가져온 면접 후기 리스트를 가져옴
    List<ReviewDTO> reviews = (List<ReviewDTO>) request.getAttribute("reviews");
    System.out.println(reviews);
%>

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="reviewUpload">기업 면접 후기</a></li>
        </ul>
    </div>


    <!-- 메인 컨텐츠 -->
    <div class="content">
        <!-- 검색바 -->
        <form action="reviewUpload" method="get" class="search-bar">
            <input type="text" name="search"
                   placeholder="기업명 및 키워드를 입력해주세요.."
                   value="<%= (request.getParameter("search") != null) ? request.getParameter("search") : "" %>">
            <button type="submit">검색하기</button>
        </form>

        <!-- 필터 -->
        <form action="reviewUpload" method="get" class="filters">
            <select name="sort">
                <option value="정렬순" <%= "정렬순".equals(request.getParameter("sort")) ? "selected" : "" %>>정렬순</option>
                <option value="최신순" <%= "최신순".equals(request.getParameter("sort")) ? "selected" : "" %>>최신순</option>
                <option value="인기순" <%= "인기순".equals(request.getParameter("sort")) ? "selected" : "" %>>인기순</option>
            </select>
            <select name="experience">
                <option value="">경력 전체</option>
                <option value="신입" <%= "신입".equals(request.getParameter("experience")) ? "selected" : "" %>>신입</option>
                <option value="인턴" <%= "인턴".equals(request.getParameter("experience")) ? "selected" : "" %>>인턴</option>
                <option value="경력" <%= "경력".equals(request.getParameter("experience")) ? "selected" : "" %>>경력</option>
            </select>
            <select name="region">
                <option value="">지역 전체</option>
                <option value="서울" <%= "서울".equals(request.getParameter("region")) ? "selected" : "" %>>서울</option>
                <option value="경기도" <%= "경기도".equals(request.getParameter("region")) ? "selected" : "" %>>경기도</option>
                <option value="강원도" <%= "강원도".equals(request.getParameter("region")) ? "selected" : "" %>>강원도</option>
                <option value="충청북도" <%= "충청북도".equals(request.getParameter("region")) ? "selected" : "" %>>충청북도</option>
                <option value="충청남도" <%= "충청남도".equals(request.getParameter("region")) ? "selected" : "" %>>충청남도</option>
                <option value="전라북도" <%= "전라북도".equals(request.getParameter("region")) ? "selected" : "" %>>전라북도</option>
                <option value="전라남도" <%= "전라남도".equals(request.getParameter("region")) ? "selected" : "" %>>전라남도</option>
                <option value="경상북도" <%= "경상북도".equals(request.getParameter("region")) ? "selected" : "" %>>경상북도</option>
                <option value="경상남도" <%= "경상남도".equals(request.getParameter("region")) ? "selected" : "" %>>경상남도</option>
            </select>
            <button type="submit">필터 적용</button>
        </form>

        <!-- 테이블과 등록하기 버튼 -->
        <div class="table-container">
            <h3>면접 후기 목록</h3>
            <a href="review_upload.jsp">
                <button class="register-button">등록하기</button>
            </a>
        </div>

        <!-- 테이블 형식의 채용 공고 리스트 -->
        <table>
            <thead>
            <tr>
                <th>순번</th>
                <th>기업명</th>
                <th>직무·직업</th>
                <th>경력</th>
                <th>지역</th>
                <th>등록 날짜</th> <!-- 등록 날짜 컬럼 추가 -->
                <th>공감 수</th> <!-- 공감 수 컬럼 추가 -->
            </tr>
            </thead>
            <tbody>
            <%
                // 리뷰 데이터 출력
                if (reviews != null && !reviews.isEmpty()) {
                    int index = 1; // 순번을 동적으로 생성
                    for (ReviewDTO review : reviews) {
            %>
            <tr onclick="location.href='reviewDetail?review_id=<%= review.getId() %>'" style="cursor: pointer;">
                <td><%= index++ %></td>
                <td><%= review.getComname() %></td>
                <td><%= review.getExperience() %></td>
                <td><%= review.getJob() %></td>
                <td><%= review.getRegion() %></td>
                <td><%= review.getCreatedDate().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")) %></td> <!-- 등록 날짜 표시 -->
                <td><%= review.getLikes() %></td> <!-- 공감 수 표시 -->
            </tr>
            <%
                }
            } else {
            %>
            <tr>
                <td colspan="7">등록된 면접 후기가 없습니다.</td>
            </tr>
            <% } %>
            </tbody>

        </table>

    </div>
</div>

</body>
</html>