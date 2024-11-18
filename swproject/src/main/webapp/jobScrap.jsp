<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>저장된 공고 목록</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .section {
            display: none;
            text-align: center;
            padding: 30px;
            width: 100%;
        }
        .section input {
            display: block;
            margin: 10px auto;
            width: 80%;
        }

        /* 메인 레이아웃 설정 */
        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }

        /* 메인 컨텐츠 */
        .content {
            flex-grow: 1;
            padding-left: 20px;
        }
        .content input {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        /* 왼쪽 사이드바 스타일 */
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
        .sidebar ul li {
            margin-bottom: 10px;
        }
        .sidebar ul li a {
            text-decoration: none;
            color: #333;
            font-size: 16px;
            cursor: pointer;
        }
        .sidebar li:hover {
            background-color: #e0e0e0;
        }

        /* 오른쪽 메인 컨텐츠 */
        h2 {
            font-size: 24px;
            margin-bottom: 20px;
        }
        /* 검색바 스타일 */
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
        /* 필터 스타일 */
        .filters {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .filters select {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 100%;
        }
        /* 리스트 스타일 */
        .job-list {
            list-style-type: none;
            padding: 0;
        }
        .job-item {
            border: 1px solid #ddd;
            padding: 10px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
        }
        .select-all {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        .select-all label {
            margin-left: 5px;
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
    <!-- 왼쪽 사이드바 -->
    <div class="sidebar">
        <ul>
            <li><a href="jobPosting.jsp">기업 채용 공고</a></li>
            <li><a href="jobScrap.jsp">저장된 공고 목록</a></li>
        </ul>
    </div>

    <!-- 오른쪽 메인 컨텐츠 -->
    <div class="content">
        <h2>저장된 공고 목록</h2>

        <!-- 검색바 -->
        <div class="search-bar">
            <input type="text" placeholder="기업명 및 키워드를 입력해주세요..">
            <button type="button">검색하기</button>
        </div>

        <!-- 필터 -->
        <div class="filters">
            <select>
                <option value="정렬순">정렬순</option>
                <option value="최신순">최신순</option>
                <option value="인기순">인기순</option>
            </select>
            <select>
                <option value="업종">업종</option>
                <option value="IT">IT</option>
                <option value="제조">제조</option>
                <option value="디자인">디자인</option>
            </select>
            <select>
                <option value="지역">지역</option>
                <option value="서울/경기도">서울/경기도</option>
                <option value="전라남도">전라남도</option>
                <option value="충청도">충청도</option>
            </select>
        </div>

        <!-- 전체선택 -->
        <div class="select-all">
            <input type="checkbox" id="selectAll" />
            <label for="selectAll">전체선택</label>
        </div>

        <!-- 채용 공고 리스트 -->
        <ul class="job-list">
            <li class="job-item">
                <div>
                    <p>A기업</p>
                    <p>경력 | 모집부문 | 고용형태 | 연봉 | 근무지역</p>
                </div>
                <input type="checkbox" class="job-checkbox">
            </li>
            <li class="job-item">
                <div>
                    <p>B기업</p>
                    <p>경력 | 모집부문 | 고용형태 | 연봉 | 근무지역</p>
                </div>
                <input type="checkbox" class="job-checkbox">
            </li>
            <li class="job-item">
                <div>
                    <p>C기업</p>
                    <p>경력 | 모집부문 | 고용형태 | 연봉 | 근무지역</p>
                </div>
                <input type="checkbox" class="job-checkbox">
            </li>
        </ul>
    </div>
</div>

<script>
    // Select the "전체선택" checkbox
    const selectAllCheckbox = document.getElementById('selectAll');

    // Select all the job checkboxes
    const jobCheckboxes = document.querySelectorAll('.job-checkbox');

    // Add event listener to the "전체선택" checkbox
    selectAllCheckbox.addEventListener('change', function() {
        jobCheckboxes.forEach(checkbox => {
            checkbox.checked = selectAllCheckbox.checked;
        });
    });

    // Add event listeners to individual job checkboxes
    jobCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            if (!checkbox.checked) {
                selectAllCheckbox.checked = false;
            }
            if (document.querySelectorAll('.job-checkbox:checked').length === jobCheckboxes.length) {
                selectAllCheckbox.checked = true;
            }
        });
    });
</script>
    
</body>
</html>
