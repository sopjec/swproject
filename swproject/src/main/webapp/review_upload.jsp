<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>면접 후기 등록하기</title> <!--기업분석_면접후기-->
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        
        /* 메인 레이아웃 설정 */
        .container {
            display: flex;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
        }
        /* 왼쪽 사이드바 스타일 */
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




        /* 오른쪽 메인 컨텐츠 */
        .content {
            flex-grow: 1;
            padding-left: 20px;
        }

        input[type="companyname"], input[type="text"] {
            width: 95%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 16px;
            background-color: #fff;
            color: #333;
        }
        input[type="text"]{
            height: 300px;
            vertical-align: top;
        }




        .search-bar {
            display: flex;
            margin-bottom: 20px;
        }
        .search-bar input {
            flex-grow: 1;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .search-bar button {
            padding: 10px 20px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #333;
            color: white;
            cursor: pointer;
            margin-left: 10px;
        }
        .search-bar button:hover {
            background-color: #000;
        }

        .filters {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .filters select {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        /* 테이블과 등록하기 버튼을 포함한 컨테이너 */
        .table-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .register-button {
            padding: 10px 15px;
            border: 1px solid black;
            background-color: white;
            color: black;
            cursor: pointer;
            font-weight: bold;
            border-radius: 4px;
        }
        .register-button:hover {
            background-color: #f0f0f0;
        }
        /* 테이블 스타일 */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }


        .pagination {
            text-align: center;
            margin-top: 20px;
        }
        .pagination a {
            padding: 10px 15px;
            margin: 0 5px;
            border: 1px solid #ddd;
            border-radius: 4px;
            color: #333;
            text-decoration: none;
        }
        .pagination a:hover {
            background-color: #ddd;
        }
    </style>

</head>

<body>

<jsp:include page="header.jsp"/>

    <div class="container">
        <div class="sidebar">
            <ul>
                <li><a href="review.jsp">기업 면접 후기</a></li>
            </ul>
        </div>

        
        <!-- 메인 컨텐츠 -->
        <div class="content">
            <h2>면접 후기 등록</h2>
            &nbsp;
            <h3>기본 정보 입력</h3>

            <table>
                <thead></thead>
                <tbody>
                    <tr>
                        <td width ="150">기업명</td>
                        <td><input type="companyname" name="companyname" id="input-company-name" placeholder="회사명" required></td>
                    </tr>
                    <tr>
                        <td>직무직업</td>
                        <td>
                            <select>                                
                                <option value="업종">직무·직업 전체</option>
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
                            <select>
                                <option value="신입">신입</option>
                                <option value="경력">경력</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td>지역</td>
                        <td>
                            <select>
                                <option value="지역">지역</option>
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
                </tbody>
            </table>
            
            <h3>면접 내용 입력</h3>
           
            <form action="/submit" method="post">
            <input type="text" name="interview-review" id="input-interview-review" placeholder="면접 내용 입력" required>
            </form>
            <button class="register-button">등록하기</button>


        </div>
    </div>
</body>
</html>
