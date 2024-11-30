<%@ page import="org.zerock.jdbcex.dto.ResumeDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>자기소개서 조회</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        .auth-links a {
            text-decoration: none;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 4px;
            color: #333;
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
        .sidebar ul li a {
            text-decoration: none;
            color: #333;
            font-size: 16px;
            display: block;
            padding: 10px 0;
        }
        .sidebar ul li a:hover {
            background-color: #c6c6c6;
        }
        .content {
            flex-grow: 1;
            padding-left: 20px;
        }
        .resume-list table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .resume-list th, .resume-list td {
            border: 1px solid #ddd;
            padding: 10px;
        }
        .resume-list th {
            background-color: #f0f0f0;
        }
        .resume-list tr:hover {
            background-color: #f9f9f9;
            cursor: pointer;
        }

        button {
            float: right;
            display: inline-block;
            padding: 10px 20px;
            font-size: 14px;
            font-weight: bold;
            color: white;
            background-color: #333; /* 어두운 회색 배경 */
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-align: center;
            margin-right: 10px; /* 버튼 간 간격 */
        }

        button:hover {
            background-color: #555; /* 호버 시 밝은 회색 */
        }

        button:active {
            background-color: #111; /* 클릭 시 더 어두운 회색 */
            transform: scale(0.98); /* 클릭 시 약간 눌린 효과 */
        }

    </style>

</head>

<body>

<jsp:include page="header.jsp"/>

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="resume.jsp">자기소개서 등록</a></li>
            <li><a href="resume_view">자기소개서 조회</a></li>
            <li><a href="resume_analyze.jsp">자기소개서 분석</a></li>
        </ul>
    </div>
    <div class="content">
        <h2>자기소개서 조회</h2>
        <div class="resume-list">
            <table>
                <thead>
                <tr>
                    <th>순번</th>
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
                <tr>
                    <td><%= index++ %></td> <!-- 순차 번호 표시 -->
                    <td style="display: none" name="resume-id"><%= resume.getId() %></td>
                    <td name="resume-title">
                        <%= resume.getTitle() %>
                        <button id="delete-resume-btn">삭제</button>
                        <button id="detail-resume-btn" onclick="viewDetail('<%= resume.getId() %>')">수정</button>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="2">등록된 자기소개서가 없습니다.</td>
                </tr>
                <% } %>
                </tbody>

            </table>
        </div>
    </div>
</div>

<script>
    function viewDetail(id) {
        window.location.href = '/resume_detail?id=' + id;
    }

    // DELETE 메서드를 호출하는 함수
    async function deleteResume(id) {
        try {
            const response = await fetch('/resume', {
                method: 'DELETE', // DELETE 메서드
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ // 삭제 요청에 필요한 데이터 (예: 단일 ID)
                    id: id // 선택한 ID 전달
                })
            });

            if (response.ok) {
                alert('삭제가 완료되었습니다.');
                location.reload(); // 페이지 새로고침
            } else {
                alert('삭제 중 문제가 발생했습니다.');
            }
        } catch (error) {
            console.error('Error:', error);
            alert('삭제 요청에 실패했습니다.');
        }
    }

    // 각 삭제 버튼에 이벤트 리스너 추가
    document.querySelectorAll("#delete-resume-btn").forEach(button => {
        button.addEventListener("click", function (event) {
            // 버튼 클릭 시 이벤트 전파 방지
            event.stopPropagation();

            // 버튼이 속한 행에서 ID를 가져옴
            const row = this.closest("tr");
            const id = row.querySelector("[name='resume-id']").textContent.trim();

            // 삭제 요청 호출
            if (confirm(`ID ${id} 자기소개서를 삭제하시겠습니까?`)) {
                deleteResume(id);
            }
        });
    });
</script>


</body>
</html>
