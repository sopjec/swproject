<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/layout.css"> <!-- 올바른 경로 설정 -->
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 10px;
            text-align: left;
        }

        td:first-child {
            border-right: 1px solid #ddd; /* 칸 사이 구분선 */
            padding-right: 10px;
        }

        input[type="text"], textarea, select {
            width: 95%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            background-color: #fff;
            color: #333;
        }

        textarea {
            height: 150px; /* 면접 내용 입력란 크기 */
            resize: none; /* 크기 조정 비활성화 */
        }

        .register-button {
            padding: 10px 15px;
            border: 1px solid black;
            background-color: white;
            color: black;
            cursor: pointer;
            font-weight: bold;
            border-radius: 4px;
            margin-top: 20px;
        }
        .register-button:hover {
            background-color: #f0f0f0;
        }
    </style>
</head>

<body>

<jsp:include page="header.jsp"/>

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="#" onclick="checkSessionAndNavigate('reviewUpload'); return false;">기업 면접 후기</a></li>
        </ul>
    </div>

    <!-- 메인 컨텐츠 -->
    <div class="content">
        <h2>면접 후기 등록</h2>

        <h3>기본 정보 입력</h3>

        <form action="reviewUpload" method="POST"> <!-- Servlet의 URL 매핑 -->
            <table>
                <tbody>
                <tr>
                    <td>기업명</td>
                    <td><input type="text" name="comname" placeholder="기업명" required></td>
                </tr>
                <tr>
                    <td>직무 분야</td>
                    <td>
                        <select name="job" required>
                            <option value="직업선택">분야선택</option>
                            <option value="IT개발">IT개발</option>
                            <option value="마케팅·홍보">마케팅·홍보</option>
                            <option value="기획·전략">기획·전략</option>
                            <option value="디자인">디자인</option>
                            <option value="회계·세무·재무">회계·세무·재무</option>
                            <option value="서비스">서비스</option>
                            <option value="건설·건축">건설·건축</option>
                            <option value="생산">생산</option>
                            <option value="기타">기타</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>면접 당시 경력</td>
                    <td>
                        <select name="experience" required>
                            <option value="경력선택">경력선택</option>
                            <option value="신입">신입</option>
                            <option value="인턴">인턴</option>
                            <option value="경력">경력</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>지역</td>
                    <td>
                        <select name="region" required>
                            <option value="지역">지역선택</option>
                            <option value="서울">서울</option>
                            <option value="경기도">경기도</option>
                            <option value="강원도">강원도</option>
                            <option value="충청북도">충청북도</option>
                            <option value="충청남도">충청남도</option>
                            <option value="전라북도">전라북도</option>
                            <option value="전라남도">전라남도</option>
                            <option value="경상북도">경상북도</option>
                            <option value="경상남도">경상남도</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td>면접 내용</td>
                    <td><textarea name="content" placeholder="면접 내용을 입력하세요" required></textarea></td>
                </tr>
                </tbody>
            </table>
            <button type="submit" class="register-button">등록하기</button>
        </form>
    </div>
</div>
</body>
</html>
