<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/layout.css"> <!-- 올바른 경로 설정 -->
    <title>스크랩된 채용 공고</title>
    <style>

        .job-listing {
            display: grid;
            grid-template-columns: repeat(3, 1fr); /* 3열 구성 */
            gap: 20px;
            margin-top: 20px;
        }

        .job-card {
            position: relative; /* 상대 위치로 설정 */
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

        /* 삭제 버튼 (x) 스타일 */
        .delete-button {
            position: absolute; /* 절대 위치로 설정 */
            top: 10px; /* 상단에서 10px */
            right: 10px; /* 오른쪽에서 10px */
            background-color: #ff6b6b; /* 빨간색 배경 */
            color: white; /* 흰색 텍스트 */
            border: none;
            border-radius: 50%; /* 동그랗게 */
            width: 30px;
            height: 30px;
            font-size: 16px;
            cursor: pointer;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.1);
            transition: background-color 0.3s ease, transform 0.2s ease;
        }

        .delete-button:hover {
            background-color: #e84141; /* hover 시 더 어두운 빨간색 */
            transform: scale(1.1); /* 살짝 커짐 */
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
            <li><a href="jobScrap.jsp">저장된 공고 목록</a></li>
        </ul>
    </div>
    <div class="content">
        <!-- 필터 UI -->
        <div class="filters">
            <input type="text" id="search-keyword" value="${param.keyword != null ? param.keyword : ''}" placeholder="검색어 입력" />
            <select id="region-filter">
                <option value="" ${param.region == null || param.region == '' ? 'selected' : ''}>지역 선택</option>
                <option value="서울" ${param.region == '서울' ? 'selected' : ''}>서울</option>
                <option value="부산" ${param.region == '부산' ? 'selected' : ''}>부산</option>
                <option value="대구" ${param.region == '대구' ? 'selected' : ''}>대구</option>
                <option value="인천" ${param.region == '인천' ? 'selected' : ''}>인천</option>
                <option value="광주" ${param.region == '광주' ? 'selected' : ''}>광주</option>
                <option value="대전" ${param.region == '대전' ? 'selected' : ''}>대전</option>
                <option value="울산" ${param.region == '울산' ? 'selected' : ''}>울산</option>
                <option value="세종" ${param.region == '세종' ? 'selected' : ''}>세종</option>
                <option value="경기" ${param.region == '경기' ? 'selected' : ''}>경기</option>
                <option value="강원" ${param.region == '강원' ? 'selected' : ''}>강원</option>
                <option value="충북" ${param.region == '충북' ? 'selected' : ''}>충북</option>
                <option value="충남" ${param.region == '충남' ? 'selected' : ''}>충남</option>
                <option value="전북" ${param.region == '전북' ? 'selected' : ''}>전북</option>
                <option value="전남" ${param.region == '전남' ? 'selected' : ''}>전남</option>
                <option value="경북" ${param.region == '경북' ? 'selected' : ''}>경북</option>
                <option value="경남" ${param.region == '경남' ? 'selected' : ''}>경남</option>
                <option value="제주" ${param.region == '제주' ? 'selected' : ''}>제주</option>
            </select>

            <select id="employment-type-filter">
                <option value="" ${param.employmentType == null || param.employmentType == '' ? 'selected' : ''}>고용 형태 선택</option>
                <option value="인턴" ${param.employmentType == '인턴' ? 'selected' : ''}>인턴</option>
                <option value="정규직" ${param.employmentType == '정규직' ? 'selected' : ''}>정규직</option>
                <option value="비정규직" ${param.employmentType == '비정규직' ? 'selected' : ''}>비정규직</option>
                <option value="무기계약직" ${param.employmentType == '무기계약직' ? 'selected' : ''}>무기계약직</option>
            </select>

            <select id="job-type-filter">
                <option value="" ${param.jobType == null || param.jobType == '' ? 'selected' : ''}>직무 선택</option>
                <option value="경영.회계.사무" ${param.jobType == '경영.회계.사무' ? 'selected' : ''}>경영.회계.사무</option>
                <option value="경비" ${param.jobType == '경비' ? 'selected' : ''}>경비</option>
                <option value="청소" ${param.jobType == '청소' ? 'selected' : ''}>청소</option>
                <option value="교육.자연.사회과학" ${param.jobType == '교육.자연.사회과학' ? 'selected' : ''}>교육.자연.사회과학</option>
                <option value="보건" ${param.jobType == '보건' ? 'selected' : ''}>보건</option>
                <option value="의료" ${param.jobType == '의료' ? 'selected' : ''}>의료</option>
                <option value="음식서비스" ${param.jobType == '음식서비스' ? 'selected' : ''}>음식서비스</option>
                <option value="정보통신" ${param.jobType == '정보통신' ? 'selected' : ''}>정보통신</option>
                <option value="운전" ${param.jobType == '운전' ? 'selected' : ''}>운전</option>
                <option value="운송" ${param.jobType == '운송' ? 'selected' : ''}>운송</option>
                <option value="사회복지" ${param.jobType == '사회복지' ? 'selected' : ''}>사회복지</option>
                <option value="종교" ${param.jobType == '종교' ? 'selected' : ''}>종교</option>
                <option value="에너지" ${param.jobType == '에너지' ? 'selected' : ''}>에너지</option>
                <option value="안전" ${param.jobType == '안전' ? 'selected' : ''}>안전</option>
            </select>
            <button id="apply-filters">필터 적용</button>
        </div>

        <div class="job-listing">
            <c:choose>
                <c:when test="${empty jobData}">
                    <p style="text-align: center; color: #666; font-size: 16px; margin-top: 20px;">
                        스크랩된 채용공고가 없습니다.
                    </p>
                </c:when>
                <c:otherwise>
                    <c:forEach var="job" items="${jobData}">
                        <div class="job-card">
                            <p style="display: none">${job.scrapKey}</p>
                            <h2>${job.title}</h2>
                            <p>직무: ${job.duty}</p>
                            <p>고용 형태: ${job.employmentType}</p>
                            <p>근무 지역: ${job.region}</p>
                            <p>마감일: ${job.deadline}</p>
                            <a href="${job.url}" target="_blank">공고 보러가기</a>
                            <button class="delete-button" onclick="deleteScrap('${job.scrapKey}')">x</button>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="pagination">
            <c:forEach var="page" begin="1" end="${totalPages}">
                <button
                        data-page="${page}"
                        class="${page == currentPage ? 'active' : ''}">
                        ${page}
                </button>
            </c:forEach>
        </div>

    </div>
</div>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const paginationButtons = document.querySelectorAll(".pagination button");
        // 필터 적용 버튼 클릭 이벤트
        const applyFilters = document.getElementById("apply-filters");

        paginationButtons.forEach(button => {
            button.addEventListener("click", function () {
                const selectedPage = this.getAttribute("data-page");
                const queryParams = new URLSearchParams(window.location.search);

                queryParams.set("page", selectedPage);

                const baseUrl = "/scrap";
                window.location.href = baseUrl + "?" + queryParams.toString();
            });
        });



        applyFilters.addEventListener("click", function () {
            const keyword = document.getElementById("search-keyword").value.trim();
            const region = document.getElementById("region-filter").value;
            const employmentType = document.getElementById("employment-type-filter").value;
            const jobType = document.getElementById("job-type-filter").value;

            // 쿼리 매개변수 생성
            const queryParams = new URLSearchParams();
            if (keyword) queryParams.append("keyword", keyword);
            if (region) queryParams.append("region", region);
            if (employmentType) queryParams.append("employmentType", employmentType);
            if (jobType) queryParams.append("jobType", jobType);

            // 페이지 리다이렉트
            const baseUrl = "/scrap";
            window.location.href = baseUrl + "?" + queryParams.toString();
        });

    });

    // 스크랩 삭제 함수 (글로벌 범위)
    function deleteScrap(scrapKey) {
        if (!confirm("해당 스크랩을 삭제하시겠습니까?")) {
            return;
        }

        fetch("/scrap", {
            method: "DELETE",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(scrapKey)
        })
            .then(response => {
                if (response.ok) {
                    alert("스크랩이 삭제되었습니다.");
                    location.reload(); // 페이지를 새로고침하여 목록 갱신
                } else {
                    return response.text().then(text => { throw new Error(text); });
                }
            })
            .catch(error => {
                alert("스크랩 삭제 중 오류가 발생했습니다: " + error.message);
            });
    }
</script>

</body>
</html>
