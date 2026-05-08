<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Master Command Center | KHOJ Admin</title>
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
                <li><a href="${pageContext.request.contextPath}/AdminServlet" class="active"><i class="fa-solid fa-gauge-high"></i> Command Center</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/rooms"><i class="fa-solid fa-building"></i> Property Moderation</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users"></i> User Governance</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/messages"><i class="fa-solid fa-envelope"></i> Message Center</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/analytics"><i class="fa-solid fa-chart-bar"></i> Analytics</a></li>
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
                <div class="header-eyebrow">System Intelligence</div>
                <h1>Command Center</h1>
            </div>
            <div class="header-badge">
                <i class="fa-solid fa-shield-halved"></i> SUPERUSER
            </div>
        </div>

        <!-- Global Statistics -->
        <div class="stats-grid">
            <div class="stat-card card-users">
                <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
                <div class="stat-number">${stats.totalUsers}</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card card-rooms">
                <div class="stat-icon"><i class="fa-solid fa-building"></i></div>
                <div class="stat-number">${stats.totalRooms}</div>
                <div class="stat-label">Total Properties</div>
            </div>
            <div class="stat-card card-pending">
                <div class="stat-icon"><i class="fa-regular fa-clock"></i></div>
                <div class="stat-number">${stats.pendingApps}</div>
                <div class="stat-label">Pending Applications</div>
            </div>
        </div>

        <!-- Property Moderation Section -->
        <div class="section-wrapper">
            <div class="section-header">
                <h2>Property Moderation Queue</h2>
                <div class="live-pill">
                    <div class="live-dot"></div> Live
                </div>
            </div>
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
                            <td class="cell-bold">${room.title}</td>
                            <td>${room.neighborhoodName}, ${room.cityName}</td>
                            <td>Rs. ${room.price}</td>
                            <td>
                                <span class="badge ${room.verified ? 'badge-success' : 'badge-warning'}">
                                    ${room.verified ? 'PUBLIC' : 'HELD'}
                                </span>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="approveRoom">
                                    <input type="hidden" name="roomId" value="${room.propertyId}">
                                    <input type="hidden" name="approve" value="${!room.verified}">
                                    <button type="submit" class="btn ${room.verified ? 'btn-revoke' : 'btn-approve'}">
                                        ${room.verified ? 'Revoke' : 'Approve'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Tenant Management Section -->
        <div class="section-wrapper">
            <div class="section-header">
                <h2>Tenant Management</h2>
                <div class="live-pill">
                    <div class="live-dot"></div> Live
                </div>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Identity</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${tenants}">
                        <tr>
                            <td>
                                <div class="cell-bold">${u.fullName}</div>
                                <div class="cell-muted">${u.email}</div>
                            </td>
                            <td>
                                <span class="badge ${u.status == 'ACTIVE' ? 'badge-success' : 'badge-danger'}">
                                    ${u.status}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.status == 'ACTIVE'}">
                                        <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="deactivateUser">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <input type="hidden" name="userRole" value="TENANT">
                                            <button type="submit" class="btn btn-deactivate" onclick="return confirm('Are you sure you want to deactivate this tenant?')">
                                                Deactivate
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="reactivateUser">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <button type="submit" class="btn btn-approve">
                                                Reactivate
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline; margin-left: 8px;">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <button type="submit" class="btn btn-delete" onclick="return confirm('CRITICAL: This will permanently delete the tenant. Continue?')">
                                        Delete
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Landlord Management Section -->
        <div class="section-wrapper">
            <div class="section-header">
                <h2>Landlord Management</h2>
                <div class="live-pill">
                    <div class="live-dot"></div> Live
                </div>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Identity</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${landlords}">
                        <tr>
                            <td>
                                <div class="cell-bold">${u.fullName}</div>
                                <div class="cell-muted">${u.email}</div>
                            </td>
                            <td>
                                <span class="badge ${u.status == 'ACTIVE' ? 'badge-success' : 'badge-danger'}">
                                    ${u.status}
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.status == 'ACTIVE'}">
                                        <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="deactivateUser">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <input type="hidden" name="userRole" value="LANDLORD">
                                            <button type="submit" class="btn btn-deactivate" onclick="return confirm('WARNING: Deactivating this landlord will automatically UNPUBLISH all their active property listings. Continue?')">
                                                Deactivate
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                            <input type="hidden" name="action" value="reactivateUser">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <button type="submit" class="btn btn-approve">
                                                Reactivate
                                            </button>
                                        </form>
                                    </c:otherwise>
                                </c:choose>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline; margin-left: 8px;">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <button type="submit" class="btn btn-delete" onclick="return confirm('CRITICAL: This will permanently delete the landlord and ALL their properties. Continue?')">
                                        Delete
                                    </button>
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
