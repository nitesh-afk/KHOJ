<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Landlord Dashboard | KHOJ</title>
    <!-- Google Fonts & FontAwesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-primary: #FAF9F6;
            --sidebar-bg: #1C1917;
            --sidebar-active: #2C2925;
            --sidebar-text: rgba(255,255,255,0.55);
            --sidebar-text-hover: #FFFFFF;
            --accent-gold: #C9A96E;
            --text-primary: #1C1917;
            --text-secondary: #6B6560;
            --card-surface: #FFFFFF;
            --card-border: #EDE9E3;
            --table-header: #F7F4EF;
            --table-hover: #FDFAF6;
            --badge-verified-bg: #D8F3DC;
            --badge-verified-color: #2D6A4F;
            --badge-pending-bg: #FFF3CD;
            --badge-pending-color: #7B4F12;
            --badge-rejected-bg: #FFE4E4;
            --badge-rejected-color: #7B1D1D;
            --transition-premium: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            display: flex;
        }

        h1, h2, h3, .sidebar-logo {
            font-family: 'Playfair Display', serif;
        }

        /* SIDEBAR */
        .sidebar {
            width: 260px;
            background-color: var(--sidebar-bg);
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            display: flex;
            flex-direction: column;
            padding: 30px 20px;
            box-sizing: border-box;
        }

        .sidebar-logo {
            font-size: 1.6rem;
            color: var(--accent-gold);
            margin: 0;
        }

        .sidebar-tagline {
            font-family: 'Inter', sans-serif;
            font-size: 0.7rem;
            color: rgba(255,255,255,0.4);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 40px;
            display: block;
        }

        .nav-links {
            list-style: none;
            padding: 0;
            margin: 0;
            flex-grow: 1;
        }

        .nav-links li {
            margin-bottom: 8px;
        }

        .nav-links a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            border-radius: 10px;
            text-decoration: none;
            color: var(--sidebar-text);
            font-size: 0.95rem;
            font-weight: 500;
            transition: var(--transition-premium);
        }

        .nav-links a i {
            width: 20px;
            font-size: 0.9rem;
            text-align: center;
        }

        .nav-links a:hover {
            color: var(--sidebar-text-hover);
            background: rgba(255,255,255,0.06);
        }

        .nav-links a.active {
            color: var(--sidebar-text-hover);
            background: var(--sidebar-active);
            border-left: 3px solid var(--accent-gold);
            border-radius: 0 10px 10px 0;
        }

        .sidebar-bottom {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 20px;
            margin-top: auto;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: var(--accent-gold);
            color: var(--text-primary);
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            color: white;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .user-role {
            color: rgba(255,255,255,0.45);
            font-size: 0.7rem;
        }

        .logout-link {
            color: rgba(255,255,255,0.45);
            text-decoration: none;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: var(--transition-premium);
        }

        .logout-link:hover {
            color: #FFB4A2;
        }

        /* MAIN CONTENT */
        .main-content {
            margin-left: 260px;
            padding: 40px 48px;
            background-color: var(--bg-primary);
            min-height: 100vh;
            width: 100%;
            box-sizing: border-box;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 32px;
        }

        .header-left .greeting {
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
            color: var(--text-secondary);
            margin: 0;
        }

        .header-left h1 {
            font-size: 2rem;
            color: var(--text-primary);
            margin: 4px 0 0;
        }

        .btn-gold {
            background: var(--accent-gold);
            color: var(--text-primary);
            font-weight: 700;
            border-radius: 10px;
            padding: 12px 24px;
            border: none;
            text-decoration: none;
            display: inline-block;
            transition: var(--transition-premium);
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
        }

        .btn-gold:hover {
            transform: translateY(-1px);
            background: #B8935A;
        }

        .success-banner {
            background: var(--badge-verified-bg);
            border-left: 4px solid var(--badge-verified-color);
            border-radius: 0 10px 10px 0;
            color: var(--badge-verified-color);
            font-weight: 600;
            padding: 14px 20px;
            margin-bottom: 32px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }

        .stat-card {
            background: var(--card-surface);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 2px 16px rgba(0,0,0,0.05);
            transition: var(--transition-premium);
        }

        .stat-card:hover {
            transform: scale(1.02);
        }

        .stat-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 12px;
            font-size: 1.1rem;
        }

        .stat-value {
            font-family: 'Inter', sans-serif;
            font-size: 2.2rem;
            font-weight: 800;
            color: var(--text-primary);
            margin: 12px 0 4px;
        }

        .stat-label {
            font-family: 'Inter', sans-serif;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-secondary);
            margin: 0;
        }

        .table-card {
            background: var(--card-surface);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 28px;
            box-shadow: 0 2px 16px rgba(0,0,0,0.05);
        }

        .table-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .table-header-row h2 {
            font-size: 1.3rem;
            margin: 0;
            color: var(--text-primary);
        }

        .table-count {
            font-family: 'Inter', sans-serif;
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        thead {
            background: var(--table-header);
        }

        th {
            font-family: 'Inter', sans-serif;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-secondary);
            font-weight: 600;
            text-align: left;
            padding: 12px 16px;
        }

        td {
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
            color: var(--text-primary);
            padding: 14px 16px;
            border-bottom: 1px solid var(--card-border);
        }

        tr {
            transition: var(--transition-premium);
        }

        tr:hover td {
            background: var(--table-hover);
        }

        tr:last-child td {
            border-bottom: none;
        }

        .badge {
            border-radius: 6px;
            padding: 4px 10px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            display: inline-block;
        }

        .badge-verified {
            background: var(--badge-verified-bg);
            color: var(--badge-verified-color);
        }

        .badge-pending {
            background: var(--badge-pending-bg);
            color: var(--badge-pending-color);
        }

        .action-link {
            font-weight: 600;
            text-decoration: none;
            margin-right: 12px;
        }

        .action-link:hover {
            text-decoration: underline;
        }

        .link-view { color: var(--accent-gold); }
        .link-delete { color: #B91C1C; }

        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }

        .empty-state i {
            color: var(--card-border);
            font-size: 3rem;
        }

        .empty-state h3 {
            font-size: 1.3rem;
            color: var(--text-secondary);
            margin: 16px 0 8px;
            font-family: 'Playfair Display', serif;
        }

        .empty-state p {
            font-size: 0.95rem;
            color: var(--text-secondary);
            margin: 0 0 20px;
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2 class="sidebar-logo">KHOJ</h2>
        <span class="sidebar-tagline">Landlord Portal</span>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/LandlordDashboard" class="active"><i class="fa-solid fa-gauge-high"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/my-rooms"><i class="fa-solid fa-door-open"></i> My Rooms</a></li>
            <li><a href="${pageContext.request.contextPath}/views/landlord/add-room.jsp"><i class="fa-solid fa-circle-plus"></i> Add Listing</a></li>
            <li><a href="${pageContext.request.contextPath}/applications"><i class="fa-solid fa-inbox"></i> Applications</a></li>
        </ul>
        <div class="sidebar-bottom">
            <div class="user-profile">
                <div class="user-avatar">${fn:substring(sessionScope.user.fullName, 0, 1)}</div>
                <div class="user-info">
                    <span class="user-name">${sessionScope.user.fullName}</span>
                    <span class="user-role">Landlord</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-link"><i class="fa-solid fa-right-from-bracket"></i> Sign out</a>
        </div>
    </div>

    <div class="main-content">
        <div class="header">
            <div class="header-left">
                <p class="greeting">Good morning,</p>
                <h1>${sessionScope.user.fullName}</h1>
            </div>
            <a href="${pageContext.request.contextPath}/views/landlord/add-room.jsp" class="btn-gold">+ Add New Listing</a>
        </div>

        <c:if test="${param.msg == 'room_added'}">
            <div class="success-banner">
                <i class="fa-solid fa-circle-check"></i> Room listing has been published successfully!
            </div>
        </c:if>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon" style="background: #FFF3DC; color: var(--accent-gold);"><i class="fa-solid fa-building"></i></div>
                <div class="stat-value">${totalProperties}</div>
                <p class="stat-label">Total Properties</p>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: var(--badge-verified-bg); color: var(--badge-verified-color);"><i class="fa-solid fa-shield-halved"></i></div>
                <div class="stat-value">${totalProperties}</div>
                <p class="stat-label">Verified Listings</p>
            </div>
            <div class="stat-card">
                <div class="stat-icon" style="background: var(--badge-rejected-bg); color: #B91C1C;"><i class="fa-solid fa-clock"></i></div>
                <div class="stat-value">0</div>
                <p class="stat-label">Pending Inquiries</p>
            </div>
        </div>

        <div class="table-card">
            <div class="table-header-row">
                <h2>My Property Inventory</h2>
                <span class="table-count">${fn:length(properties)} listings</span>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Property</th>
                        <th>Type</th>
                        <th>Location</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="prop" items="${properties}">
                        <tr>
                            <td>
                                <strong style="font-weight: 600;">${prop.title}</strong><br>
                                <small style="color: var(--text-secondary);">ID: #${prop.propertyId}</small>
                            </td>
                            <td>${prop.propertyType}</td>
                            <td>${prop.neighborhoodName}, ${prop.cityName}</td>
                            <td style="font-weight: 600;">Rs. ${prop.price}</td>
                            <td>
                                <span class="badge ${prop.verified ? 'badge-verified' : 'badge-pending'}">
                                    ${prop.verified ? 'Verified' : 'Pending'}
                                </span>
                            </td>
                            <td>
                                <a href="property-detail?id=${prop.propertyId}" class="action-link link-view">View</a>
                                <a href="#" class="action-link link-delete">Delete</a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty properties}">
                        <tr>
                            <td colspan="6" style="border: none; padding: 0;">
                                <div class="empty-state">
                                    <i class="fa-solid fa-house-chimney-crack"></i>
                                    <h3>No listings yet</h3>
                                    <p>Add your first property to start receiving applications.</p>
                                    <a href="${pageContext.request.contextPath}/views/landlord/add-room.jsp" class="btn-gold">Add New Listing</a>
                                </div>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
