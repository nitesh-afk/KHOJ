<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | KHOJ</title>
    <link rel="stylesheet" href="../../resources/css/style.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="auth-card">
        <h2>KHOJ Login</h2>
        
        <% if ("invalid".equals(request.getParameter("error"))) { %>
            <div class="alert alert-error">Invalid email or password.</div>
        <% } %>
        
        <% if ("success".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success">Registration successful! Please login.</div>
        <% } %>

        <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" placeholder="student@example.com" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>
            <button type="submit">Login to KHOJ</button>
        </form>

        <div class="auth-footer">
            <p>New to KHOJ? <a href="register.jsp">Create an account</a></p>
        </div>
    </div>
</body>
</html>
