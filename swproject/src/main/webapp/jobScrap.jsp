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
            padding: 20px;
        }
        .job-card {
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background-color: #fff;
            display: flex;
            justify-content: space-between;
        }
        .job-card div {
            max-width: 80%;
        }
        .delete-button {
            background-color: #ff4d4d;
            color: white;
            border: none;
            padding: 8px 15px;
            border-radius: 4px;
            cursor: pointer;
        }
        .delete-button:hover {
            background-color: #cc0000;
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

<h1>저장된 채용 공고 목록</h1>
<div id="scrap-container">
    <p>공고를 불러오는 중입니다...</p>
</div>

<!-- 모달창 HTML -->
<div id="login-modal" class="modal">
    <div class="modal-content">
        <p>로그인이 필요합니다.</p>
        <button class="login-btn" id="go-login">로그인 페이지로 이동</button>
    </div>
</div>

<script>
    const modal = document.getElementById("login-modal");
    const closeModal = document.getElementById("close-modal");
    const goLogin = document.getElementById("go-login");

    // 모달창 닫기
    closeModal.addEventListener("click", () => {
        modal.style.display = "none";
    });

    // 로그인 페이지로 이동
    goLogin.addEventListener("click", () => {
        window.location.href = "/login.jsp";
    });

    async function loadScrapList() {
        try {
            const response = await fetch('/scrap');
            if (response.status === 401) {
                // 로그인 필요 시 처리
                alert('로그인이 필요합니다.');
                return;
            }
            if (!response.ok) throw new Error('Failed to fetch scrap list');
            const scrapList = await response.json();

            const container = document.getElementById('scrap-container');
            container.innerHTML = '';

            if (scrapList.length === 0) {
                container.innerHTML = '<p>스크랩된 공고가 없습니다.</p>';
                return;
            }

            scrapList.forEach(item => {
                const jobCard = document.createElement('div');
                jobCard.className = 'job-card';
                jobCard.innerHTML = `
                <div>
                    <h3>${item.instNm || '기관명 없음'}</h3>
                    <p>직무: ${item.ncsCdNmLst || '정보 없음'}</p>
                    <p>고용 형태: ${item.hireTypeNmLst || '정보 없음'}</p>
                    <p>근무 지역: ${item.workRgnNmLst || '정보 없음'}</p>
                    <p>마감일: ${item.pbancEndYmd || '정보 없음'}</p>
                    <a href="${item.srcUrl || '#'}" target="_blank">공고 보러가기</a>
                </div>
            `;
                container.appendChild(jobCard);
            });
        } catch (error) {
            console.error('Error loading scrap list:', error);
        }
    }


    async function deleteScrap(scrapKey) {
        try {
            const response = await fetch('/scrap', {
                method: 'DELETE',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ scrapKey }),
            });
            if (response.status === 401) {
                // 로그인 필요 시 모달창 띄우기
                modal.style.display = "block";
                return;
            }
            if (!response.ok) throw new Error('Failed to delete scrap');
            alert('스크랩이 삭제되었습니다.');
            loadScrapList();
        } catch (error) {
            console.error('Error deleting scrap:', error);
        }
    }

    loadScrapList();
</script>
</body>
</html>
