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
<body style="background-color: #f5f7fa; display: block; margin: 0; padding: 0;">

    <!-- Fixed Top Navigation Bar -->
    <nav style="width: 100%; background: #003580; color: white; padding: 1rem 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 1000;">
        <div style="max-width: 1140px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between; align-items: center;">
            <div style="font-size: 1.8rem; font-weight: 800; letter-spacing: -1px; cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="location.href='home'">
                <i class="fa-solid fa-earth-asia" style="color: #ffb700;"></i> KHOJ
            </div>
            <div style="display: flex; gap: 25px; align-items: center;">
                <a href="${pageContext.request.contextPath}/search" style="text-decoration: none; color: rgba(255,255,255,0.8); font-weight: 600; font-size: 0.95rem;">Discovery</a>
                <a href="${pageContext.request.contextPath}/my-bookings" style="text-decoration: none; color: white; font-weight: 700; font-size: 0.95rem; border-bottom: 2px solid #ffb700; padding-bottom: 4px;">My Bookings</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" style="text-decoration: none; color: #ff9e9e; font-weight: 700; font-size: 0.95rem;">Logout</a>
            </div>
        </div>
    </nav>

    <!-- Main Content Container -->
    <main style="max-width: 800px; margin: 50px auto; padding: 0 20px;">
        <div style="background: white; border-radius: 16px; box-shadow: 0 10px 40px rgba(0,0,0,0.05); padding: 40px; border: 1px solid #eee;">
            <div style="border-bottom: 2px solid #f0f0f0; margin-bottom: 30px; padding-bottom: 15px;">
                <h1 style="font-size: 2rem; font-weight: 800; color: #1a1a1a; margin: 0;">My Application Status</h1>
                <p style="color: #666; margin-top: 5px;">Track your housing inquiries and connection status with landlords.</p>
            </div>

            <div class="applications-list">
                <c:forEach var="app" items="${myApplications}">
                    <div class="booking-card status-${app.status}" style="border: 1px solid #f0f0f0; transition: all 0.3s ease;">
                        <div style="flex: 1;">
                            <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 8px;">
                                <span class="badge" style="background: #f0f4ff; color: #003580; padding: 4px 10px; border-radius: 4px; font-size: 0.7rem; font-weight: 800; text-transform: uppercase;">
                                    ID: #${app.appId}
                                </span>
                                <span class="badge ${app.status == 'ACCEPTED' ? 'badge-available' : (app.status == 'REJECTED' ? 'badge-occupied' : '')}" 
                                      style="font-size: 0.75rem; padding: 4px 12px; border-radius: 4px;">
                                    ${app.status}
                                </span>
                            </div>
                            <h3 style="font-size: 1.25rem; font-weight: 700; margin: 0 0 10px; color: #1a1a1a;">${app.roomTitle}</h3>
                            
                            <c:if test="${app.status == 'ACCEPTED'}">
                                <div class="landlord-info" style="border: 1px solid #e0e7ff; background: #f5f8ff;">
                                    <div style="flex: 1;">
                                        <div style="font-weight: 700; color: #003580; margin-bottom: 4px;">
                                            <i class="fa-solid fa-user-tie"></i> ${app.landlordName}
                                        </div>
                                        <div style="color: #555; font-size: 0.85rem;">
                                            <i class="fa-solid fa-envelope"></i> ${app.landlordEmail}
                                        </div>
                                    </div>
                                    <a href="mailto:${app.landlordEmail}" class="btn-contact" style="background: #003580;">
                                        Message Landlord
                                    </a>
                                </div>
                            </c:if>
                        </div>
                        
                        <div style="text-align: right; min-width: 120px;">
                            <div style="font-size: 0.75rem; color: #94a3b8; font-weight: 500;">
                                <i class="fa-solid fa-clock-rotate-left"></i> Updated today
                            </div>
                        </div>
                    </div>
                </c:forEach>

                <c:if test="${empty myApplications}">
                    <div style="text-align: center; padding: 60px 20px;">
                        <div style="font-size: 4rem; color: #e2e8f0; margin-bottom: 20px;">
                            <i class="fa-solid fa-folder-open"></i>
                        </div>
                        <h2 style="font-size: 1.5rem; font-weight: 700; color: #475569; margin-bottom: 10px;">No Applications Found</h2>
                        <p style="color: #64748b; margin-bottom: 30px;">You haven't applied for any properties yet. Start your search to find the perfect stay.</p>
                        <a href="${pageContext.request.contextPath}/search" 
                           style="background: #003580; color: white; text-decoration: none; padding: 12px 30px; border-radius: 8px; font-weight: 700; transition: 0.2s;">
                            Explore Properties
                        </a>
                    </div>
                </c:if>
            </div>
        </div>
    </main>

</body>
</html>
