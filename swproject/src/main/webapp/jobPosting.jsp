<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>기업 채용 공고</title>
    <style>
        /* 기존 CSS 동일 */
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

        /* 검색창 및 필터 컨테이너 스타일 */
        .filters {
            display: flex;
            justify-content: space-between; /* 가로로 균등 배치 */
            align-items: center; /* 세로 중앙 정렬 */
            width: 100%; /* 전체 너비 */
            margin-bottom: 20px; /* 하단 여백 */
            gap: 10px; /* 필터 간 간격 */
        }

        /* 검색창 스타일 */
        #search-keyword {
            flex: 3; /* 가장 넓게 차지 */
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        /* 필터 드롭다운 스타일 */
        .filters select {
            flex: 1; /* 동일한 너비 */
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            background-color: #fff;
            appearance: none; /* 기본 화살표 제거 */
            cursor: pointer;
            text-align: center;
        }

        /* 필터 적용 버튼 스타일 */
        #apply-filters {
            flex: 1; /* 동일한 너비 */
            padding: 10px 15px;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            background-color: #007bff; /* 파란색 버튼 */
            color: white;
            cursor: pointer;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        /* 버튼 호버 효과 */
        #apply-filters:hover {
            background-color: #0056b3; /* 어두운 파란색 */
            transform: translateY(-2px); /* 약간 위로 올라가는 효과 */
        }


    </style>
</head>

