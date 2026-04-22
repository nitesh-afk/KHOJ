<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Rooms | KHOJ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-logo">KHOJ Landlord</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/LandlordDashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/my-rooms" class="active">My Rooms</a></li>
            <li><a href="${pageContext.request.contextPath}/views/landlord/add-room.jsp">Add New Room</a></li>
            <li><a href="${pageContext.request.contextPath}/applications">Applications</a></li>
            <li><a href="${pageContext.request.contextPath}/views/auth/login.jsp" style="margin-top: 2rem; color: #ef4444;">Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Property Inventory</h1>
            <a href="${pageContext.request.contextPath}/views/landlord/add-room.jsp" class="badge badge-available" style="text-decoration: none; padding: 0.5rem 1rem;">+ Add New Property</a>
        </div>

        <div class="activity-table">
            <h2>Detailed Room List</h2>
            <table>
                <thead>
                    <tr>
                        <th>Property</th>
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
                                <small style="color: #64748b;">${room.description}</small>
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
                                <a href="#" style="color: #2563eb; font-weight: 500; text-decoration: none; margin-right: 15px;">Edit</a>
                                <a href="#" style="color: #ef4444; font-weight: 500; text-decoration: none;">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty rooms}">
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 3rem; color: #64748b;">
                                No rooms found. Start by listing your first property!
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
