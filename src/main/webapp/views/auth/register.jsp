<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join KHOJ | Your Portal to Premium Stays</title>
    
    <!-- Link to our global premium stylesheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body class="auth-wrapper">
    <div class="auth-card" style="max-width: 450px;">
        <h2>Join KHOJ</h2>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">
                Registration Failed: <%= request.getParameter("error") %>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" placeholder="John Doe" required>
            </div>
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" placeholder="john@example.com" required>
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>
            <div class="form-group">
                <label for="role">I am a:</label>
                <select id="role" name="role">
                    <option value="TENANT">Tenant (Looking for stays)</option>
                    <option value="LANDLORD">Landlord (Listing properties)</option>
                </select>
            </div>
            <button type="submit">Create Account</button>
        </form>

        <div class="auth-footer">
            <p>Already have an account? <a href="${pageContext.request.contextPath}/views/auth/login.jsp">Login here</a></p>
        </div>
    </div>
</body>
</html>