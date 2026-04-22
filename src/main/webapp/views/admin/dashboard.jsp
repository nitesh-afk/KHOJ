<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Master Command Center | KHOJ Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --admin-bg: #0f172a;
            --admin-sidebar: #1e293b;
            --admin-accent: #3b82f6;
        }
        body { background-color: #f8fafc; }
        .sidebar { background-color: var(--admin-sidebar); color: white; }
        .sidebar a { color: #94a3b8; }
        .sidebar a:hover, .sidebar a.active { color: white; background: #334155; }
        .sidebar-logo { color: var(--admin-accent); }
        .stat-card { border-top: 4px solid var(--admin-accent); }
        .action-btn { border: none; padding: 0.5rem 0.75rem; border-radius: 0.375rem; font-weight: 600; cursor: pointer; font-size: 0.75rem; }
        .btn-approve { background: #dcfce7; color: #166534; }
        .btn-delete { background: #fee2e2; color: #991b1b; }
        .btn-deactivate { background: #fef9c3; color: #854d0e; }
    </style>
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-logo">KHOJ Master</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/AdminServlet" class="active">Command Center</a></li>
            <li><a href="${pageContext.request.contextPath}/index.jsp">Public Site</a></li>
            <li><a href="${pageContext.request.contextPath}/views/auth/login.jsp" style="margin-top: 5rem; color: #f87171;">Shutdown Session</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>System Intelligence Dashboard</h1>
            <div class="badge badge-occupied" style="background: var(--admin-bg); color: white;">SUPERUSER</div>
        </div>

        <!-- Global Statistics -->
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Ecosystem Users</h3>
                <div class="value">${stats.totalUsers}</div>
            </div>
            <div class="stat-card">
                <h3>Global Property Listings</h3>
                <div class="value">${stats.totalRooms}</div>
            </div>
            <div class="stat-card" style="border-top-color: #f59e0b;">
                <h3>Pending Inquiries</h3>
                <div class="value">${stats.pendingApps}</div>
            </div>
        </div>

        <!-- Room Moderation Section -->
        <div class="activity-table" style="margin-bottom: 3rem;">
            <h2>Property Moderation Queue</h2>
            <table>
                <thead>
                    <tr>
                        <th>Property</th>
                        <th>Location</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="room" items="${rooms}">
                        <tr>
                            <td><strong>${room.title}</strong></td>
                            <td>${room.location}</td>
                            <td>Rs. ${room.price}</td>
                            <td>
                                <span class="badge ${room.approved ? 'badge-available' : 'badge-occupied'}">
                                    ${room.approved ? 'PUBLIC' : 'HELD'}
                                </span>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="approveRoom">
                                    <input type="hidden" name="roomId" value="${room.id}">
                                    <input type="hidden" name="approve" value="${!room.approved}">
                                    <button type="submit" class="action-btn ${room.approved ? 'btn-deactivate' : 'btn-approve'}">
                                        ${room.approved ? 'Revoke' : 'Approve'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- User Management Section -->
        <div class="activity-table">
            <h2>User Governance</h2>
            <table>
                <thead>
                    <tr>
                        <th>Identity</th>
                        <th>Role</th>
                        <th>State</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>
                                <strong>${u.fullName}</strong><br>
                                <small style="color: #64748b;">${u.email}</small>
                            </td>
                            <td><span class="badge" style="background: #e2e8f0;">${u.role}</span></td>
                            <td>
                                <span class="badge ${u.status == 'ACTIVE' ? 'badge-available' : 'badge-occupied'}">
                                    ${u.status}
                                </span>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="deactivateUser">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <button type="submit" class="action-btn btn-deactivate">Deactivate</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <button type="submit" class="action-btn btn-delete" onclick="return confirm('Nuclear Option: Delete user?')">Delete</button>
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
