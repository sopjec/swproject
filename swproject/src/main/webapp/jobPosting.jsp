<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>기업 채용 공고</title>
    <style>
        /* CSS 설정 */
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
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

        .content {
            flex-grow: 1;
            padding-left: 20px;
        }

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
            color: #333;
        }

        .job-card p {
            color: #666;
            font-size: 14px;
            margin: 5px 0;
        }

        .job-card a {
            color: blue;
            text-decoration: underline;
        }

        .scrap-button {
            background-color: #f1c40f;
            border: none;
            border-radius: 4px;
            color: white;
            padding: 5px 10px;
            cursor: pointer;
            font-size: 14px;
            margin-top: 10px;
        }

        .scrap-button:hover {
            background-color: #d4ac0d;
        }

        .pagination {
            text-align: center;
            margin-top: 20px;
        }

        .pagination button {
            padding: 8px 12px;
            margin: 0 4px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #fff;
            cursor: pointer;
        }

        .pagination button.active {
            background-color: #333;
            color: #fff;
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
        <div class="job-listing">
            <!-- API로부터 데이터를 받아 동적으로 채워질 영역 -->
        </div>
        <div class="pagination">
            <!-- 페이지 버튼이 여기에 추가됩니다 -->
        </div>
    </div>
</div>

<!-- JavaScript 추가 -->
<script>
    document.addEventListener("DOMContentLoaded", function () {
        let currentPage = 1; // 현재 페이지 변수
        const totalPages = 5; // 총 페이지 수 (예시)

        function fetchJobPostings(pageNo) {
            const serviceKey = "m4%2BOenhwqExP36CL%2F5Pb7tiHlIxAqX75ReTHzMfWzxb%2BpEYUtedtI%2BughHYGWfH%2FXXFk3sIWKu3HIhtbYDQozw%3D%3D";
            const url = "http://apis.data.go.kr/1051000/recruitment/list?serviceKey=" + serviceKey + "&resultType=json&numOfRows=9&pageNo=" + pageNo + "&ongoingYn=Y";

            fetch(url)
                .then(response => {
                    if (!response.ok) {
                        throw new Error("Network response was not ok " + response.statusText);
                    }
                    return response.json();
                })
                .then(data => {
                    const jobListingContainer = document.querySelector(".job-listing");
                    jobListingContainer.innerHTML = ""; // 기존 내용 삭제

                    if (data.result && Array.isArray(data.result)) {
                        const items = data.result;

                        items.forEach(function(item) {
                            const jobCard = document.createElement("div");
                            jobCard.classList.add("job-card");

                            const title = document.createElement("h2");
                            title.textContent = item.instNm ? item.instNm : "기관명 없음";

                            const duty = document.createElement("p");
                            duty.textContent = "직무: " + (item.ncsCdNmLst ? item.ncsCdNmLst : "직무 정보 없음");

                            const employmentType = document.createElement("p");
                            employmentType.textContent = "고용 형태: " + (item.hireTypeNmLst ? item.hireTypeNmLst : "고용형태 없음");

                            const region = document.createElement("p");
                            region.textContent = "근무 지역: " + (item.workRgnNmLst ? item.workRgnNmLst : "근무 지역 정보 없음");

                            const deadline = document.createElement("p");
                            deadline.textContent = "마감일: " + (item.pbancEndYmd ? item.pbancEndYmd : "마감일 정보 없음");

                            const link = document.createElement("a");
                            link.href = item.srcUrl ? item.srcUrl : "#";
                            link.target = "_blank";
                            link.textContent = "공고보러가기";

                            const scrapButton = document.createElement("button");
                            scrapButton.classList.add("scrap-button");
                            scrapButton.textContent = "⭐ 스크랩";
                            scrapButton.dataset.scrapKey = item.recrutPblntSn;

                            scrapButton.addEventListener("click", function () {
                                fetch("/scrap", {
                                    method: "POST",
                                    headers: {
                                        "Content-Type": "application/x-www-form-urlencoded",
                                    },
                                    body: `scrapKey=${scrapButton.dataset.scrapKey}`,
                                })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error("스크랩 실패");
                                        }
                                        return response.text();
                                    })
                                    .then(data => {
                                        alert(data);
                                    })
                                    .catch(error => {
                                        console.error("스크랩 요청 중 오류:", error);
                                    });
                            });

                            jobCard.appendChild(title);
                            jobCard.appendChild(duty);
                            jobCard.appendChild(employmentType);
                            jobCard.appendChild(region);
                            jobCard.appendChild(deadline);
                            jobCard.appendChild(link);
                            jobCard.appendChild(scrapButton);

                            jobListingContainer.appendChild(jobCard);
                        });
                    } else {
                        jobListingContainer.innerHTML = "<p>채용 공고를 불러올 수 없습니다.</p>";
                    }

                    // 페이지네이션 생성
                    createPagination(totalPages, pageNo);
                })
                .catch(error => {
                    console.error("API 호출 중 오류 발생:", error);
                    const jobListingContainer = document.querySelector(".job-listing");
                    jobListingContainer.innerHTML = "<p>채용 공고를 불러오는 중 오류가 발생했습니다.</p>";
                });
        }

        function createPagination(totalPages, currentPage) {
            const paginationContainer = document.querySelector(".pagination");
            paginationContainer.innerHTML = ""; // 기존 페이지네이션 버튼 삭제

            for (let i = 1; i <= totalPages; i++) {
                const button = document.createElement("button");
                button.textContent = i;
                if (i === currentPage) {
                    button.classList.add("active");
                }

                button.addEventListener("click", function() {
                    currentPage = i;
                    fetchJobPostings(currentPage); // 클릭한 페이지의 데이터 로드
                });

                paginationContainer.appendChild(button);
            }
        }

        fetchJobPostings(currentPage); // 초기 페이지 데이터 로드
    });
</script>
</body>
</html>
