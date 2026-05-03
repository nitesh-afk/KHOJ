<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Applications | KHOJ</title>
  <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Inter', sans-serif;
      background-color: #FAF9F6;
      color: #1C1917;
      display: flex;
      min-height: 100vh;
    }

    /* Sidebar Styles */
    .sidebar {
      position: fixed;
      left: 0;
      top: 0;
      width: 260px;
      height: 100vh;
      background-color: #0F0E0C;
      padding: 24px 20px;
      display: flex;
      flex-direction: column;
      z-index: 100;
    }
    .sidebar-top { flex: 1; }
    .logo-section { margin-bottom: 16px; }
    .logo {
      font-family: 'Playfair Display', serif;
      font-size: 1.8rem;
      color: #C9A96E;
    }
    .logo-subtitle {
      font-family: 'Inter', sans-serif;
      font-size: 0.65rem;
      text-transform: uppercase;
      letter-spacing: 2px;
      color: rgba(255, 255, 255, 0.3);
      margin-top: 4px;
    }
    .sidebar-divider {
      border: 0;
      border-bottom: 1px solid rgba(201, 169, 110, 0.2);
      margin: 16px 0;
    }
    .superuser-badge {
      background: rgba(201, 169, 110, 0.1);
      border: 1px solid rgba(201, 169, 110, 0.3);
      border-radius: 8px;
      padding: 10px 14px;
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 32px;
    }
    .superuser-avatar {
      width: 32px;
      height: 32px;
      border-radius: 50%;
      background: #C9A96E;
      color: #1C1917;
      font-weight: 700;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 0.9rem;
    }
    .superuser-info { display: flex; flex-direction: column; }
    .superuser-name {
      font-family: 'Inter', sans-serif;
      font-size: 0.82rem;
      color: #FFFFFF;
      font-weight: 600;
    }
    .superuser-role {
      font-family: 'Inter', sans-serif;
      font-size: 0.65rem;
      color: #C9A96E;
      text-transform: uppercase;
      margin-top: 2px;
    }

    .nav-links { list-style: none; display: flex; flex-direction: column; gap: 8px; }
    .nav-links a {
      text-decoration: none;
      padding: 12px 16px;
      border-radius: 10px;
      display: flex;
      align-items: center;
      gap: 12px;
      color: rgba(255, 255, 255, 0.45);
      font-size: 0.9rem;
      transition: all 0.2s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }
    .nav-links a i {
      font-size: 0.9rem;
      width: 16px;
      text-align: center;
    }
    .nav-links a:hover {
      color: #FFFFFF;
      background: rgba(255, 255, 255, 0.05);
    }
    .nav-links a.active {
      color: #FFFFFF;
      background: #1C1917;
      border-left: 3px solid #C9A96E;
      border-radius: 0 10px 10px 0;
    }

    .sidebar-bottom {
      margin-top: auto;
      border-top: 1px solid rgba(255, 255, 255, 0.08);
      padding-top: 16px;
    }
    .sidebar-bottom a {
      text-decoration: none;
      display: flex;
      align-items: center;
      gap: 12px;
      color: rgba(255, 255, 255, 0.35);
      font-size: 0.9rem;
      padding: 12px 16px;
      border-radius: 10px;
      transition: color 0.2s;
    }
    .sidebar-bottom a:hover { color: #FFB4A2; }

    /* Main Content */
    .main-content {
      margin-left: 260px;
      padding: 40px 48px;
      width: calc(100% - 260px);
      min-height: 100vh;
    }

    /* Top Header */
    .header {
      display: flex;
      justify-content: space-between;
      align-items: flex-end;
      margin-bottom: 40px;
    }
    .header-left { display: flex; flex-direction: column; }
    .header-eyebrow {
      font-family: 'Inter', sans-serif;
      font-size: 0.75rem;
      text-transform: uppercase;
      letter-spacing: 1px;
      color: #C9A96E;
      margin-bottom: 8px;
    }
    .header h1 {
      font-family: 'Playfair Display', serif;
      font-size: 2.2rem;
      color: #1C1917;
      font-weight: 700;
    }
    .header-badge {
      background: #1C1917;
      color: #C9A96E;
      border: 1px solid rgba(201, 169, 110, 0.4);
      border-radius: 20px;
      padding: 8px 18px;
      font-size: 0.75rem;
      font-weight: 700;
      text-transform: uppercase;
      letter-spacing: 1px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    /* Applications Wrapper */
    .applications-wrapper {
      background: #FFFFFF;
      border: 1px solid #EDE9E3;
      border-radius: 16px;
      padding: 32px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.03);
      max-width: 900px;
    }

    .booking-card {
      background: #FFFFFF;
      padding: 24px;
      border-radius: 12px;
      margin-bottom: 24px;
      display: flex;
      justify-content: space-between;
      align-items: center;
      border: 1px solid #EDE9E3;
      border-left: 4px solid #EDE9E3;
      transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
    }
    .booking-card:hover {
      box-shadow: 0 8px 25px rgba(0,0,0,0.06);
      transform: translateY(-2px);
    }

    .status-ACCEPTED { border-left-color: #2D6A4F; }
    .status-PENDING { border-left-color: #C9A96E; }
    .status-REJECTED { border-left-color: #B91C1C; }

    .app-id-badge {
      background: #F7F4EF;
      color: #6B6560;
      padding: 4px 10px;
      border-radius: 4px;
      font-size: 0.7rem;
      font-weight: 700;
      text-transform: uppercase;
      border: 1px solid #EDE9E3;
    }

    .status-badge {
      font-size: 0.75rem;
      padding: 4px 12px;
      border-radius: 4px;
      font-weight: 700;
      text-transform: uppercase;
    }
    .status-badge.ACCEPTED { background: #D8F3DC; color: #2D6A4F; }
    .status-badge.PENDING { background: #FFF3DC; color: #B8965B; }
    .status-badge.REJECTED { background: #FFE4E4; color: #B91C1C; }

    .property-title {
      font-family: 'Playfair Display', serif;
      font-size: 1.4rem;
      font-weight: 700;
      margin: 16px 0 12px;
      color: #1C1917;
    }

    .landlord-info {
      background: #FDFAF6;
      border: 1px solid rgba(201, 169, 110, 0.2);
      padding: 16px;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-top: 16px;
    }
    .landlord-details {
      display: flex;
      flex-direction: column;
      gap: 4px;
    }
    .landlord-name {
      font-family: 'Inter', sans-serif;
      font-weight: 600;
      color: #1C1917;
      font-size: 0.95rem;
    }
    .landlord-email {
      color: #6B6560;
      font-size: 0.85rem;
    }
    .btn-contact {
      background: #1C1917;
      color: #C9A96E;
      padding: 10px 18px;
      border-radius: 6px;
      text-decoration: none;
      font-weight: 600;
      font-size: 0.85rem;
      transition: all 0.2s;
      border: 1px solid rgba(201, 169, 110, 0.3);
    }
    .btn-contact:hover {
      background: #2D2A28;
      color: #E2C792;
    }

    .last-updated {
      font-size: 0.75rem;
      color: #6B6560;
      font-weight: 500;
    }

    /* Empty State */
    .empty-state {
      text-align: center;
      padding: 60px 20px;
    }
    .empty-state i {
      font-size: 3rem;
      color: rgba(201, 169, 110, 0.3);
      margin-bottom: 20px;
    }
    .empty-state h2 {
      font-family: 'Playfair Display', serif;
      font-size: 1.6rem;
      font-weight: 700;
      color: #1C1917;
      margin-bottom: 12px;
    }
    .empty-state p {
      color: #6B6560;
      margin-bottom: 30px;
    }
    .btn-explore {
      background: #C9A96E;
      color: #1C1917;
      text-decoration: none;
      padding: 12px 30px;
      border-radius: 8px;
      font-weight: 700;
      transition: background 0.2s;
    }
    .btn-explore:hover {
      background: #B8965B;
    }
  </style>
</head>
<body>

<!-- SIDEBAR -->
<div class="sidebar">
  <div class="sidebar-top">
    <div class="logo-section">
      <div class="logo">KHOJ</div>
      <div class="logo-subtitle">Tenant Portal</div>
    </div>
    <hr class="sidebar-divider">
    <div class="superuser-badge">
      <div class="superuser-avatar">${not empty sessionScope.user.fullName ? sessionScope.user.fullName.substring(0,1) : 'T'}</div>
      <div class="superuser-info">
        <span class="superuser-name">${sessionScope.user.fullName}</span>
        <span class="superuser-role">TENANT</span>
      </div>
    </div>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/search"><i class="fa-solid fa-compass"></i> Property Discovery</a></li>
      <li><a href="${pageContext.request.contextPath}/my-bookings" class="active"><i class="fa-solid fa-bookmark"></i> My Applications</a></li>
    </ul>
  </div>
  <div class="sidebar-bottom">
    <a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-power-off"></i> Secure Logout</a>
  </div>
</div>

<!-- MAIN CONTENT -->
<div class="main-content">
  <div class="header">
    <div class="header-left">
      <div class="header-eyebrow">Connection Center</div>
      <h1>My Applications</h1>
    </div>
    <div class="header-badge">
      <i class="fa-solid fa-file-signature"></i> APPLICATION STATUS
    </div>
  </div>

  <div class="applications-wrapper">
    <c:forEach var="app" items="${myApplications}">
      <div class="booking-card status-${app.status}">
        <div style="flex: 1;">
          <div style="display: flex; align-items: center; gap: 12px;">
            <span class="app-id-badge">REF #${app.appId}</span>
            <span class="status-badge ${app.status}">${app.status}</span>
          </div>
          <h3 class="property-title">${app.propertyTitle}</h3>

          <c:if test="${app.status == 'ACCEPTED'}">
            <div class="landlord-info">
              <div class="landlord-details">
                <div class="landlord-name"><i class="fa-solid fa-user-tie" style="color:#C9A96E; margin-right:6px;"></i> ${app.landlordName}</div>
                <div class="landlord-email"><i class="fa-solid fa-envelope" style="margin-right:6px;"></i> ${app.landlordEmail}</div>
              </div>
              <a href="mailto:${app.landlordEmail}" class="btn-contact">
                <i class="fa-solid fa-paper-plane" style="margin-right:6px;"></i> Message Host
              </a>
            </div>
          </c:if>
        </div>

        <div style="text-align: right; min-width: 120px; align-self: flex-start; margin-top: 8px;">
          <div class="last-updated">
            <i class="fa-solid fa-clock-rotate-left"></i> Updated Recently
          </div>
        </div>
      </div>
    </c:forEach>

    <c:if test="${empty myApplications}">
      <div class="empty-state">
        <i class="fa-solid fa-folder-open"></i>
        <h2>No Active Applications</h2>
        <p>You haven't initiated any connections with property hosts yet.</p>
        <a href="${pageContext.request.contextPath}/search" class="btn-explore">
          Discover Properties
        </a>
      </div>
    </c:if>
  </div>
</div>

</body>
</html>