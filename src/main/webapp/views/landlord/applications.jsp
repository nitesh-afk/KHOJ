<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Applications Inbox | KHOJ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .action-btn {
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            font-size: 0.8125rem;
        }
        .btn-accept { background: #dcfce7; color: #166534; }
        .btn-reject { background: #fee2e2; color: #991b1b; margin-left: 5px; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-logo">KHOJ Landlord</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/LandlordDashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/my-rooms">My Rooms</a></li>
            <li><a href="${pageContext.request.contextPath}/views/landlord/add-room.jsp">Add New Room</a></li>
            <li><a href="${pageContext.request.contextPath}/applications" class="active">Applications</a></li>
            <li><a href="${pageContext.request.contextPath}/views/auth/login.jsp" style="margin-top: 2rem; color: #ef4444;">Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Applications Inbox</h1>
        </div>

        <c:if test="${param.msg == 'status_updated'}">
            <div class="badge badge-available" style="margin-bottom: 1.5rem; width: 100%; text-align: center; display: block; padding: 1rem;">
                ✅ Application status updated successfully!
            </div>
        </c:if>

        <div class="activity-table">
            <h2>Recent Student Inquiries</h2>
            <table>
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Property Interested In</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="app" items="${applications}">
                        <tr>
                            <td>
                                <strong>${app.studentName}</strong><br>
                                <small style="color: #64748b;">${app.studentEmail}</small>
                            </td>
                            <td>${app.roomTitle}</td>
                            <td>
                                <span class="badge ${app.status == 'ACCEPTED' ? 'badge-available' : (app.status == 'REJECTED' ? 'badge-occupied' : '')}">
                                    ${app.status}
                                </span>
                            </td>
                            <td>
                                <c:if test="${app.status == 'PENDING'}">
                                    <form action="${pageContext.request.contextPath}/applications" method="post" style="display: inline;">
                                        <input type="hidden" name="appId" value="${app.appId}">
                                        <input type="hidden" name="status" value="ACCEPTED">
                                        <button type="submit" class="action-btn btn-accept">Accept</button>
                                    </form>
                                    <form action="${pageContext.request.contextPath}/applications" method="post" style="display: inline;">
                                        <input type="hidden" name="appId" value="${app.appId}">
                                        <input type="hidden" name="status" value="REJECTED">
                                        <button type="submit" class="action-btn btn-reject">Reject</button>
                                    </form>
                                </c:if>
                                <c:if test="${app.status != 'PENDING'}">
                                    <small style="color: #64748b;">Processed</small>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty applications}">
                        <tr>
                            <td colspan="4" style="text-align: center; padding: 3rem; color: #64748b;">
                                No applications received yet.
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
