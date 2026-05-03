<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${room.title} | KHOJ</title>
    <meta name="description" content="${room.description}">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-primary:       #FAF9F6;
            --nav-bg:           #1C1917;
            --accent-gold:      #C9A96E;
            --accent-gold-dark: #B8935A;
            --text-primary:     #1C1917;
            --text-secondary:   #6B6560;
            --card-surface:     #FFFFFF;
            --card-border:      #EDE9E3;
            --success-green:    #2D6A4F;
            --success-bg:       #D8F3DC;
            --transition:       all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            min-height: 100vh;
        }

        h1, h2, h3, .brand-name { font-family: 'Playfair Display', serif; }

        /* ── TOP NAVIGATION ── */
        nav {
            background: var(--nav-bg);
            position: sticky;
            top: 0;
            z-index: 1000;
            box-shadow: 0 2px 20px rgba(0,0,0,0.3);
        }

        .nav-inner {
            max-width: 1240px;
            margin: 0 auto;
            padding: 0 32px;
            height: 68px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .brand-name {
            font-size: 1.7rem;
            color: var(--accent-gold);
            letter-spacing: 0.5px;
            text-decoration: none;
            cursor: pointer;
        }

        .nav-links {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .nav-link {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            padding: 9px 18px;
            border-radius: 8px;
            text-decoration: none;
            color: rgba(255,255,255,0.65);
            font-size: 0.9rem;
            font-weight: 500;
            transition: var(--transition);
        }

        .nav-link:hover {
            color: #fff;
            background: rgba(255,255,255,0.08);
        }

        .nav-link-gold {
            background: var(--accent-gold);
            color: var(--text-primary) !important;
            font-weight: 700;
        }

        .nav-link-gold:hover {
            background: var(--accent-gold-dark) !important;
            color: var(--text-primary) !important;
        }

        /* ── PAGE LAYOUT ── */
        .page-wrapper {
            max-width: 1240px;
            margin: 0 auto;
            padding: 48px 32px 80px;
        }

        /* Breadcrumb */
        .breadcrumb {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-bottom: 32px;
        }

        .breadcrumb a {
            color: var(--text-secondary);
            text-decoration: none;
            transition: color 0.2s;
        }

        .breadcrumb a:hover { color: var(--accent-gold); }
        .breadcrumb i { font-size: 0.7rem; }

        /* ── MAIN GRID ── */
        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 380px;
            gap: 40px;
            align-items: start;
        }

        /* ── HERO IMAGE ── */
        .hero-image-wrap {
            position: relative;
            border-radius: 20px;
            overflow: hidden;
            aspect-ratio: 16/9;
            background: var(--card-border);
            box-shadow: 0 8px 40px rgba(0,0,0,0.10);
        }

        .hero-image-wrap img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.6s ease;
        }

        .hero-image-wrap:hover img { transform: scale(1.03); }

        .img-badge {
            position: absolute;
            bottom: 20px;
            left: 20px;
            background: rgba(255,255,255,0.92);
            backdrop-filter: blur(8px);
            padding: 8px 18px;
            border-radius: 30px;
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--text-primary);
            display: flex;
            align-items: center;
            gap: 7px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.12);
        }

        .img-badge i { color: var(--accent-gold); }

        /* ── PROPERTY INFO BLOCK ── */
        .property-info { margin-top: 28px; }

        .tag-row {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-bottom: 16px;
        }

        .tag {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 5px 14px;
            border-radius: 30px;
            font-size: 0.78rem;
            font-weight: 700;
            letter-spacing: 0.4px;
            text-transform: uppercase;
        }

        .tag-type {
            background: #F5F0E8;
            color: var(--accent-gold-dark);
            border: 1px solid #E8D9BF;
        }

        .tag-verified {
            background: var(--success-bg);
            color: var(--success-green);
            border: 1px solid #A8DABC;
        }

        .tag-furnish {
            background: #F0F4FF;
            color: #3B5BDB;
            border: 1px solid #BAC8FF;
        }

        .property-title {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--text-primary);
            line-height: 1.25;
            margin-bottom: 10px;
        }

        .property-location {
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--text-secondary);
            font-size: 1rem;
            margin-bottom: 32px;
        }

        .property-location i { color: var(--accent-gold); }

        /* ── STATS ROW ── */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 32px;
        }

        .stat-card {
            background: var(--card-surface);
            border: 1px solid var(--card-border);
            border-radius: 14px;
            padding: 20px;
            text-align: center;
            transition: var(--transition);
        }

        .stat-card:hover {
            border-color: var(--accent-gold);
            box-shadow: 0 4px 20px rgba(201,169,110,0.12);
            transform: translateY(-2px);
        }

        .stat-card i {
            font-size: 1.4rem;
            color: var(--accent-gold);
            margin-bottom: 8px;
        }

        .stat-label {
            font-size: 0.72rem;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.6px;
            margin-bottom: 4px;
        }

        .stat-value {
            font-size: 0.95rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        /* ── DESCRIPTION CARD ── */
        .section-card {
            background: var(--card-surface);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 28px 32px;
            margin-bottom: 20px;
        }

        .section-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 16px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--card-border);
        }

        .description-text {
            line-height: 1.8;
            color: var(--text-secondary);
            font-size: 0.98rem;
        }

        /* ── AMENITIES ── */
        .amenity-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }

        .amenity-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 0.92rem;
            color: var(--text-primary);
            font-weight: 500;
        }

        .amenity-item i {
            width: 28px;
            height: 28px;
            background: #F5F0E8;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--accent-gold);
            font-size: 0.75rem;
            flex-shrink: 0;
        }

        .empty-amenity {
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-style: italic;
        }

        /* ── BOOKING SIDEBAR ── */
        .booking-sidebar {
            position: sticky;
            top: 88px;
        }

        .booking-card {
            background: var(--card-surface);
            border: 1px solid var(--card-border);
            border-radius: 20px;
            padding: 32px;
            box-shadow: 0 8px 40px rgba(0,0,0,0.07);
        }

        .price-display {
            margin-bottom: 6px;
        }

        .price-amount {
            font-family: 'Playfair Display', serif;
            font-size: 2.4rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        .price-unit {
            font-size: 1rem;
            color: var(--text-secondary);
            font-weight: 400;
            margin-left: 4px;
        }

        .price-note {
            font-size: 0.85rem;
            color: var(--text-secondary);
            margin-bottom: 24px;
        }

        .booking-divider {
            border: none;
            border-top: 1px solid var(--card-border);
            margin: 20px 0;
        }

        .booking-meta {
            display: flex;
            flex-direction: column;
            gap: 14px;
            margin-bottom: 28px;
        }

        .meta-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.92rem;
        }

        .meta-label { color: var(--text-secondary); }

        .meta-value {
            font-weight: 700;
            color: var(--text-primary);
        }

        .meta-value-green {
            font-weight: 700;
            color: var(--success-green);
        }

        /* ── LANDLORD PILL ── */
        .landlord-pill {
            display: flex;
            align-items: center;
            gap: 12px;
            background: #F5F0E8;
            border-radius: 12px;
            padding: 14px 16px;
            margin-bottom: 24px;
        }

        .landlord-avatar {
            width: 38px;
            height: 38px;
            border-radius: 50%;
            background: var(--accent-gold);
            color: var(--text-primary);
            font-weight: 800;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.95rem;
            flex-shrink: 0;
        }

        .landlord-info-label {
            font-size: 0.72rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .landlord-name {
            font-size: 0.92rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        /* ── APPLY BUTTON ── */
        .btn-apply {
            width: 100%;
            padding: 16px;
            background: var(--accent-gold);
            color: var(--text-primary);
            border: none;
            border-radius: 12px;
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            font-weight: 800;
            cursor: pointer;
            letter-spacing: 0.3px;
            transition: var(--transition);
            box-shadow: 0 4px 20px rgba(201,169,110,0.35);
        }

        .btn-apply:hover {
            background: var(--accent-gold-dark);
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(201,169,110,0.45);
        }

        .btn-apply:active { transform: translateY(0); }

        .secure-note {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 16px;
            font-size: 0.8rem;
            color: var(--text-secondary);
        }

        .secure-note i { color: var(--success-green); }

        /* ── GOLD ACCENT LINE on booking card top ── */
        .booking-card::before {
            content: '';
            display: block;
            height: 3px;
            background: linear-gradient(90deg, var(--accent-gold), var(--accent-gold-dark));
            border-radius: 20px 20px 0 0;
            margin: -32px -32px 28px;
        }
    </style>
</head>
<body>

<!-- TOP NAVIGATION -->
<nav>
    <div class="nav-inner">
        <a href="${pageContext.request.contextPath}/home" class="brand-name">KHOJ</a>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/search" class="nav-link">
                <i class="fa-solid fa-arrow-left"></i> Back to Discovery
            </a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/my-bookings" class="nav-link">
                        <i class="fa-solid fa-calendar-check"></i> My Bookings
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/views/auth/login.jsp" class="nav-link nav-link-gold">
                        <i class="fa-solid fa-right-to-bracket"></i> Sign In
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<div class="page-wrapper">

    <!-- BREADCRUMB -->
    <div class="breadcrumb">
        <a href="${pageContext.request.contextPath}/home">Home</a>
        <i class="fa-solid fa-chevron-right"></i>
        <a href="${pageContext.request.contextPath}/search">Discover</a>
        <i class="fa-solid fa-chevron-right"></i>
        <span>${room.title}</span>
    </div>

    <div class="detail-grid">

        <!-- LEFT COLUMN -->
        <div>
            <!-- Hero Image -->
            <div class="hero-image-wrap">
                <img
                        src="${not empty room.imageUrls ? room.imageUrls[0] : 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1200&q=80'}"
                        alt="${room.title}">
                <div class="img-badge">
                    <i class="fa-solid fa-circle-check"></i>
                    Verified Property Image
                </div>
            </div>

            <!-- Property Info -->
            <div class="property-info">
                <div class="tag-row">
                        <span class="tag tag-type">
                            <i class="fa-solid fa-building"></i> ${room.propertyType}
                        </span>
                    <c:if test="${room.verified}">
                            <span class="tag tag-verified">
                                <i class="fa-solid fa-shield-check"></i> Verified
                            </span>
                    </c:if>
                    <c:if test="${not empty room.furnishingStatus}">
                            <span class="tag tag-furnish">
                                <i class="fa-solid fa-couch"></i> ${room.furnishingStatus}
                            </span>
                    </c:if>
                </div>

                <h1 class="property-title">${room.title}</h1>

                <div class="property-location">
                    <i class="fa-solid fa-location-dot"></i>
                    ${room.neighborhoodName}, ${room.cityName}
                    <c:if test="${not empty room.themeName}">
                        &nbsp;&middot;&nbsp; ${room.themeName}
                    </c:if>
                </div>

                <!-- Stats Row -->
                <div class="stats-row">
                    <div class="stat-card">
                        <i class="fa-solid fa-bed"></i>
                        <div class="stat-label">Type</div>
                        <div class="stat-value">${room.propertyType}</div>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-tag"></i>
                        <div class="stat-label">Price Model</div>
                        <div class="stat-value">${room.priceModel}</div>
                    </div>
                    <div class="stat-card">
                        <i class="fa-solid fa-shield-halved"></i>
                        <div class="stat-label">Status</div>
                        <div class="stat-value">
                            <c:choose>
                                <c:when test="${room.verified}">Verified</c:when>
                                <c:otherwise>Pending Review</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Description -->
                <div class="section-card">
                    <div class="section-title">About This Property</div>
                    <p class="description-text">
                        ${not empty room.description ? room.description : 'Welcome to this premium property listed on KHOJ. This space offers a comfortable and secure environment, perfectly suited for students or working professionals looking for a high-quality living experience.'}
                    </p>
                </div>

                <!-- Amenities -->
                <div class="section-card">
                    <div class="section-title">Amenities</div>
                    <c:choose>
                        <c:when test="${not empty room.amenities}">
                            <div class="amenity-grid">
                                <c:forEach items="${room.amenities}" var="amenity">
                                    <div class="amenity-item">
                                        <i class="fa-solid fa-check"></i>
                                            ${amenity}
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <p class="empty-amenity">Amenity details not listed. Contact the landlord for more information.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- RIGHT COLUMN — BOOKING CARD -->
        <div class="booking-sidebar">
            <div class="booking-card">

                <!-- Price -->
                <div class="price-display">
                    <span class="price-amount">Rs. ${room.price}</span>
                    <span class="price-unit">/ ${room.priceModel}</span>
                </div>
                <p class="price-note">Inclusive of standard charges</p>

                <!-- Landlord -->
                <c:if test="${not empty room.landlordName}">
                    <div class="landlord-pill">
                        <div class="landlord-avatar">
                                ${fn:substring(room.landlordName, 0, 1)}
                        </div>
                        <div>
                            <div class="landlord-info-label">Listed by</div>
                            <div class="landlord-name">${room.landlordName}</div>
                        </div>
                    </div>
                </c:if>

                <hr class="booking-divider">

                <!-- Meta rows -->
                <div class="booking-meta">
                    <div class="meta-row">
                        <span class="meta-label">Service Fee</span>
                        <span class="meta-value-green">Free for Students</span>
                    </div>
                    <div class="meta-row">
                        <span class="meta-label">Furnishing</span>
                        <span class="meta-value">${not empty room.furnishingStatus ? room.furnishingStatus : 'N/A'}</span>
                    </div>
                    <div class="meta-row">
                        <span class="meta-label">Refund Policy</span>
                        <span class="meta-value">Flexible</span>
                    </div>
                    <div class="meta-row">
                        <span class="meta-label">Location</span>
                        <span class="meta-value">${room.cityName}</span>
                    </div>
                </div>

                <!-- CTA -->
                <form action="${pageContext.request.contextPath}/ApplyServlet" method="post">
                    <input type="hidden" name="propertyId" value="${room.propertyId}">
                    <button type="submit" class="btn-apply" id="applyBtn">
                        <i class="fa-solid fa-paper-plane" style="margin-right:8px;"></i>
                        Apply to Rent Now
                    </button>
                </form>

                <div class="secure-note">
                    <i class="fa-solid fa-lock"></i>
                    Secure Application via KHOJ
                </div>
            </div>
        </div>

    </div>
</div>

</body>
</html>