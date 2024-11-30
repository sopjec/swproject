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

        .resume-list {
            margin-top: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: white;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }

        .resume-list table {
            width: 100%;
            border-collapse: collapse;
        }

        .resume-list th, .resume-list td {
            border: 1px solid #ddd;
            padding: 12px 16px;
            text-align: center;
            vertical-align: middle; /* 세로 정렬 */
        }

        .resume-list th {
            background-color: #f4f4f4;
            font-size: 16px;
            color: #333;
            font-weight: bold;
        }

        .resume-list td {
            align-items: center; /* Y축 가운데 정렬 */
            justify-content: space-between; /* 제목과 버튼 간격 조정 */
            padding: 12px 16px; /* 여백 유지 */
        }

        .resume-list td span {
            font-size: 18px; /* 제목 글자 크기 */
            font-weight: bold; /* 제목을 굵게 표시 */
        }

        .resume-list td button {
            margin-left: 10px; /* 버튼과 제목 간격 */
            float: right;
            padding: 6px 10px;
            font-size: 14px;
            font-weight: bold;
            color: white;
            background-color: #333; /* 검정색 버튼 */
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .resume-list td button.delete {
            background-color: #dc3545; /* 삭제 버튼 빨간색 */
        }

        .resume-list td button:hover {
            background-color: #555; /* 호버 시 연한 회색 */
        }

        .resume-list td button.delete:hover {
            background-color: #b02a37; /* 삭제 버튼 호버 시 */
        }

        .resume-list tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        .resume-list tr:hover {
            background-color: #f1f1f1;
            cursor: pointer;
        }

        .resume-list .index-column {
            width: 50px; /* 순번 칸을 정사각형으로 설정 */
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
                    <th class="index-column">순번</th>
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
                    <td class="index-column"><%= index++ %></td>
                    <td>
                            <span><%= resume.getTitle() %></span>
                                <button class="delete" onclick="deleteResume('<%= resume.getId() %>')">삭제</button>
                                <button onclick="viewDetail('<%= resume.getId() %>')">수정</button>
                    </td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="2" style="text-align: center; color: #999;">등록된 자기소개서가 없습니다.</td>
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
