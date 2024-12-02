<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.zerock.jdbcex.dto.UserDTO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이 페이지</title>

    <style>
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
        .sidebar li:hover {
            background-color: #c6c6c6;
        }

        h2 {
            text-align: left;
        }

        .content {
            flex-grow: 1;
            padding-left: 20px;
        }
        /* 메인 프로필 이미지 스타일 */
        .profile-container {
            text-align: center;
            margin-top: 20px;
        }
        .profile-image {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            cursor: pointer;
            border: 2px solid #ddd;
            transition: border-color 0.3s ease;
        }
        .profile-image:hover {
            border-color: #000000;
        }
        /* 팝업 기본 스타일 */
        .popup {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5); /* 반투명한 검정 */
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .hidden {
            display: none;
        }
        /* 팝업 내부 컨텐츠 */
        .popup-content {
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            width: 300px;
        }
        .thumbnail-container {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin: 20px 0;
        }
        .thumbnail {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            cursor: pointer;
            border: 2px solid transparent;
            transition: border-color 0.3s ease;
            pointer-events: auto;
        }
        .thumbnail:hover {
            border-color: #343434;
        }
        .thumbnail.selected {
            border-color: #007BFF; /* 파란색 테두리 */
            transform: scale(1.1); /* 약간 확대 효과 */
        }

        button {
            background-color: #343434;
            color: white;
        }
        button:hover {
            background-color: #575757;
        }


        .authSection {
            max-width: 400px;
            padding: 20px;
            text-align: center;
            margin: 0 auto;
        }
        .authSection input[type="text"],
        .authSection input[type="password"] {
            height: 40px;
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }
        .authSection button {
            height: 50px;
            width: 50%;
            padding: 10px;
            background-color: #333;
            color: white;
            font-size: 16px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .authSection button:hover {
            background-color: #000;
        }

        #account-info span {
            font-size: 16px;
            color: #555;
        }
    </style>
</head>

<body>

<!-- 세션에서 loggedInUser 가져오기 -->
<%
    UserDTO loggedInUser = (UserDTO) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp"); // 로그인되지 않은 경우 로그인 페이지로 리디렉트
        return;
    }
    // 로그인된 사용자 정보 출력
    System.out.println("로그인된 사용자: " + loggedInUser.getId());
%>

<jsp:include page="header.jsp"/>

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="mypage.jsp">내계정</a></li>
            <li><a href="resume_view?action=view">자기소개서 조회</a></li>
            <li><a href=interview_view?action=interview_view">면접 녹화 기록 조회</a></li>
            <li><a href="jobScrap?action=jobScrap.jsp">저장된 공고 목록</a></li>
        </ul>
    </div>

    <div class="content">
        <h2>내계정</h2>
        <!-- 프로필 사진 및 업로드 -->
        <div class="profile-container">
            <img src="<%= loggedInUser.getProfileUrl() %>" alt="메인 프로필 이미지" id="mainProfileImage" class="profile-image" onclick="openImageSelector()">
        </div>
        <!-- 이미지 선택 팝업 (기본적으로 숨김 처리) -->
        <div id="imageSelectorPopup" class="popup hidden">
            <div class="popup-content">
                <h3>이미지를 선택하세요</h3>
                <div class="thumbnail-container">
                    <img src="/img/1.png" alt="Image 1" class="thumbnail" onclick="selectThumbnail(this, '/img/1.png')">
                    <img src="/img/2.png" alt="Image 2" class="thumbnail" onclick="selectThumbnail(this, '/img/2.png')">
                    <img src="/img/3.png" alt="Image 3" class="thumbnail" onclick="selectThumbnail(this, '/img/3.png')">
                    <img src="/img/4.png" alt="Image 4" class="thumbnail" onclick="selectThumbnail(this, '/img/4.png')">
                </div>
                <button id="applySelection">선택</button>
                <button type="button" onclick="closeImageSelector()">닫기</button>
            </div>
        </div>

        <div class="authSection">
            <input type="text" name="id" id="id" placeholder="아이디" value="<%= loggedInUser.getId() %>" required readonly/>
            <input type="password" name="password" class="password" placeholder="비밀번호" required/>
            <button type="submit" class="submit">저장</button>
            <p id="authError" style="color: red; display: none;">아이디 또는 비밀번호가 일치하지 않습니다.</p>
        </div>

    </div>
</div>

<script>
    let selectedImageUrl = '';

    function openImageSelector() {
        document.getElementById('imageSelectorPopup').classList.remove('hidden');
    }

    function closeImageSelector() {
        document.getElementById('imageSelectorPopup').classList.add('hidden');
    }

    // 썸네일 클릭 처리
    function selectThumbnail(element, imageUrl) {
        document.querySelectorAll('.thumbnail').forEach(img => img.classList.remove('selected'));
        element.classList.add('selected');
        selectedImageUrl = imageUrl; // 선택된 이미지 URL 저장
    }

    // "선택" 버튼 클릭 처리
    document.getElementById('applySelection').addEventListener('click', function () {
        if (selectedImageUrl) {
            console.log("선택한 이미지 URL:", selectedImageUrl); // 디버깅 로그

            // 서버로 선택된 이미지 URL 전송
            fetch('/updateProfileImage', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    imageUrl: selectedImageUrl, // 선택된 이미지 URL
                }),
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        // 성공 시 UI 업데이트
                        updateProfileImage(data.imageUrl);
                        document.getElementById('mainProfileImage').src = selectedImageUrl;
                        closeImageSelector();
                        alert('프로필 이미지가 성공적으로 업데이트되었습니다!');
                    } else {
                        alert('프로필 이미지 업데이트에 실패했습니다.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('서버 요청 중 오류가 발생했습니다.');
                });
        } else {
            alert('이미지를 선택해주세요!');
        }

        function updateProfileImage(imageUrl) {
            const profilePicElement = document.getElementById("header-profile-pic");
            if (profilePicElement) {
                profilePicElement.src = imageUrl + "?timestamp=" + new Date().getTime(); // 캐싱 방지
            }
        }

        function handleProfileUpdate() {
            const xhr = new XMLHttpRequest();
            xhr.open("POST", "/updateProfileImage", true);
            xhr.setRequestHeader("Content-Type", "application/json");

            const newImageUrl = "path/to/new/image.jpg"; // 사용자가 업로드한 이미지 경로
            xhr.onload = function () {
                if (xhr.status === 200) {
                    const response = JSON.parse(xhr.responseText);
                    if (response.success) {
                        // 서버 응답에서 새 이미지 URL 가져오기
                        const updatedImageUrl = response.imageUrl; // 서버가 반환한 이미지 URL
                        updateProfileImage(updatedImageUrl); // 헤더 이미지 업데이트
                    } else {
                        alert("프로필 이미지를 업데이트하지 못했습니다: " + response.message);
                    }
                }
            };

            // 서버에 데이터 전송
            xhr.send(JSON.stringify({ imageUrl: newImageUrl }));
        }

    });


</script>

</body>
</html>