<body>
<jsp:include page="header.jsp" />

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="jobPosting.jsp">기업 채용 공고</a></li>
            <li><a href="scrap">저장된 공고 목록</a></li>
        </ul>
    </div>

    <!-- 모달창 -->
    <div id="login-modal" class="modal">
        <div class="modal-content">
            <p>세션이 만료되었습니다.</p>
            <button class="close-btn" id="close-modal">닫기</button>
            <button class="login-btn" id="go-login">로그인 페이지로 이동</button>
        </div>
    </div>

    <div class="content">
        <div class="filters">
            <input type="text" id="search-keyword" placeholder="검색어 입력" />
            <select id="region-filter">
                <option value="">지역 선택</option>
                <option value="서울">서울</option>
                <option value="부산">부산</option>
                <option value="대구">대구</option>
                <option value="인천">인천</option>
                <option value="광주">광주</option>
                <option value="대전">대전</option>
                <option value="울산">울산</option>
                <option value="세종">세종</option>
                <option value="경기">경기</option>
                <option value="강원">강원</option>
                <option value="충북">충북</option>
                <option value="충남">충남</option>
                <option value="전북">전북</option>
                <option value="전남">전남</option>
                <option value="경북">경북</option>
                <option value="경남">경남</option>
                <option value="제주">제주</option>
            </select>
            <select id="employment-type-filter">
                <option value="">고용 형태 선택</option>
                <option value="인턴">인턴</option>
                <option value="정규직">정규직</option>
                <option value="비정규직">비정규직</option>
                <option value="무기계약직">무기계약직</option>
            </select>
            <select id="job-type-filter">
                <option value="">직무 선택</option>
                <option value="경영.회계.사무">경영.회계.사무</option>
                <option value="경비">경비</option>
                <option value="청소">청소</option>
                <option value="교육.자연.사회과학">교육.자연.사회과학</option>
                <option value="보건">보건</option>
                <option value="의료">의료</option>
                <option value="음식서비스">음식서비스</option>
                <option value="정보통신">정보통신</option>
                <option value="운전">운전</option>
                <option value="운송">운송</option>
                <option value="사회복지">사회복지</option>
                <option value="종교">종교</option>
                <option value="에너지">에너지</option>
                <option value="안전">안전</option>
            </select>
            <button id="apply-filters">필터 적용</button>
        </div>
        <div class="job-listing"></div>
        <div class="pagination"></div>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        let currentPage = 1; // 현재 페이지
        const itemsPerPage = 9; // 한 페이지에 표시할 공고 수
        const maxVisiblePages = 5; // 페이지네이션에서 표시할 최대 페이지 버튼 수
        let totalItems = 0; // 전체 공고 수
        let allItems = []; // 전체 데이터를 저장할 배열
        let filteredItems = []; // 필터링된 데이터를 저장할 배열

        const modal = document.getElementById("login-modal");
        const closeModal = document.getElementById("close-modal");
        const goLogin = document.getElementById("go-login");

        closeModal.addEventListener("click", () => modal.style.display = "none");
        goLogin.addEventListener("click", () => window.location.href = "login.jsp");

        // 전체 데이터 가져오기
        function fetchAllJobPostings() {
            const serviceKey = "m4%2BOenhwqExP36CL%2F5Pb7tiHlIxAqX75ReTHzMfWzxb%2BpEYUtedtI%2BughHYGWfH%2FXXFk3sIWKu3HIhtbYDQozw%3D%3D";
            const url = "http://apis.data.go.kr/1051000/recruitment/list?serviceKey=" + serviceKey + "&resultType=json&numOfRows=1000&pageNo=1&ongoingYn=Y"; // 최대 1000개 불러오기

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.result && Array.isArray(data.result)) {
                        allItems = data.result;
                        filteredItems = [...allItems]; // 필터링 초기화
                        totalItems = filteredItems.length;
                        createPagination();
                        showItems(currentPage);
                    } else {
                        console.error("데이터를 가져올 수 없습니다.");
                    }
                })
                .catch(error => console.error("API 호출 실패:", error));
        }

        // 클라이언트 측 필터링
        function applyFilters() {
            const keyword = document.getElementById("search-keyword").value.trim();
            const region = document.getElementById("region-filter").value.trim();
            const employmentType = document.getElementById("employment-type-filter").value.trim();
            const jobType = document.getElementById("job-type-filter").value.trim();

            filteredItems = allItems.filter(item => {
                const matchesKeyword = !keyword || (item.instNm && item.instNm.includes(keyword));
                const matchesRegion = !region || (item.workRgnNmLst && item.workRgnNmLst.includes(region));
                const matchesEmploymentType = !employmentType || (item.hireTypeNmLst && item.hireTypeNmLst.includes(employmentType));
                const matchesJobType = !jobType || (item.ncsCdNmLst && item.ncsCdNmLst.includes(jobType));
                return matchesKeyword && matchesRegion && matchesEmploymentType && matchesJobType;
            });

            totalItems = filteredItems.length;
            currentPage = 1; // 필터 적용 시 첫 페이지로 초기화
            createPagination();
            showItems(currentPage);
        }

        // 페이지네이션 생성
        function createPagination() {
            const paginationContainer = document.querySelector(".pagination");
            paginationContainer.innerHTML = "";

            const totalPages = Math.ceil(totalItems / itemsPerPage);

            // 이전 버튼
            const prevButton = document.createElement("button");
            prevButton.textContent = "이전";
            prevButton.disabled = currentPage === 1;
            prevButton.addEventListener("click", function () {
                if (currentPage > 1) {
                    currentPage--;
                    showItems(currentPage);
                    createPagination();
                }
            });
            paginationContainer.appendChild(prevButton);

            // 동적으로 페이지 번호 생성
            const startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
            const endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);

            for (let i = startPage; i <= endPage; i++) {
                const button = document.createElement("button");
                button.textContent = i;
                if (i === currentPage) {
                    button.classList.add("active");
                }
                button.addEventListener("click", function () {
                    currentPage = i;
                    showItems(currentPage);
                    createPagination();
                });
                paginationContainer.appendChild(button);
            }

            // 다음 버튼
            const nextButton = document.createElement("button");
            nextButton.textContent = "다음";
            nextButton.disabled = currentPage === totalPages;
            nextButton.addEventListener("click", function () {
                if (currentPage < totalPages) {
                    currentPage++;
                    showItems(currentPage);
                    createPagination();
                }
            });
            paginationContainer.appendChild(nextButton);
        }

        // 특정 페이지의 데이터 보여주기
        function showItems(page) {
            const jobListingContainer = document.querySelector(".job-listing");
            jobListingContainer.innerHTML = "";

            const startIndex = (page - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const itemsToShow = filteredItems.slice(startIndex, endIndex);

            if (itemsToShow.length > 0) {
                // 스크랩된 항목의 ID를 서버에서 가져옴
                fetch("/scrapStatus")
                    .then(response => response.json())
                    .then(scrapStatus => {
                        itemsToShow.forEach(item => {
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

                            // 스크랩 버튼
                            const scrapButton = document.createElement("button");
                            scrapButton.classList.add("scrap-button");
                            scrapButton.dataset.scrapKey = item.recrutPblntSn;

                            // 스크랩 상태에 따라 별표 설정
                            const isScraped = scrapStatus.includes(item.recrutPblntSn);
                            scrapButton.textContent = isScraped ? "⭐" : "☆";

                            scrapButton.addEventListener("click", function () {
                                const scrapKey = scrapButton.dataset.scrapKey;

                                if (scrapButton.textContent === "☆") {
                                    // 스크랩 추가
                                    fetch("/scrap", {
                                        method: "POST",
                                        headers: { "Content-Type": "application/json" },
                                        body: JSON.stringify(scrapKey)
                                    })
                                        .then(response => {
                                            if (!response.ok) throw new Error("스크랩 실패");
                                            return response.text();
                                        })
                                        .then(data => {
                                            if (data) {
                                                scrapButton.textContent = "⭐"; // 채워진 별표로 변경
                                                alert("스크랩이 추가되었습니다.");
                                            }
                                        })
                                        .catch(error => console.error("스크랩 요청 실패:", error));
                                } else {
                                    // 스크랩 삭제
                                    fetch("/scrap", {
                                        method: "DELETE",
                                        headers: { "Content-Type": "application/json" },
                                        body: JSON.stringify(scrapKey)
                                    })
                                        .then(response => {
                                            if (!response.ok) throw new Error("스크랩 삭제 실패");
                                            return response.text();
                                        })
                                        .then(data => {
                                            if (data) {
                                                scrapButton.textContent = "☆"; // 빈 별표로 변경
                                                alert("스크랩이 삭제되었습니다.");
                                            }
                                        })
                                        .catch(error => console.error("스크랩 삭제 요청 실패:", error));
                                }
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
                    })
                    .catch(error => console.error("스크랩 상태 가져오기 실패:", error));
            } else {
                jobListingContainer.innerHTML = "<p>조건에 맞는 공고가 없습니다.</p>";
            }

        }

        // 초기 데이터 가져오기
        fetchAllJobPostings();

        // 필터 적용 버튼 이벤트
        document.getElementById("apply-filters").addEventListener("click", applyFilters);
    });

</script>
</body>
</html>
