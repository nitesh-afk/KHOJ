<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Management | KHOJ Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
</head>
<body>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-top">
            <div class="logo-section">
                <div class="logo">KHOJ</div>
                <div class="logo-subtitle">Admin Control</div>
            </div>
            <hr class="sidebar-divider">
            <div class="superuser-badge">
                <div class="superuser-avatar">A</div>
                <div class="superuser-info">
                    <span class="superuser-name">System Admin</span>
                    <span class="superuser-role">SUPERUSER</span>
                </div>
            </div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/AdminServlet"><i class="fa-solid fa-gauge-high"></i> Command Center</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/rooms"><i class="fa-solid fa-building"></i> Property Moderation</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users" class="active"><i class="fa-solid fa-users"></i> User Governance</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/messages"><i class="fa-solid fa-envelope"></i> Message Center</a></li>
                <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-earth-asia"></i> Public Site</a></li>
            </ul>
        </div>
        <div class="sidebar-bottom">
            <a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-power-off"></i> Shutdown Session</a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <div class="header">
            <div class="header-left">
                <div class="header-eyebrow">User Governance</div>
                <h1>System Citizens</h1>
            </div>
            <div class="header-badge">
                <i class="fa-solid fa-users"></i> ${users.size()} ACCOUNTS
            </div>
        </div>

        <c:if test="${not empty param.msg}">
            <div class="alert-banner">
                <i class="fa-solid fa-circle-check"></i> Action processed: ${param.msg}
            </div>
        </c:if>

        <div class="section-wrapper">
            <c:choose>
                <c:when test="${empty users}">
                    <div class="empty-state">
                        <i class="fa-solid fa-users"></i>
                        <p>No users found</p>
                    </div>
                </c:when>
                <c:otherwise>
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
                                    <td class="cell-id">#${user.id}</td>
                                    <td>
                                        <div class="cell-bold">${user.fullName}</div>
                                        <div class="cell-muted">${user.email}</div>
                                    </td>
                                    <td><span class="badge badge-role">${user.role}</span></td>
                                    <td>
                                        <span class="badge ${user.status == 'VERIFIED' ? 'badge-success' : user.status == 'ACTIVE' ? 'badge-info' : 'badge-role'}">
                                            ${user.status}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${user.role == 'LANDLORD' && user.status != 'VERIFIED'}">
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="verifyLandlord">
                                                <input type="hidden" name="userId" value="${user.id}">
                                                <button type="submit" class="btn btn-verify">Verify</button>
                                            </form>
                                        </c:if>
                                        <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="deleteUser">
                                            <input type="hidden" name="userId" value="${user.id}">
                                            <button type="submit" class="btn btn-delete-lg" onclick="return confirm('Delete this user permanently?')">Delete</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
