<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KHOJ | Your Premium Real Estate & Travel Portal</title>
    
    <!-- Google Fonts & FontAwesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:ital,wght@0,400;0,600;0,700;0,800;1,400&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-primary: #FAF9F6;
            --bg-secondary: #F3EFE8;
            --hero-overlay: #1C1917;
            --accent-gold: #C9A96E;
            --text-primary: #1C1917;
            --text-secondary: #6B6560;
            --card-surface: #FFFFFF;
            --card-border: #EDE9E3;
            --transition-premium: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            font-weight: 400;
        }

        h1, h2, h3, .logo {
            font-family: 'Playfair Display', serif;
        }

        .container { 
            max-width: 1200px; 
            margin: 0 auto; 
            padding: 0 20px; 
        }

        .section-padding {
            padding: 80px 0;
        }

        /* Header / Navbar */
        header {
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
            padding: 20px 0;
            transition: var(--transition-premium);
            background: transparent;
        }

        header.scrolled {
            background: var(--hero-overlay);
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--accent-gold);
            cursor: pointer;
            text-decoration: none;
            letter-spacing: 1px;
        }

        .nav-actions {
            display: flex;
            gap: 30px;
            align-items: center;
        }

        .nav-link {
            color: white;
            text-decoration: none;
            font-weight: 400;
            font-size: 1rem;
            transition: var(--transition-premium);
            font-family: 'Inter', sans-serif;
        }

        .nav-link:hover {
            color: var(--accent-gold);
        }

        .btn-signin {
            background: var(--accent-gold);
            color: var(--text-primary);
            padding: 10px 28px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1rem;
            transition: var(--transition-premium);
            font-family: 'Inter', sans-serif;
        }

        .btn-signin:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(201, 169, 110, 0.4);
        }

        .user-badge {
            color: white;
            font-weight: 400;
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255,255,255,0.1);
            padding: 8px 15px;
            border-radius: 50px;
            font-family: 'Inter', sans-serif;
        }

        /* Hero Section */
        .hero {
            position: relative;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-image: linear-gradient(to bottom, rgba(28,25,23,0.3) 0%, rgba(28,25,23,0.6) 100%), url('https://images.unsplash.com/photo-1571896349842-33c89424de2d?auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            text-align: center;
            color: white;
            padding-top: 80px; /* Offset for header */
        }

        .hero-content {
            max-width: 900px;
            z-index: 2;
            display: flex;
            flex-direction: column;
            align-items: center;
            width: 100%;
            padding: 0 20px;
        }

        .hero h1 {
            font-size: 72px;
            font-weight: 700;
            margin: 0 0 20px;
            letter-spacing: -1px;
            color: white;
            animation: fadeUp 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
            opacity: 0;
            transform: translateY(20px);
        }

        .hero p {
            font-size: 1.2rem;
            font-weight: 400;
            color: rgba(255,255,255,0.85);
            margin: 0 0 50px;
            animation: fadeUp 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94) 0.2s forwards;
            opacity: 0;
            transform: translateY(20px);
            font-family: 'Inter', sans-serif;
        }

        @keyframes fadeUp {
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Search Box */
        .search-box {
            background: rgba(255,255,255,0.95);
            backdrop-filter: blur(12px);
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            max-width: 760px;
            width: 100%;
            display: flex;
            padding: 12px;
            gap: 10px;
            animation: fadeUp 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94) 0.4s forwards;
            opacity: 0;
            transform: translateY(20px);
        }

        .search-item {
            flex: 1;
            display: flex;
            flex-direction: column;
            padding: 10px 15px;
            border-right: 1px solid rgba(0,0,0,0.08);
            text-align: left;
        }

        .search-item:last-of-type {
            border-right: none;
        }

        .search-item label {
            font-size: 10px;
            font-weight: 600;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 5px;
            font-family: 'Inter', sans-serif;
        }

        .search-item input, .search-item select {
            border: none;
            border-bottom: 2px solid transparent;
            font-size: 1rem;
            font-weight: 600;
            outline: none;
            background: transparent;
            color: var(--text-primary);
            font-family: 'Inter', sans-serif;
            padding: 4px 0;
            transition: var(--transition-premium);
        }

        .search-item input:focus, .search-item select:focus {
            border-bottom: 2px solid var(--accent-gold);
        }

        .btn-search {
            background: var(--accent-gold);
            color: var(--text-primary);
            border: none;
            padding: 0 35px;
            font-size: 1rem;
            font-weight: 800;
            border-radius: 10px;
            cursor: pointer;
            transition: var(--transition-premium);
            font-family: 'Inter', sans-serif;
        }

        .btn-search:hover {
            background: #b5955c;
        }

        /* Swimlane Common */
        .section-header { margin-bottom: 40px; }
        .section-header h2 { font-size: 2.2rem; font-weight: 600; color: var(--text-primary); margin: 0 0 8px; }
        .section-subtitle { font-family: 'Inter', sans-serif; font-style: italic; color: var(--text-secondary); margin: 0; font-size: 1rem; }
        
        .swimlane-container {
            display: flex;
            flex-wrap: nowrap;
            overflow-x: auto;
            gap: 24px;
            padding: 20px 0 40px;
            scrollbar-width: none;
            -ms-overflow-style: none;
            scroll-behavior: smooth;
        }
        .swimlane-container::-webkit-scrollbar { display: none; }

        /* Vibe Card */
        .vibe-card {
            min-width: 240px;
            height: 340px;
            position: relative;
            border-radius: 20px;
            overflow: hidden;
            cursor: pointer;
            transition: var(--transition-premium);
            box-shadow: 0 4px 24px rgba(0,0,0,0.06);
        }
        
        .vibe-card:hover { transform: translateY(-8px); box-shadow: 0 15px 35px rgba(0,0,0,0.1); }
        .vibe-card img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; }
        .vibe-card:hover img { transform: scale(1.05); }
        
        .vibe-overlay {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to bottom, transparent 30%, rgba(28,25,23,0.8) 100%);
        }

        .vibe-card .vibe-name {
            position: absolute;
            bottom: 25px;
            left: 25px;
            color: white;
            font-size: 1.6rem;
            font-weight: 600;
            font-family: 'Playfair Display', serif;
        }

        /* Premium Card */
        .premium-section {
            background: var(--bg-secondary);
        }
        
        .premium-card {
            min-width: 320px;
            background: var(--card-surface);
            border-radius: 16px;
            border: 1px solid var(--card-border);
            overflow: hidden;
            box-shadow: 0 4px 24px rgba(0,0,0,0.06);
            transition: var(--transition-premium);
            position: relative;
        }
        
        .premium-card:hover { transform: translateY(-8px); box-shadow: 0 15px 35px rgba(0,0,0,0.1); }
        
        .card-img-wrapper {
            height: 200px;
            width: 100%;
            overflow: hidden;
        }
        
        .card-img-wrapper img { 
            width: 100%; 
            height: 100%; 
            object-fit: cover; 
            border-radius: 14px 14px 0 0;
            transition: transform 0.6s ease;
        }
        
        .premium-card:hover .card-img-wrapper img {
            transform: scale(1.05);
        }
        
        .card-content {
            padding: 24px;
        }

        .card-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 12px;
        }

        .type-badge {
            background: var(--card-border);
            color: var(--text-secondary);
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            padding: 4px 10px;
            border-radius: 4px;
            letter-spacing: 0.5px;
            font-family: 'Inter', sans-serif;
        }

        .verified-badge { 
            color: var(--accent-gold); 
            font-weight: 600; 
            font-size: 0.85rem; 
            display: flex; 
            align-items: center; 
            gap: 5px; 
            font-family: 'Inter', sans-serif;
        }

        .card-title { 
            font-family: 'Inter', sans-serif;
            font-size: 1.1rem; 
            font-weight: 700; 
            color: var(--text-primary);
            margin: 0 0 8px; 
            white-space: nowrap; 
            overflow: hidden; 
            text-overflow: ellipsis; 
        }
        
        .card-location { 
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem; 
            color: var(--text-secondary); 
            margin-bottom: 20px; 
            display: flex; 
            align-items: center; 
            gap: 6px; 
        }
        
        .card-price { 
            font-family: 'Inter', sans-serif;
            font-size: 1.3rem; 
            font-weight: 800; 
            color: var(--accent-gold); 
            display: flex;
            align-items: baseline;
            gap: 6px;
        }
        
        .card-price span { 
            font-size: 0.85rem; 
            font-weight: 400; 
            color: var(--text-secondary); 
        }

        /* Type Pill */
        .type-pill {
            min-width: 150px;
            background: var(--card-surface);
            padding: 28px 20px;
            border-radius: 16px;
            text-align: center;
            box-shadow: 0 4px 24px rgba(0,0,0,0.06);
            border: 1px solid var(--card-border);
            cursor: pointer;
            transition: var(--transition-premium);
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 15px;
        }
        
        .type-pill i { 
            font-size: 2rem; 
            color: var(--accent-gold); 
            transition: var(--transition-premium);
        }
        
        .type-pill span { 
            font-family: 'Inter', sans-serif;
            font-weight: 600; 
            font-size: 0.9rem; 
            color: var(--text-primary);
            transition: var(--transition-premium);
        }

        .type-pill:hover { 
            background: var(--hero-overlay); 
        }
        
        .type-pill:hover i, .type-pill:hover span {
            color: white;
        }

        /* Trust Banner */
        .trust-banner {
            background: var(--hero-overlay);
            padding: 60px 0;
            color: white;
        }
        
        .trust-content {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            gap: 30px;
            text-align: center;
        }
        
        .trust-item {
            flex: 1;
            min-width: 250px;
        }
        
        .trust-item i {
            color: var(--accent-gold);
            font-size: 2rem;
            margin-bottom: 15px;
        }
        
        .trust-item h3 {
            font-family: 'Inter', sans-serif;
            font-weight: 700;
            font-size: 1.1rem;
            margin: 0 0 8px;
            color: white;
        }
        
        .trust-item p {
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
            color: rgba(255,255,255,0.6);
            margin: 0;
        }

    </style>
