<%@ page import="org.zerock.jdbcex.dto.ResumeQnaDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/layout.css"> <!-- 올바른 경로 설정 -->
    <title>자기소개서 세부 정보</title>
    <style>
        .resume-container {
            width: 100%;
            margin: 0;
            padding: 20px;
            max-width: 800px;
            background-color: white;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .title-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .question-box {
            margin-bottom: 15px;
        }
        .question {
            font-weight: bold;
            color: #333;
        }
        .answer {
            margin-top: 5px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            background-color: #f9f9f9;
        }
        .edit-button, .save-button {
            padding: 8px 15px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .edit-button:hover, .save-button:hover {
            background-color: black;
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

    <div class="resume-container">
        <div class="title-row">
            <h2 id="resumeTitle" contenteditable="false"><%= request.getAttribute("title") %></h2>
            <button class="edit-button" onclick="enableEditingAll()">전체 수정하기</button>
        </div>
        <hr>
        <% List<ResumeQnaDTO> qnaList = (List<ResumeQnaDTO>) request.getAttribute("qnaList"); %>
        <% if (qnaList != null) {
            for (ResumeQnaDTO qna : qnaList) { %>
        <div class="question-box">
            <p class="question">질문: <%= qna.getQuestion() %></p>
            <div class="answer-box">
                <p class="answer" contenteditable="false" id="answer-<%= qna.getId() %>">답변: <%= qna.getAnswer() %></p>
                <button class="edit-button" onclick="enableEditing('<%= qna.getId() %>')">수정하기</button>
            </div>
        </div>
        <% } } else { %>
        <p>질문과 답변이 없습니다.</p>
        <% } %>
    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        // 개별 항목 수정 활성화
        window.enableEditing = function (id) {
            const answerElement = document.getElementById("answer-" + id);

            if (!answerElement) {
                console.error("답변 요소를 찾을 수 없습니다: answer-" + id);
                return;
            }

            answerElement.contentEditable = true;
            answerElement.focus();

            const button = document.querySelector("button[onclick=\"enableEditing('" + id + "')\"]");
            if (button) {
                button.innerText = "저장하기";
                button.setAttribute("onclick", "saveAnswer('" + id + "')");
            } else {
                console.error("수정 버튼을 찾을 수 없습니다: enableEditing('" + id + "')");
            }
        };

        // 개별 항목 저장
        window.saveAnswer = async function (id) {
            const answerElement = document.getElementById("answer-" + id);

            if (!answerElement) {
                console.error("답변 요소를 찾을 수 없습니다: answer-" + id);
                return;
            }

            const newAnswer = answerElement.textContent.trim();

            try {
                const response = await fetch("/updateAnswer", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ id: id, answer: newAnswer })
                });

                if (response.ok) {
                    alert("답변이 저장되었습니다.");
                    answerElement.contentEditable = false;

                    const button = document.querySelector("button[onclick=\"saveAnswer('" + id + "')\"]");
                    if (button) {
                        button.innerText = "수정하기";
                        button.setAttribute("onclick", "enableEditing('" + id + "')");
                    }
                } else {
                    alert("저장 중 문제가 발생했습니다.");
                }
            } catch (error) {
                console.error("Error:", error);
                alert("저장 요청에 실패했습니다.");
            }
        };

        // 전체 수정 활성화
        window.enableEditingAll = function () {
            document.querySelectorAll(".answer").forEach(function (answer) {
                answer.contentEditable = true;
            });

            const titleElement = document.getElementById("resumeTitle");
            if (titleElement) {
                titleElement.contentEditable = true;
            }

            const button = document.querySelector(".edit-button");
            if (button) {
                button.innerText = "전체 저장하기";
                button.setAttribute("onclick", "saveAllAnswers()");
            }
        };

        // 전체 저장
        window.saveAllAnswers = async function () {
            const answers = Array.from(document.querySelectorAll(".answer")).map(function (answer) {
                return {
                    id: answer.id.split("-")[1],
                    answer: answer.textContent.trim()
                };
            });

            const titleElement = document.getElementById("resumeTitle");
            const newTitle = titleElement ? titleElement.textContent.trim() : "";

            try {
                const response = await fetch("/updateAnswers", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ title: newTitle, answers: answers })
                });

                if (response.ok) {
                    alert("모든 내용이 저장되었습니다.");
                    document.querySelectorAll(".answer").forEach(function (answer) {
                        answer.contentEditable = false;
                    });
                    if (titleElement) {
                        titleElement.contentEditable = false;
                    }

                    const button = document.querySelector(".edit-button");
                    if (button) {
                        button.innerText = "전체 수정하기";
                        button.setAttribute("onclick", "enableEditingAll()");
                    }

                    document.querySelectorAll("button").forEach(function (btn) {
                        if (btn.innerText === "저장하기") {
                            const id = btn.getAttribute("onclick").match(/saveAnswer\('(.+?)'\)/)[1];
                            btn.innerText = "수정하기";
                            btn.setAttribute("onclick", "enableEditing('" + id + "')");
                        }
                    });
                } else {
                    alert("저장 중 문제가 발생했습니다.");
                }
            } catch (error) {
                console.error("Error:", error);
                alert("저장 요청에 실패했습니다.");
            }
        };
    });
</script>

</body>
</html>
