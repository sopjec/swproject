<%@ page import="org.zerock.jdbcex.dto.ResumeQnaDTO" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <jsp:include page="checkSession.jsp"/>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/layout.css"> <!-- 올바른 경로 설정 -->
    <title>자기소개서 세부 정보</title>
    <style>
        .resume-container {
            width: 100%;
            margin: 0 auto;
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
        .edit-button {
            padding: 8px 15px;
            background-color: #333;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        .edit-button:hover {
            background-color: black;
        }
    </style>
</head>
<body>

<jsp:include page="header.jsp"/>

<div class="container">
    <div class="sidebar">
        <ul>
            <li><a href="#" onclick="checkSessionAndNavigate('resume.jsp'); return false;">자기소개서 등록</a></li>
            <li><a href="#" onclick="checkSessionAndNavigate('resume_view'); return false;">자기소개서 조회</a></li>
            <li><a href="#" onclick="checkSessionAndNavigate('resume_analyze.jsp'); return false;">자기소개서 분석</a></li>
        </ul>
    </div>

    <div class="resume-container" data-resume-id="<%= request.getAttribute("resumeId") %>">
        <div class="title-row">
            <h2 id="resumeTitle" contenteditable="false"><%= request.getAttribute("title") %></h2>
            <button class="edit-button" onclick="enableEditingAll()">전체 수정하기</button>
        </div>
        <hr>
        <% List<ResumeQnaDTO> qnaList = (List<ResumeQnaDTO>) request.getAttribute("qnaList"); %>
        <% if (qnaList != null) {
            for (ResumeQnaDTO qna : qnaList) { %>
        <div class="question-box">
            <p class="question"><%= qna.getQuestion() %></p>
            <div class="answer-box">
                <p class="answer" contenteditable="false" id="answer-<%= qna.getId() %>"><%= qna.getAnswer() %></p>
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
            document.querySelectorAll(".answer").forEach(answer => {
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
            const answers = Array.from(document.querySelectorAll(".answer")).map(answer => ({
                id: answer.id.split("-")[1],
                answer: answer.textContent.trim()
            }));

            const titleElement = document.getElementById("resumeTitle");
            const newTitle = titleElement ? titleElement.textContent.trim() : "";

            const resumeContainer = document.querySelector(".resume-container");
            if (!resumeContainer) {
                console.error("Resume container not found.");
                return;
            }

            const resumeId = resumeContainer.getAttribute("data-resume-id");
            if (!resumeId) {
                console.error("Resume ID is missing.");
                return;
            }

            console.log("Submitting Data:", {
                title: newTitle,
                resumeId: resumeId,
                answers: answers
            });

            try {
                const response = await fetch("/updateAnswers", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({ title: newTitle, resumeId: resumeId, answers: answers })
                });

                if (response.ok) {
                    alert("모든 내용이 저장되었습니다.");
                    document.querySelectorAll(".answer").forEach(answer => {
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
