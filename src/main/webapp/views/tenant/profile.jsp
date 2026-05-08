<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | KHOJ</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-primary: #FAF9F6;
            --card-bg: #FFFFFF;
            --nav-bg: #1C1917;
            --accent: #C9A96E;
            --accent-dark: #B8935A;
            --text-primary: #1C1917;
            --text-secondary: #6B6560;
            --border: #EDE9E3;
            --success-bg: #D8F3DC;
            --success-text: #2D6A4F;
            --error-bg: #FEE2E2;
            --error-text: #991B1B;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            min-height: 100vh;
        }

        .top-bar {
            background: var(--nav-bg);
            color: #fff;
            padding: 14px 24px;
        }

        .top-inner {
            max-width: 960px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }

        .brand {
            color: var(--accent);
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            text-decoration: none;
            font-weight: 700;
        }

        .back-link {
            color: rgba(255,255,255,0.85);
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .back-link:hover { color: #fff; }

        .container {
            max-width: 960px;
            margin: 0 auto;
            padding: 32px 20px 60px;
        }

        .page-title {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            margin-bottom: 8px;
        }

        .meta {
            color: var(--text-secondary);
            font-size: 0.92rem;
            margin-bottom: 24px;
        }

        .alert {
            border-radius: 10px;
            padding: 12px 14px;
            margin-bottom: 18px;
            font-weight: 600;
        }

        .alert-success {
            background: var(--success-bg);
            color: var(--success-text);
            border: 1px solid #B7E4C7;
        }

        .alert-error {
            background: var(--error-bg);
            color: var(--error-text);
            border: 1px solid #FECACA;
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .card {
            background: var(--card-bg);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 22px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.04);
        }

        .card h2 {
            font-size: 1.2rem;
            margin-bottom: 14px;
        }

        .field {
            margin-bottom: 14px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            color: var(--text-secondary);
            font-size: 0.88rem;
            font-weight: 600;
        }

        input {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 9px;
            padding: 11px 12px;
            font-size: 0.95rem;
            outline: none;
            font-family: inherit;
        }

        input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(201,169,110,0.18);
        }

        .hint {
            font-size: 0.8rem;
            color: var(--text-secondary);
            margin-top: 6px;
        }

        .error-text {
            margin-top: 6px;
            color: var(--error-text);
            font-size: 0.8rem;
            display: none;
        }

        .btn {
            border: 0;
            border-radius: 10px;
            background: var(--accent);
            color: var(--text-primary);
            font-weight: 800;
            padding: 11px 15px;
            cursor: pointer;
            font-size: 0.92rem;
            transition: 0.2s;
        }

        .btn:hover { background: var(--accent-dark); }

        @media (max-width: 860px) {
            .grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<div class="top-bar">
    <div class="top-inner">
        <a class="brand" href="${pageContext.request.contextPath}/home">KHOJ</a>
        <a class="back-link" href="${pageContext.request.contextPath}/search">Back to dashboard</a>
    </div>
</div>

<div class="container">
    <h1 class="page-title">My Profile</h1>
    <p class="meta">
        Role: ${profileUser.role}
        <c:if test="${not empty profileUser.createdAt}">
            | Joined: ${profileUser.createdAt}
        </c:if>
    </p>

    <c:if test="${param.success == 'true'}">
        <div class="alert alert-success">Profile updated successfully.</div>
    </c:if>

    <c:if test="${not empty param.error}">
        <div class="alert alert-error">
            <c:choose>
                <c:when test="${param.error == 'duplicate_email'}">This email is already in use by another account.</c:when>
                <c:when test="${param.error == 'invalid_name'}">Please enter a valid full name (letters, spaces, hyphens and apostrophes only).</c:when>
                <c:when test="${param.error == 'invalid_email'}">Please enter a valid email address.</c:when>
                <c:when test="${param.error == 'password_mismatch'}">New password and confirm password must match.</c:when>
                <c:when test="${param.error == 'password_too_short'}">New password must be at least 8 characters long.</c:when>
                <c:when test="${param.error == 'invalid_current_password'}">Current password is incorrect.</c:when>
                <c:when test="${param.error == 'update_failed'}">Database update failed. Please try again.</c:when>
                <c:when test="${param.error == 'user_not_found'}">Session user not found. Please log in again.</c:when>
                <c:when test="${param.error == 'invalid_action'}">Requested action is not supported.</c:when>
                <c:otherwise>Something went wrong. Please try again.</c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <div class="grid">
        <section class="card">
            <h2>Edit Profile</h2>
            <form id="profileForm" action="${pageContext.request.contextPath}/profile" method="post" novalidate>
                <input type="hidden" name="action" value="updateProfile">

                <div class="field">
                    <label for="fullName">Full name</label>
                    <input id="fullName" name="fullName" type="text" value="${profileUser.fullName}" required>
                    <div id="fullNameError" class="error-text">Name must contain only letters, spaces, hyphens and apostrophes.</div>
                </div>

                <div class="field">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" value="${profileUser.email}" required>
                    <div id="emailError" class="error-text">Please enter a valid email address.</div>
                </div>

                <div class="field">
                    <label for="phone">Phone number</label>
                    <input id="phone" name="phone" type="text" value="${profileUser.phoneNumber}">
                </div>

                <button class="btn" type="submit">Save changes</button>
            </form>
        </section>

        <section class="card">
            <h2>Change Password</h2>
            <form id="passwordForm" action="${pageContext.request.contextPath}/profile" method="post" novalidate>
                <input type="hidden" name="action" value="updatePassword">

                <div class="field">
                    <label for="currentPassword">Current password</label>
                    <input id="currentPassword" name="currentPassword" type="password" required>
                </div>

                <div class="field">
                    <label for="newPassword">New password</label>
                    <input id="newPassword" name="newPassword" type="password" required>
                    <div class="hint">Minimum 8 characters.</div>
                </div>

                <div class="field">
                    <label for="confirmPassword">Confirm new password</label>
                    <input id="confirmPassword" name="confirmPassword" type="password" required>
                    <div id="passwordError" class="error-text">New password and confirm password must match.</div>
                </div>

                <button class="btn" type="submit">Update password</button>
            </form>
        </section>
    </div>
</div>

<%@ include file="../../footer.jsp" %>

<script>
    (function () {
        const nameRegex = /^[a-zA-Z '-]+$/;
        const emailRegex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;

        const profileForm = document.getElementById("profileForm");
        const fullNameInput = document.getElementById("fullName");
        const emailInput = document.getElementById("email");
        const fullNameError = document.getElementById("fullNameError");
        const emailError = document.getElementById("emailError");

        profileForm.addEventListener("submit", function (e) {
            let valid = true;

            const fullName = fullNameInput.value.trim();
            const email = emailInput.value.trim();

            if (!fullName || !nameRegex.test(fullName)) {
                fullNameError.style.display = "block";
                valid = false;
            } else {
                fullNameError.style.display = "none";
            }

            if (!emailRegex.test(email)) {
                emailError.style.display = "block";
                valid = false;
            } else {
                emailError.style.display = "none";
            }

            if (!valid) {
                e.preventDefault();
            }
        });

        const passwordForm = document.getElementById("passwordForm");
        const newPasswordInput = document.getElementById("newPassword");
        const confirmPasswordInput = document.getElementById("confirmPassword");
        const passwordError = document.getElementById("passwordError");

        passwordForm.addEventListener("submit", function (e) {
            const newPassword = newPasswordInput.value;
            const confirmPassword = confirmPasswordInput.value;

            if (newPassword !== confirmPassword) {
                passwordError.style.display = "block";
                e.preventDefault();
                return;
            }

            passwordError.style.display = "none";
        });
    })();
</script>
</body>
</html>
