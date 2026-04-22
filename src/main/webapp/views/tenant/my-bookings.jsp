<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Bookings | KHOJ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .booking-card {
            background: white;
            padding: 1.5rem;
            border-radius: 1rem;
            margin-bottom: 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            border-left: 5px solid #e2e8f0;
        }
        .status-ACCEPTED { border-left-color: #10b981; }
        .status-PENDING { border-left-color: #f59e0b; }
        .status-REJECTED { border-left-color: #ef4444; }
        
        .landlord-info {
            background: #f8fafc;
            padding: 1rem;
            border-radius: 0.75rem;
            margin-top: 1rem;
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        .btn-contact {
            background: #2563eb;
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>
<body style="background-color: #f1f5f9;">

    <nav style="padding: 1.5rem 10%; background: white; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center;">
        <div style="font-size: 1.5rem; font-weight: 700; color: #2563eb;">KHOJ</div>
        <div style="display: flex; gap: 2rem; align-items: center;">
            <a href="${pageContext.request.contextPath}/search" style="text-decoration: none; color: #64748b; font-weight: 500;">Discovery</a>
            <a href="${pageContext.request.contextPath}/my-bookings" style="text-decoration: none; color: #2563eb; font-weight: 700;">My Bookings</a>
            <a href="${pageContext.request.contextPath}/views/auth/login.jsp" class="badge badge-occupied" style="text-decoration: none;">Logout</a>
        </div>
    </nav>

    <div style="max-width: 800px; margin: 3rem auto; padding: 0 1rem;">
        <h1 style="margin-bottom: 2rem;">My Application Status</h1>

        <c:forEach var="app" items="${myApplications}">
            <div class="booking-card status-${app.status}">
                <div>
                    <h3 style="margin-bottom: 0.25rem;">${app.roomTitle}</h3>
                    <p style="color: #64748b; font-size: 0.875rem;">Application ID: #${app.appId}</p>
                    
                    <c:if test="${app.status == 'ACCEPTED'}">
                        <div class="landlord-info">
                            <div>
                                <strong>Landlord:</strong> ${app.landlordName}<br>
                                <strong>Email:</strong> ${app.landlordEmail}
                            </div>
                            <a href="mailto:${app.landlordEmail}" class="btn-contact">Contact Now</a>
                        </div>
                    </c:if>
                </div>
                
                <div style="text-align: right;">
                    <span class="badge ${app.status == 'ACCEPTED' ? 'badge-available' : (app.status == 'REJECTED' ? 'badge-occupied' : '')}" 
                          style="font-size: 0.875rem; padding: 0.5rem 1rem;">
                        ${app.status}
                    </span>
                    <p style="font-size: 0.75rem; color: #94a3b8; margin-top: 0.5rem;">Update: Just now</p>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty myApplications}">
            <div style="text-align: center; padding: 5rem; background: white; border-radius: 1rem;">
                <p style="color: #64748b; font-size: 1.125rem;">You haven't applied for any rooms yet.</p>
                <a href="${pageContext.request.contextPath}/search" style="color: #2563eb; font-weight: 600;">Go Find a Room →</a>
            </div>
        </c:if>
    </div>

</body>
</html>
