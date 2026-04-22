<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Management | KHOJ Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .admin-sidebar { background-color: #0f172a; color: white; }
        .admin-sidebar a { color: #94a3b8; }
        .admin-sidebar a:hover, .admin-sidebar a.active { color: white; background: #1e293b; }
        .btn-action { border: none; padding: 0.5rem; border-radius: 0.25rem; cursor: pointer; font-weight: 600; font-size: 0.75rem; }
    </style>
</head>
<body>
    <div class="sidebar admin-sidebar">
        <div class="sidebar-logo" style="color: #3b82f6;">KHOJ Admin</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Overview</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users" class="active">User Management</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/rooms">Room Moderation</a></li>
            <li><a href="${pageContext.request.contextPath}/views/auth/login.jsp" style="margin-top: 2rem; color: #ef4444;">System Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>User Management</h1>
        </div>

        <c:if test="${not empty param.msg}">
            <div class="badge badge-available" style="margin-bottom: 1.5rem; width: 100%; text-align: center; display: block; padding: 1rem;">
                Action processed: ${param.msg}
            </div>
        </c:if>

        <div class="activity-table">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User Info</th>
                        <th>Role</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="user" items="${users}">
                        <tr>
                            <td>#${user.id}</td>
                            <td>
                                <strong>${user.fullName}</strong><br>
                                <small>${user.email}</small>
                            </td>
                            <td><span class="badge" style="background: #e2e8f0;">${user.role}</span></td>
                            <td>
                                <span class="badge ${user.status == 'VERIFIED' ? 'badge-available' : ''}">
                                    ${user.status}
                                </span>
                            </td>
                            <td>
                                <c:if test="${user.role == 'LANDLORD' && user.status != 'VERIFIED'}">
                                    <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="verifyLandlord">
                                        <input type="hidden" name="userId" value="${user.id}">
                                        <button type="submit" class="btn-action" style="background: #dcfce7; color: #166534;">Verify</button>
                                    </form>
                                </c:if>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="userId" value="${user.id}">
                                    <button type="submit" class="btn-action" style="background: #fee2e2; color: #991b1b; margin-left: 5px;" onclick="return confirm('Delete this user permanently?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
