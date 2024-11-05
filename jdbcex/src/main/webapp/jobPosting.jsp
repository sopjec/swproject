<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>기업 채용 공고</title>
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

        /*오른쪽 콘텐츠 스타일*/
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
        /* 채용 공고 리스트 */
        .job-listing {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
        }
        .job-card {
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            text-align: left;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        .job-card h2 {
            font-size: 18px;
            margin-bottom: 10px;
        }
        .job-card p {
            color: #666;
            font-size: 14px;
        }
        .pagination {
            text-align: center;
            margin-top: 20px;
        }
        .pagination a {
            padding: 10px 15px;
            margin: 0 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            color: #333;
            text-decoration: none;
        }
        .pagination a:hover {
            background-color: #ddd;
        }
    </style>
</head>

<body>
    <iframe src="header.jsp" style="border:none; width:100%; height:100px;"></iframe>

    <div class="container">
        <!-- 왼쪽 사이드바 -->
        <div class="sidebar">
            <ul>
                <li><a href="jobPosting.jsp" >기업 채용 공고</a></li>
                <li><a href="jobScrap.jsp">저장된 공고 목록</a></li>
            </ul>
        </div>

        <!-- 오른쪽 메인 컨텐츠 -->
        <div class="content">
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

            <!-- 채용 공고 리스트 -->
            <div class="job-listing">
                <div class="job-card">
                    <h2>A기업</h2>
                    <p>[채용 공고 내용]</p>
                    <p>경력: 신입</p>
                    <p>모집부문: IT</p>
                    <p>고용형태: 정규직</p>
                    <p>연봉: 협의</p>
                    <p>근무지역: 서울</p>
                </div>
                <div class="job-card">
                    <h2>B기업</h2>
                    <p>[채용 공고 내용]</p>
                    <p>경력: 경력</p>
                    <p>모집부문: IT</p>
                    <p>고용형태: 정규직</p>
                    <p>연봉: 협의</p>
                    <p>근무지역: 서울</p>
                </div>
                <div class="job-card">
                    <h2>C기업</h2>
                    <p>[채용 공고 내용]</p>
                    <p>경력: 신입</p>
                    <p>모집부문: IT</p>
                    <p>고용형태: 정규직</p>
                    <p>연봉: 협의</p>
                    <p>근무지역: 경기</p>
                </div>
                <div class="job-card">
                    <h2>D기업</h2>
                    <p>[채용 공고 내용]</p>
                    <p>경력: 신입</p>
                    <p>모집부문: IT</p>
                    <p>고용형태: 정규직</p>
                    <p>연봉: 협의</p>
                    <p>근무지역: 서울</p>
                </div>
                <div class="job-card">
                    <h2>E기업</h2>
                    <p>[채용 공고 내용]</p>
                    <p>경력: 경력</p>
                    <p>모집부문: IT</p>
                    <p>고용형태: 정규직</p>
                    <p>연봉: 협의</p>
                    <p>근무지역: 경기</p>
                </div>
                <div class="job-card">
                    <h2>F기업</h2>
                    <p>[채용 공고 내용]</p>
                    <p>경력: 신입</p>
                    <p>모집부문: IT</p>
                    <p>고용형태: 정규직</p>
                    <p>연봉: 협의</p>
                    <p>근무지역: 서울</p>
                </div>
            </div>

            <!-- 페이지네이션 -->
            <div class="pagination">
                <a href="#">&laquo; Previous</a>
                <a href="#">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
                <a href="#">...</a>
                <a href="#">67</a>
                <a href="#">Next &raquo;</a>
            </div>
        </div>
    </div>

</body>
</html>
