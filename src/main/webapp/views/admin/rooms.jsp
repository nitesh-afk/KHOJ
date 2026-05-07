<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Room Moderation | KHOJ Admin</title>
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
                <li><a href="${pageContext.request.contextPath}/admin/rooms" class="active"><i class="fa-solid fa-building"></i> Property Moderation</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users"></i> User Governance</a></li>
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
                <div class="header-eyebrow">Property Governance</div>
                <h1>Property Moderation Queue</h1>
            </div>
            <div class="header-badge">
                <i class="fa-solid fa-building"></i> ${rooms.size()} LISTINGS
            </div>
        </div>

        <div class="section-wrapper">
            <c:choose>
                <c:when test="${empty rooms}">
                    <div class="empty-state">
                        <i class="fa-solid fa-building"></i>
                        <p>No properties in the moderation queue</p>
                    </div>
                </c:when>
                <c:otherwise>
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
                                        <div class="cell-bold">${room.title}</div>
                                        <div class="cell-muted">Owner ID: #${room.landlordId}</div>
                                    </td>
                                    <td>${room.neighborhoodName}</td>
                                    <td>Rs. ${room.price}</td>
                                    <td>
                                        <span class="badge ${room.verified ? 'badge-success' : 'badge-warning'}">
                                            ${room.verified ? 'APPROVED' : 'PENDING APPROVAL'}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${!room.verified}">
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="verifyProperty">
                                                <input type="hidden" name="propertyId" value="${room.propertyId}">
                                                <input type="hidden" name="verify" value="true">
                                                <button type="submit" class="btn btn-approve-lg">Approve Listing</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${room.verified}">
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="verifyProperty">
                                                <input type="hidden" name="propertyId" value="${room.propertyId}">
                                                <input type="hidden" name="verify" value="false">
                                                <button type="submit" class="btn btn-revoke-lg">Revoke</button>
                                            </form>
                                        </c:if>
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
