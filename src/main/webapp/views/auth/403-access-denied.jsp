<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>403 - Access Denied | KHOJ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
</head>
<body style="display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f1f5f9;">
    <div style="text-align: center; background: white; padding: 4rem; border-radius: 1.5rem; box-shadow: 0 10px 25px rgba(0,0,0,0.1);">
        <h1 style="font-size: 5rem; color: #ef4444; margin-bottom: 1rem;">403</h1>
        <h2 style="margin-bottom: 1rem;">Access Denied</h2>
        <p style="color: #64748b; margin-bottom: 2rem;">You do not have permission to view this command center.</p>
        <a href="${pageContext.request.contextPath}/index.jsp" style="text-decoration: none; background: #2563eb; color: white; padding: 0.75rem 2rem; border-radius: 0.5rem; font-weight: 600;">Go Back Home</a>
    </div>
</body>
</html>
