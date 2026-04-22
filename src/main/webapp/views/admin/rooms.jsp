<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Room Moderation | KHOJ Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .admin-sidebar { background-color: #0f172a; color: white; }
        .admin-sidebar a { color: #94a3b8; }
        .admin-sidebar a:hover, .admin-sidebar a.active { color: white; background: #1e293b; }
        .btn-action { border: none; padding: 0.5rem 1rem; border-radius: 0.25rem; cursor: pointer; font-weight: 600; }
    </style>
</head>
<body>
    <div class="sidebar admin-sidebar">
        <div class="sidebar-logo" style="color: #3b82f6;">KHOJ Admin</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/admin/dashboard">Overview</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">User Management</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/rooms" class="active">Room Moderation</a></li>
            <li><a href="${pageContext.request.contextPath}/views/auth/login.jsp" style="margin-top: 2rem; color: #ef4444;">System Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Room Moderation Queue</h1>
        </div>

        <div class="activity-table">
            <table>
                <thead>
                    <tr>
                        <th>Listing</th>
                        <th>Location</th>
                        <th>Price</th>
                        <th>Approval Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="room" items="${rooms}">
                        <tr>
                            <td>
                                <strong>${room.title}</strong><br>
                                <small>Owner ID: #${room.ownerId}</small>
                            </td>
                            <td>${room.location}</td>
                            <td>Rs. ${room.price}</td>
                            <td>
                                <span class="badge ${room.approved ? 'badge-available' : 'badge-occupied'}">
                                    ${room.approved ? 'APPROVED' : 'PENDING APPROVAL'}
                                </span>
                            </td>
                            <td>
                                <c:if test="${!room.approved}">
                                    <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="approveRoom">
                                        <input type="hidden" name="roomId" value="${room.id}">
                                        <input type="hidden" name="approve" value="true">
                                        <button type="submit" class="btn-action" style="background: #2563eb; color: white;">Approve Listing</button>
                                    </form>
                                </c:if>
                                <c:if test="${room.approved}">
                                    <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                        <input type="hidden" name="action" value="approveRoom">
                                        <input type="hidden" name="roomId" value="${room.id}">
                                        <input type="hidden" name="approve" value="false">
                                        <button type="submit" class="btn-action" style="background: #f1f5f9; color: #64748b;">Revoke</button>
                                    </form>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
