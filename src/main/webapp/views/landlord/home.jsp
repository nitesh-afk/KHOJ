<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Landlord Dashboard | KHOJ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>

    <div class="sidebar">
        <div class="sidebar-logo">KHOJ Landlord</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/LandlordDashboard" class="active">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/my-rooms">My Rooms</a></li>
            <li><a href="${pageContext.request.contextPath}/views/landlord/add-room.jsp">Add New Room</a></li>
            <li><a href="${pageContext.request.contextPath}/applications">Applications</a></li>
            <li><a href="${pageContext.request.contextPath}/views/auth/login.jsp" style="margin-top: 2rem; color: #ef4444;">Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Welcome, ${sessionScope.user.fullName}! 👋</h1>
            <a href="${pageContext.request.contextPath}/views/landlord/add-room.jsp" class="badge badge-available" style="text-decoration: none; padding: 0.5rem 1rem;">+ Add New Room</a>
        </div>

        <c:if test="${param.msg == 'room_added'}">
            <div class="badge badge-available" style="margin-bottom: 1.5rem; width: 100%; text-align: center; display: block; padding: 1rem;">
                ✅ Room listing has been published successfully!
            </div>
        </c:if>

        <div class="stats-grid">
            <div class="stat-card">
                <h3>Total Properties</h3>
                <div class="value">${totalProperties}</div>
            </div>
            <div class="stat-card">
                <h3>Verified Listings</h3>
                <div class="value">${totalProperties}</div> <!-- Simplification for now -->
            </div>
            <div class="stat-card">
                <h3>Pending Inquiries</h3>
                <div class="value">0</div>
            </div>
        </div>

        <div class="activity-table">
            <h2>My Room Inventory</h2>
            <table>
                <thead>
                    <tr>
                        <th>Room Details</th>
                        <th>Type</th>
                        <th>Location</th>
                        <th>Price (Rs.)</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="prop" items="${properties}">
                        <tr>
                            <td>
                                <strong>${prop.title}</strong><br>
                                <small style="color: #64748b;">ID: #${prop.propertyId}</small>
                            </td>
                            <td>${prop.propertyType}</td>
                            <td>${prop.neighborhoodName}, ${prop.cityName}</td>
                            <td><strong>${prop.price}</strong></td>
                            <td>
                                <span class="badge ${prop.verified ? 'badge-available' : 'badge-occupied'}">
                                    ${prop.verified ? 'Verified' : 'Pending'}
                                </span>
                            </td>
                            <td>
                                <a href="property-detail?id=${prop.propertyId}" style="color: #2563eb; font-weight: 500; text-decoration: none; margin-right: 10px;">View</a>
                                <a href="#" style="color: #ef4444; font-weight: 500; text-decoration: none;">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty properties}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 3rem; color: #64748b;">
                                No rooms found. Click "Add New Room" to get started!
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>