</head>
<body>

    <!-- Header Area -->
    <header id="main-header">
        <div class="container header-content">
            <a href="home" class="logo">KHOJ</a>
            <div class="nav-actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="my-bookings" class="nav-link">My Bookings</a>
                        <div class="user-badge">
                            <i class="fa-solid fa-circle-user" style="color: var(--accent-gold); font-size: 1.2rem;"></i>
                            ${sessionScope.user.fullName}
                        </div>
                        <a href="LogoutServlet" class="nav-link" style="color: rgba(255,255,255,0.7);">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="#" class="nav-link">List your property</a>
                        <a href="LoginServlet" class="btn-signin">Sign In</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Find Your Perfect Stay in Nepal</h1>
            <p>Discover verified homes, apartments, and villas — from Kathmandu to Pokhara.</p>
            
            <form action="search" method="GET" class="search-box">
                <div class="search-item">
                    <label>Destination</label>
                    <input type="text" name="location" placeholder="Where are you going?" required>
                </div>
                <div class="search-item">
                    <label>Property Type</label>
                    <select name="type">
                        <option value="">All Types</option>
                        <option value="Apartment">Apartment</option>
                        <option value="Hostel">Hostel</option>
                        <option value="Hotel">Hotel</option>
                        <option value="Villa">Villa</option>
                    </select>
                </div>
                <div class="search-item">
                    <label>Payment Model</label>
                    <select name="priceModel">
                        <option value="Monthly">Monthly Rent</option>
                        <option value="Daily">Daily Rate</option>
                    </select>
                </div>
                <button type="submit" class="btn-search">Search</button>
            </form>
        </div>
    </section>

    <!-- Section 1: Discover Your Vibe -->
    <section class="section-padding" style="background: var(--bg-primary);">
        <div class="container">
            <div class="section-header">
                <h2>Discover Your Vibe</h2>
                <p class="section-subtitle">Explore Nepal by mood</p>
            </div>
            <div class="swimlane-container">
                <c:forEach items="${vibes}" var="vibe">
                    <div class="vibe-card" onclick="window.location.href='search?theme=${vibe.name}'">
                        <img src="${vibe.imageUrl}" alt="${vibe.name}">
                        <div class="vibe-overlay"></div>
                        <div class="vibe-name">${vibe.name}</div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Section 2: Verified Premium Stays -->
    <section class="section-padding premium-section">
        <div class="container">
            <div class="section-header">
                <h2>Verified Premium Stays</h2>
            </div>
            <div class="swimlane-container">
                <c:forEach items="${verifiedProperties}" var="p">
                    <div class="premium-card" onclick="window.location.href='property-detail?id=${p.propertyId}'" style="cursor: pointer;">
                        <div class="card-img-wrapper">
                            <img src="${not empty p.imageUrls ? p.imageUrls[0] : 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80'}" alt="${p.title}">
                        </div>
                        <div class="card-content">
                            <div class="card-meta">
                                <span class="type-badge">${p.propertyType}</span>
                                <span class="verified-badge"><i class="fa-solid fa-shield-halved"></i> Verified</span>
                            </div>
                            <h3 class="card-title">${p.title}</h3>
                            <p class="card-location"><i class="fa-solid fa-circle" style="font-size: 6px;"></i> ${p.neighborhoodName}, ${p.cityName}</p>
                            <div class="card-price">Rs. ${p.price} <span>/ ${p.priceModel}</span></div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Section 3: Browse by Property Type -->
    <section class="section-padding" style="background: var(--bg-primary);">
        <div class="container">
            <div class="section-header">
                <h2>Browse by Property Type</h2>
            </div>
            <div class="swimlane-container">
                <c:forEach items="${propertyTypes}" var="type">
                    <div class="type-pill" onclick="window.location.href='search?type=${type.name}'">
                        <c:choose>
                            <c:when test="${type.name == 'Apartment'}"><i class="fa-solid fa-building"></i></c:when>
                            <c:when test="${type.name == 'Hostel'}"><i class="fa-solid fa-bed"></i></c:when>
                            <c:when test="${type.name == 'Hotel'}"><i class="fa-solid fa-hotel"></i></c:when>
                            <c:when test="${type.name == 'Villa'}"><i class="fa-solid fa-house-chimney"></i></c:when>
                            <c:otherwise><i class="fa-solid fa-house"></i></c:otherwise>
                        </c:choose>
                        <span>${type.name}</span>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Trust Banner -->
    <section class="trust-banner">
        <div class="container trust-content">
            <div class="trust-item">
                <i class="fa-solid fa-shield-halved"></i>
                <h3>10,000+ Verified Listings</h3>
                <p>Every property manually reviewed</p>
            </div>
            <div class="trust-item">
                <i class="fa-solid fa-tags"></i>
                <h3>Zero Hidden Fees</h3>
                <p>Transparent pricing, always</p>
            </div>
            <div class="trust-item">
                <i class="fa-solid fa-star"></i>
                <h3>Nepal's #1 Rental Platform</h3>
                <p>Trusted by students and landlords</p>
            </div>
        </div>
    </section>

    <!-- Mega Footer Include -->
    <%@ include file="footer.jsp" %>

    <script>
        // Navbar scroll effect
        window.addEventListener('scroll', () => {
            const header = document.getElementById('main-header');
            if (window.scrollY > 50) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });
    </script>
</body>
</html>