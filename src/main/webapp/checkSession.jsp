<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
    function checkSessionAndNavigate(targetUrl) {
        fetch('/checkSession')
            .then(response => response.json())
            .then(data => {
                if (data.isLoggedIn) {
                    // 로그인 상태이면 타겟 URL로 이동
                    window.location.href = targetUrl;
                } else {
                    // 로그인 상태가 아니면 로그인 모달 표시
                    const loginModal = document.getElementById("login-modal");
                    if (loginModal) {
                        loginModal.style.display = "block";
                    }
                }
            })
            .catch(error => {
                console.error("세션 확인 중 오류 발생:", error);
            });
    }

    // 로그인 모달 닫기 및 로그인 페이지로 이동
    document.addEventListener("DOMContentLoaded", () => {
        const closeModalButton = document.getElementById("close-modal");
        const goLoginButton = document.getElementById("go-login");

        if (closeModalButton) {
            closeModalButton.addEventListener("click", () => {
                const loginModal = document.getElementById("login-modal");
                if (loginModal) {
                    loginModal.style.display = "none";
                }
            });
        }

        if (goLoginButton) {
            goLoginButton.addEventListener("click", () => {
                window.location.href = "login.jsp"; // 로그인 페이지로 이동
            });
        }
    });
</script>

<div id="login-modal" class="modal" style="display: none;">
    <div class="modal-content">
        <p>로그인이 필요한 서비스 입니다.</p>
        <button class="close-btn" id="close-modal">닫기</button>
        <button class="login-btn" id="go-login">로그인 하러가기</button>
    </div>
</div>

<style>
    /* 모달 스타일 */
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

    .close-btn, .login-btn {
        background-color: #333;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
    }

    .login-btn {
        background-color: #007bff;
        margin-top: 10px;
    }

    .close-btn:hover, .login-btn:hover {
        opacity: 0.8;
    }
</style>
