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
            position: relative;
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
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: white;
            color: #f1c40f;
            border: none;
            width: 30px;
            height: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 18px;
            cursor: pointer;
        }

        .scrap-button:hover {
            opacity: 0.8;
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

        /* 모달창 스타일 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }

        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 300px;
            text-align: center;
            border-radius: 8px;
        }

        .modal-content p {
            margin: 20px 0;
            font-size: 16px;
        }

        .close-btn, .login-btn {
            background-color: #333;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }

        .login-btn {
            background-color: #007bff;
            margin-top: 10px;
        }

        .close-btn:hover, .login-btn:hover {
            opacity: 0.8;
        }
    </style>
</head>

<body>
<!-- 헤더 JSP 파일 포함 -->
<jsp:include page="header.jsp" />

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

<!-- 모달창 -->
<div id="login-modal" class="modal">
    <div class="modal-content">
        <p>로그인이 필요합니다.</p>
        <button class="close-btn" id="close-modal">닫기</button>
        <button class="login-btn" id="go-login">로그인 페이지로 이동</button>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        let currentPage = 1; // 현재 페이지
        const totalPages = 5; // 총 페이지 수 (예시)

        // 모달창 관련 요소
        const modal = document.getElementById("login-modal");
        const closeModal = document.getElementById("close-modal");
        const goLogin = document.getElementById("go-login");

        // 모달창 닫기
        closeModal.addEventListener("click", function () {
            modal.style.display = "none";
        });

        // 로그인 페이지로 이동
        goLogin.addEventListener("click", function () {
            window.location.href = "login.jsp";
        });

        // 채용 공고 불러오기
        function fetchJobPostings(pageNo) {
            const serviceKey = "m4%2BOenhwqExP36CL%2F5Pb7tiHlIxAqX75ReTHzMfWzxb%2BpEYUtedtI%2BughHYGWfH%2FXXFk3sIWKu3HIhtbYDQozw%3D%3D";
            const url = "http://apis.data.go.kr/1051000/recruitment/list?serviceKey=" + serviceKey + "&resultType=json&numOfRows=9&pageNo=" + pageNo + "&ongoingYn=Y";

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    const jobListingContainer = document.querySelector(".job-listing");
                    jobListingContainer.innerHTML = "";

                    if (data.result && Array.isArray(data.result)) {
                        const items = data.result;

                        items.forEach(item => {
                            const jobCard = document.createElement("div");
                            jobCard.classList.add("job-card");

                            const title = document.createElement("h2");
                            title.textContent = item.instNm || "기관명 없음";

                            const duty = document.createElement("p");
                            duty.textContent = "직무: " + (item.ncsCdNmLst || "정보 없음");

                            const employmentType = document.createElement("p");
                            employmentType.textContent = "고용 형태: " + (item.hireTypeNmLst || "정보 없음");

                            const region = document.createElement("p");
                            region.textContent = "근무 지역: " + (item.workRgnNmLst || "정보 없음");

                            const deadline = document.createElement("p");
                            deadline.textContent = "마감일: " + (item.pbancEndYmd || "정보 없음");

                            const link = document.createElement("a");
                            link.href = item.srcUrl || "#";
                            link.target = "_blank";
                            link.textContent = "공고보러가기";

                            const scrapButton = document.createElement("button");
                            scrapButton.classList.add("scrap-button");
                            scrapButton.textContent = "⭐";
                            scrapButton.dataset.scrapKey = item.recrutPblntSn;

                            // 스크랩 버튼 클릭 이벤트
                            scrapButton.addEventListener("click", function () {
                                const scrapKey = scrapButton.dataset.scrapKey;

                                fetch("/scrap", {
                                    method: "POST",
                                    headers: { "Content-Type": "application/json" },
                                    body: JSON.stringify(scrapKey)
                                })
                                    .then(response => {
                                        if (response.status === 401) {
                                            modal.style.display = "block";
                                            return null;
                                        }
                                        if (!response.ok) throw new Error("스크랩 실패");
                                        return response.text();
                                    })
                                    .then(data => {
                                        if (data) alert(data);
                                    })
                                    .catch(error => console.error("스크랩 요청 실패:", error));
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

                    createPagination(totalPages, pageNo);
                })
                .catch(error => console.error("API 호출 실패:", error));
        }

        // 페이지네이션 생성
        function createPagination(totalPages, currentPage) {
            const paginationContainer = document.querySelector(".pagination");
            paginationContainer.innerHTML = "";

            for (let i = 1; i <= totalPages; i++) {
                const button = document.createElement("button");
                button.textContent = i;
                if (i === currentPage) {
                    button.classList.add("active");
                }
                button.addEventListener("click", function () {
                    currentPage = i;
                    fetchJobPostings(currentPage);
                });
                paginationContainer.appendChild(button);
            }
        }

        fetchJobPostings(currentPage);
    });
</script>
</body>
</html>
