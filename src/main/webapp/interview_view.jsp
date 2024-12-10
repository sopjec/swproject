<%@ page import="org.zerock.jdbcex.dto.InterviewDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<jsp:include page="checkSession.jsp"/>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/layout.css"> <!-- 올바른 경로 설정 -->
    <title>면접 녹화 기록 조회</title>
    <style>
        h2 {
            color: #333;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            background-color: white;
        }

        table th,
        table td {
            border: 1px solid #ddd;
            padding: 15px;
            text-align: center;
        }

        table th {
            background-color: #333;
            color: white;
        }

        table tr:hover {
            background-color: #f2f2f2;
            cursor: pointer;
        }

        table tbody tr {
            height: 50px;
        }

        table tbody tr td {
            word-break: break-word;
        }

        /* 면접 기록이 없는 경우 메시지 스타일 */
        .no-records {
            text-align: center;
            font-size: 16px;
            color: #555;
            padding: 20px 0;
        }

        /* 비디오 컨테이너 */
        .video-container {
            display: none; /* 처음엔 숨김 */
            position: relative;
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 10px;
        }

        .video-container video {
            display: block;
            margin: 0 auto;
            max-width: 100%;
            height: auto;
        }

        /* 닫기 버튼 */
        .close-button {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: red;
            color: white;
            border: none;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            font-size: 18px;
            text-align: center;
            cursor: pointer;
        }
        .video-details {
            margin-top: 20px;
            text-align: left;
        }

        .video-details h3 {
            font-size: 20px;
            color: #333;
            margin-bottom: 10px;
        }

        .video-details p {
            font-size: 16px;
            color: #555;
        }
        .video-details p {
            font-size: 16px;
            color: #555;
            white-space: pre-wrap; /* 줄바꿈을 유지 */
        }

    </style>
</head>

<body>
<jsp:include page="header.jsp" />

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="#" onclick="checkSessionAndNavigate('/resume?action=interview'); return false;">면접 보러가기</a></li>
            <li><a href="#" onclick="checkSessionAndNavigate('interviewView'); return false;">면접 녹화기록 조회</a></li>
        </ul>
    </div>

    <div class="content">
        <h2>면접기록</h2>
        <table class="interviewTable">
            <thead>
            <tr>
                <th>순번</th>
                <th>제목</th>
                <th>날짜</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<InterviewDTO> interviews = (List<InterviewDTO>) request.getAttribute("interviewList");
                if (interviews != null && !interviews.isEmpty()) {
                    int index = 1; // 순번을 위한 변수
                    for (InterviewDTO interview : interviews) {
            %>
            <tr onclick="showVideo('<%= interview.getTitle() != null ? java.net.URLEncoder.encode(interview.getTitle(), "UTF-8") : "" %>', '<%= interview.getFeedback() != null ? java.net.URLEncoder.encode(interview.getFeedback(), "UTF-8") : "답변이 없어 피드백을 생성하지 못하였습니다. " %>', <%= interview.getResume_id() %>)">
                <td><%= index++ %></td>
                <td><%= interview.getTitle() != null ? interview.getTitle() : "제목 없음" %></td>
                <td><%= interview.getInterviewDate() != null ? interview.getInterviewDate() : "날짜 없음" %></td>
            </tr>



            <%
                }
            } else {
            %>
            <tr>
                <td colspan="3">
                    <div class="no-records">
                        <p>면접 기록이 없습니다.</p>
                        <p>
                            <a href="/resume?action=interview" style="text-decoration-line: none; font-size: 15px; color: #333;">면접 보러가기</a>
                        </p>
                    </div>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <!-- 비디오 컨테이너 -->
        <div class="video-container" id="video-container">
            <button class="close-button" onclick="hideVideo()">X</button>
            <video controls id="video-player">
                <source src="" type="video/webm">
                브라우저에서 동영상을 지원하지 않습니다.
            </video>
            <div class="video-details">
                <h3 id="video-title"></h3>
                <p id="video-feedback"></p>
                <p><a href="#" class="resume-link">면접 다시 보러가기</a></p>
            </div>
        </div>
    </div>
</div>
<script>
    function showVideo(encodedTitle, encodedFeedback, resumeId) {
        const table = document.querySelector(".interviewTable");
        const videoContainer = document.getElementById("video-container");
        const videoPlayer = document.getElementById("video-player");
        const videoTitle = document.getElementById("video-title");
        const videoFeedback = document.getElementById("video-feedback");

        // URL 디코딩
        const title = decodeURIComponent(encodedTitle).replace(/\+/g, " ");
        const feedback = decodeURIComponent(encodedFeedback).replace(/\+/g, " ").replace(/-/g, "\n").replace(/질문 \d+/g, "\n$&");

        // 테이블 숨기기
        table.style.display = "none";

        // 동영상 소스 설정 (서블릿 경로 사용)
        videoPlayer.src = "/videos/" + encodeURIComponent(title) + ".webm";

        // 제목과 피드백 설정
        videoTitle.textContent = title + "에 대한 피드백 내용";
        videoFeedback.textContent = feedback;

        // "면접 다시 보러가기" 링크 설정
        const link = document.querySelector(".video-details a");
        link.href = "/interview?resumeId=" + resumeId;

        // 비디오 컨테이너 표시
        videoContainer.style.display = "block";
    }

    function hideVideo() {
        const table = document.querySelector(".interviewTable");
        const videoContainer = document.getElementById("video-container");
        const videoPlayer = document.getElementById("video-player");
        const videoTitle = document.getElementById("video-title");
        const videoFeedback = document.getElementById("video-feedback");

        // 테이블 보이기
        table.style.display = "table";

        // 비디오 컨테이너 숨기기
        videoContainer.style.display = "none";

        // 동영상 소스 초기화
        videoPlayer.src = "";
        videoTitle.textContent = "";
        videoFeedback.textContent = "";
    }
</script>


</body>
</html>
