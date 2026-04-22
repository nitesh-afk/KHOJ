<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join KHOJ | Student Discovery</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="auth-card">
        <h2>Join KHOJ</h2>
        
        <%-- Displaying Error Messages from Redirect --%>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">
                Registration Failed: <%= request.getParameter("error") %>
                <% if (request.getParameter("details") != null) { %>
                    <br><small><%= request.getParameter("details").replace("_", " ") %></small>
                <% } %>
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
                    <option value="TENANT">Entrance Student (Tenant)</option>
                    <option value="LANDLORD">Room Owner (Landlord)</option>
                </select>
            </div>
            <button type="submit">Create Account</button>
        </form>

        <div class="auth-footer">
            <p>Already have an account? <a href="login.jsp">Login here</a></p>
        </div>
    </div>
</body>
</html>