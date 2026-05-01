<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Find Your Room | KHOJ</title>
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

        /* Search Section */
        .search-hero {
            background: #1C1917;
            border-radius: 16px;
            padding: 40px;
            margin-bottom: 40px;
            text-align: center;
            border: 1px solid rgba(201, 169, 110, 0.2);
            position: relative;
            overflow: hidden;
        }
        .search-hero::before {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 150px;
            height: 150px;
            background: radial-gradient(circle, rgba(201, 169, 110, 0.15) 0%, rgba(28, 25, 23, 0) 70%);
            border-radius: 50%;
        }
        .search-hero h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            color: #FAF9F6;
            margin-bottom: 12px;
        }
        .search-hero p {
            color: rgba(250, 249, 246, 0.7);
            font-size: 1rem;
            margin-bottom: 24px;
        }
        .search-box {
            display: flex;
            max-width: 600px;
            margin: 0 auto;
            background: #FAF9F6;
            padding: 6px;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .search-box input {
            flex: 1;
            border: none;
            padding: 12px 20px;
            background: transparent;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            color: #1C1917;
            outline: none;
        }
        .search-btn {
            background: #C9A96E;
            color: #1C1917;
            border: none;
            padding: 0 24px;
            border-radius: 6px;
            font-weight: 700;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: 0.2s;
        }
        .search-btn:hover {
            background: #B8965B;
        }

        /* Success Banner */
        .banner-success {
            background: #D8F3DC;
            color: #2D6A4F;
            padding: 16px;
            border-radius: 12px;
            margin-bottom: 30px;
            border: 1px solid #B7E4C7;
            font-weight: 600;
            text-align: center;
        }

        /* Results Header */
        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .results-header h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.4rem;
            color: #1C1917;
        }

        /* Property Grid */
        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
        }
        .room-card {
            background: #FFFFFF;
            border-radius: 16px;
            overflow: hidden;
            border: 1px solid #EDE9E3;
            text-decoration: none;
            color: inherit;
            transition: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            display: flex;
            flex-direction: column;
        }
        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.08);
            border-color: rgba(201, 169, 110, 0.3);
        }
        .room-img-container {
            position: relative;
            height: 220px;
            width: 100%;
        }
        .room-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .room-type-badge {
            position: absolute;
            top: 16px;
            right: 16px;
            background: rgba(15, 14, 12, 0.85);
            backdrop-filter: blur(4px);
            color: #C9A96E;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 0.7rem;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        .room-info {
            padding: 24px;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        .room-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }
        .verified-badge {
            background: #F7F4EF;
            color: #6B6560;
            border: 1px solid #EDE9E3;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 0.65rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .room-price {
            font-family: 'Playfair Display', serif;
            font-size: 1.4rem;
            font-weight: 700;
            color: #1C1917;
        }
        .room-price small {
            font-family: 'Inter', sans-serif;
            font-size: 0.8rem;
            color: #6B6560;
            font-weight: 500;
        }
        .room-title {
            font-size: 1.15rem;
            font-weight: 700;
            margin-bottom: 8px;
            color: #1C1917;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        .room-location {
            color: #6B6560;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 6px;
            margin-top: auto;
        }
        .room-location i {
            color: #C9A96E;
        }

        /* Empty State */
        .empty-state {
            grid-column: 1 / -1;
            background: #FFFFFF;
            border: 1px dashed #C9A96E;
            border-radius: 16px;
            padding: 60px 20px;
            text-align: center;
        }
        .empty-state i {
            font-size: 3rem;
            color: rgba(201, 169, 110, 0.4);
            margin-bottom: 16px;
        }
        .empty-state h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            color: #1C1917;
            margin-bottom: 8px;
        }
        .empty-state p {
            color: #6B6560;
            font-size: 0.9rem;
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
                <li><a href="${pageContext.request.contextPath}/search" class="active"><i class="fa-solid fa-compass"></i> Property Discovery</a></li>
                <li><a href="${pageContext.request.contextPath}/my-bookings"><i class="fa-solid fa-bookmark"></i> My Applications</a></li>
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
                <div class="header-eyebrow">Discover Excellence</div>
                <h1>Premium Accommodations</h1>
            </div>
            <div class="header-badge">
                <i class="fa-solid fa-shield-check"></i> VERIFIED LISTINGS
            </div>
        </div>

        <c:if test="${param.msg == 'applied'}">
            <div class="banner-success">
                <i class="fa-solid fa-check-circle"></i> Application securely submitted! You can track its status in 'My Applications'.
            </div>
        </c:if>

        <div class="search-hero">
            <h2>Find Your Signature Residence</h2>
            <p>Explore our curated collection of verified student and professional accommodations.</p>
            <form action="${pageContext.request.contextPath}/search" method="get" class="search-box">
                <!-- Using name="location" to match SearchServlet.java -->
                <input type="text" name="location" value="${searchLocation}" placeholder="Search by neighborhood or city...">
                <button type="submit" class="search-btn">Discover</button>
            </form>
        </div>

        <div class="results-header">
            <h3>
                <c:choose>
                    <c:when test="${not empty searchLocation}">Search Results for "${searchLocation}"</c:when>
                    <c:otherwise>Top Recommended Properties</c:otherwise>
                </c:choose>
            </h3>
        </div>

        <div class="room-grid">
            <c:forEach var="room" items="${properties}">
                <a href="${pageContext.request.contextPath}/property-detail?id=${room.propertyId}" class="room-card">
                    <div class="room-img-container">
                        <img src="${not empty room.imageUrls ? room.imageUrls[0] : 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=600&q=80'}" class="room-img" alt="${room.title}">
                        <span class="room-type-badge">
                            ${room.propertyType}
                        </span>
                    </div>
                    <div class="room-info">
                        <div class="room-meta">
                            <span class="verified-badge"><i class="fa-solid fa-check" style="color:#C9A96E;"></i> Verified</span>
                            <span class="room-price">Rs. ${room.price} <small>/mo</small></span>
                        </div>
                        <h3 class="room-title">${room.title}</h3>
                        <p class="room-location">
                            <i class="fa-solid fa-location-dot"></i> ${room.neighborhoodName}, ${room.cityName}
                        </p>
                    </div>
                </a>
            </c:forEach>
            
            <c:if test="${empty properties}">
                <div class="empty-state">
                    <i class="fa-solid fa-building-circle-xmark"></i>
                    <h3>No Premium Listings Found</h3>
                    <p>We couldn't find any properties matching your current criteria. Please broaden your search.</p>
                </div>
            </c:if>
        </div>
    </div>

</body>
</html>
