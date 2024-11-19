<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Interview Platform</title>
    <style>
        .container {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-top: 180px;
            width: 100%;
            padding: 0 0;
            height: 100%;
            box-sizing: border-box;
        }
        /* 퀵메뉴 기본 스타일 */

        .quick-menu-item {
            text-align: center;
            font-size: 18px;
            padding: 20px;
            transition: background-color 0.3s ease, font-size 0.3s ease, width 0.3s ease;
            display: inline-block;
            position: relative;
            width: 24%;
            /* 각 항목의 너비를 24%로 설정하여 4개가 꽉 차도록 */
            height: 400px;
            /* 기본 배경색 */
        }
        /* 마우스를 올렸을 때 해당 영역만 배경색이 변함 */

        .quick-menu-item:hover {
            background: linear-gradient(to bottom, rgba(27, 27, 27, 0.1), rgba(97, 73, 93, 0.7), rgba(27, 27, 27, 0.1));
            font-size: 18px;
            color: white;
            width: 26%;
            /* hover 시 약간 더 넓게 */
        }

        .quick-menu-item a {
            color: white;
            text-decoration: none;
            transition: color 0.3s;
        }
        /* 항목들 사이에 흰색 선을 추가 */

        .quick-menu-item:not(:last-child)::after {
            content: '';
            position: absolute;
            right: 0;
            top: 0;
            height: 100%;
            width: 1px;
            background-color: white;
        }

        .sub-menu {
            list-style-type: none;
            padding-left: 0;
            margin-top: 10px;
        }

        .sub-menu a {
            color: white;
            text-decoration: none;
        }

        .sub-menu a:hover {
            font-size: 28px;
            color: rgb(228, 123, 141);
        }
        /* 구분선을 하단에도 넣어서 끊김 방지 */

        .menu {
            list-style-type: none;
            padding: 0;
        }

        .menu li {
            margin: 10px 0;
        }

        .menu li:hover {
            cursor: pointer;
        }
    </style>
</head>

<body>

<div id="header"></div>

<div class="container">
    <div class="quick-menu-item">
        <h1>자기소개서</h1>
        <br>
        <ul class="sub-menu">
            <a href="resume.jsp">
                <li>자기소개서 등록</li>
            </a>
            <br>
            <a href="resume_view.jsp">
                <li>자기소개서 조회</li>
            </a>
        </ul>
    </div>
    <div class="quick-menu-item">
        <h1>면접보기</h1>
        <br>
        <ul class="sub-menu">
            <a href="interview.jsp">
                <li>면접 보러 가기</li>
            </a>
            <br>
            <a href="interview.jsp">
                <li>면접 기록 조회</li>
            </a>
        </ul>
    </div>

    <div class="quick-menu-item">
        <h1>채용공고</h1>
        <br>
        <ul class="sub-menu">
            <a href="jobPosting.jsp">
                <li>공고 보러가기</li>
            </a>
        </ul>
    </div>

    <div class="quick-menu-item">
        <h1>기업분석</h1>
        <br>
        <ul class="sub-menu">
            <a href="resume.jsp">
                <li>면접 후기</li>
            </a>
            <br>
            <a href="resume.jsp">
                <li>기출 질문</li>
            </a>
        </ul>
    </div>
</div>


<script>
    // header.html 파일을 불러와서 #header div에 삽입
    fetch('header.jsp')
        .then(response => response.text())
        .then(data => {
            document.getElementById('header').innerHTML = data;
        });

</script>

</body>

</html>