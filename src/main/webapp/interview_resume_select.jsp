<%@ page import="org.zerock.jdbcex.dto.ResumeDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<jsp:include page="checkSession.jsp"/>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/layout.css"> <!-- 올바른 경로 설정 -->
    <title>자기소개서 선택</title>

    <style>
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table th, table td {
            border: 1px solid #ddd;
            padding: 10px;
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

        .button-controls {
            margin-top: 20px;
            text-align: center;
        }

        button {
            padding: 10px 20px;
            background-color: #333;
            border: none;
            color: white;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background-color: #555;
        }

        .selected {
            background-color: #fffacd !important;
        }

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

        .modal-content button {
            background-color: #333;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            margin-top: 10px;
        }

        .modal-content button:hover {
            background-color: #555;
        }
    </style>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const modal = document.getElementById("login-modal");
            const startInterviewBtn = document.getElementById("start-interview");
            const resumeRows = document.querySelectorAll(".resume-list tbody tr");
            const hiddenInput = document.getElementById("selected-resume-id");
            const isLoggedIn = <%= session.getAttribute("loggedInUser") != null %>;

            let selectedResumeId = null;

            // 로그인 여부 확인
            if (!isLoggedIn) {
                modal.style.display = "block";
            }

            // 자기소개서 선택 이벤트
            resumeRows.forEach(row => {
                row.addEventListener("click", () => {
                    resumeRows.forEach(r => r.classList.remove("selected"));
                    row.classList.add("selected");
                    selectedResumeId = row.getAttribute("data-id");
                    hiddenInput.value = selectedResumeId; // hidden input에 선택된 ID 저장
                });
            });

            // 면접 시작 버튼 클릭 이벤트
            startInterviewBtn.addEventListener("click", () => {
                if (!selectedResumeId) {
                    alert("면접볼 자기소개서를 선택해주세요.");
                } else {
                    document.getElementById("resume-form").submit(); // form 제출
                }
            });
        });

        function redirectToLogin() {
            window.location.href = "login.jsp";
        }
    </script>
</head>

<body>

<jsp:include page="header.jsp"/>



<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="/resume?action=interview">면접 보기</a></li>
            <li><a href="interviewView">면접 기록 조회</a></li>
        </ul>
    </div>

    <div class="content">
        <h2>면접볼 자기소개서를 선택해주세요</h2>
        <form id="resume-form" action="/interview" method="GET">
            <input type="hidden" id="selected-resume-id" name="resumeId" value="">
            <table class="resume-list">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>제목</th>
                </tr>
                </thead>
                <tbody>
                <%
                    List<ResumeDTO> resumes = (List<ResumeDTO>) request.getAttribute("resumes");
                    if (resumes != null && !resumes.isEmpty()) {
                        int index = 1; // 순차적인 번호를 위한 변수
                        for (ResumeDTO resume : resumes) {
                %>
                <tr data-id="<%= resume.getId() %>">
                    <td><%= index++ %></td> <!-- 순차적인 번호 출력 -->
                    <td><%= resume.getTitle() %></td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                <tr>
                    <td colspan="3">
                        <div class="no-records">
                            <p>등록된 자기소개서가 없습니다.</p>
                            <p>
                                <a href="resume.jsp" style="text-decoration-line: none; font-size: 15px; color: #333;">자기소개서 등록하러가기</a>
                            </p>
                        </div>
                    </td>
                </tr>
                </tr>
                <%
                    }
                %>
                </tbody>
            </table>
            <div class="button-controls">
                <button type="button" id="start-interview">선택</button>
            </div>
        </form>
    </div>
</div>
<jsp:include page="checkSession.jsp"/>
</body>

</html>
