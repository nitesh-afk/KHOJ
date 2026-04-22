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
                <h3>Total Rooms</h3>
                <div class="value">${totalRooms}</div>
            </div>
            <div class="stat-card">
                <h3>Active Listings</h3>
                <div class="value">${activeRooms}</div>
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
                    <c:forEach var="room" items="${rooms}">
                        <tr>
                            <td>
                                <strong>${room.title}</strong><br>
                                <small style="color: #64748b;">ID: #${room.id}</small>
                            </td>
                            <td>${room.roomType}</td>
                            <td>${room.location}</td>
                            <td><strong>${room.price}</strong></td>
                            <td>
                                <span class="badge ${room.status == 'Available' ? 'badge-available' : 'badge-occupied'}">
                                    ${room.status}
                                </span>
                            </td>
                            <td>
                                <a href="#" style="color: #2563eb; font-weight: 500; text-decoration: none; margin-right: 10px;">Edit</a>
                                <a href="#" style="color: #ef4444; font-weight: 500; text-decoration: none;">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty rooms}">
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
