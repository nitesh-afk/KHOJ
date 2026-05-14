<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KHOJ | Exceptional Living Across Nepal</title>
    
    <!-- Modern Typography & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:wght@700;800;900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Animate.css for quick entrance effects -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

    <style>
        :root {
            --bg-primary: #FAF9F6;
            --bg-secondary: #F3EFE8;
            --hero-overlay: #1C1917;
            --accent: #C9A96E;
            --accent-soft: rgba(201, 169, 110, 0.15);
            --text-main: #1C1917;
            --text-muted: #6B6560;
            --white: #FFFFFF;
            --glass: rgba(255, 255, 255, 0.85);
            --glass-border: rgba(255, 255, 255, 0.3);
            --shadow-sm: 0 4px 12px rgba(0,0,0,0.03);
            --shadow-md: 0 12px 30px rgba(0,0,0,0.06);
            --shadow-lg: 0 25px 60px rgba(0,0,0,0.12);
            --radius-sm: 12px;
            --radius-md: 20px;
            --radius-lg: 32px;
            --font-main: 'Plus Jakarta Sans', sans-serif;
            --font-display: 'Playfair Display', serif;
            --transition: all 0.5s cubic-bezier(0.22, 1, 0.36, 1);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        html { scroll-behavior: smooth; }
        
        body {
            font-family: var(--font-main);
            background-color: var(--bg-primary);
            color: var(--text-main);
            overflow-x: hidden;
            line-height: 1.6;
        }

        /* Utility Classes */
        .container { max-width: 1300px; margin: 0 auto; padding: 0 30px; }
        .section-padding { padding: 120px 0; }
        .reveal { opacity: 0; transform: translateY(30px); transition: var(--transition); }
        .reveal.active { opacity: 1; transform: translateY(0); }

        /* Hero Section - The Masterpiece */
        .hero {
            height: 100vh;
            min-height: 850px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
            background: #000;
            overflow: hidden;
        }

        .hero-bg {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background-image: linear-gradient(to bottom, rgba(15,14,12,0.4), rgba(15,14,12,0.7)), 
                              url('https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            transform: scale(1.1);
            animation: panHero 20s infinite alternate ease-in-out;
        }

        @keyframes panHero {
            from { transform: scale(1.1) translateX(0); }
            to { transform: scale(1.15) translateX(-2%); }
        }

        .hero-content {
            position: relative;
            z-index: 10;
            text-align: center;
            color: var(--white);
            max-width: 1000px;
            padding: 0 20px;
        }

        .hero-tag {
            font-size: 0.85rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 4px;
            color: var(--accent);
            margin-bottom: 24px;
            display: inline-block;
            animation: fadeInDown 1s ease both;
        }

        .hero h1 {
            font-family: var(--font-display);
            font-size: clamp(3.5rem, 8vw, 6rem);
            line-height: 1.1;
            margin-bottom: 30px;
            letter-spacing: -2px;
            animation: fadeInUp 1s 0.2s ease both;
        }

        .hero p {
            font-size: clamp(1.1rem, 2vw, 1.35rem);
            color: rgba(255,255,255,0.8);
            margin-bottom: 60px;
            font-weight: 400;
            max-width: 700px;
            margin-left: auto;
            margin-right: auto;
            animation: fadeInUp 1s 0.4s ease both;
        }

        /* Search Bar - Modern Glassmorphism */
        .search-container {
            width: 100%;
            max-width: 900px;
            margin: 0 auto;
            background: var(--glass);
            backdrop-filter: blur(20px);
            padding: 12px;
            border-radius: var(--radius-lg);
            border: 1px solid var(--glass-border);
            box-shadow: var(--shadow-lg);
            display: flex;
            align-items: center;
            gap: 10px;
            animation: fadeInUp 1s 0.6s ease both;
        }

        .search-group {
            flex: 1;
            display: flex;
            flex-direction: column;
            text-align: left;
            padding: 12px 24px;
            border-radius: var(--radius-md);
            transition: var(--transition);
        }

        .search-group:hover { background: rgba(0,0,0,0.03); }

        .search-group:not(:last-child) { border-right: 1px solid rgba(0,0,0,0.08); }

        .search-group label {
            font-size: 0.65rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            margin-bottom: 6px;
        }

        .search-group input, .search-group select {
            border: none;
            background: transparent;
            font-family: var(--font-main);
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-main);
            outline: none;
            width: 100%;
        }

        .btn-search {
            background: var(--text-main);
            color: var(--white);
            width: 64px;
            height: 64px;
            border-radius: 50%;
            border: none;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            transition: var(--transition);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .btn-search:hover { transform: scale(1.05) rotate(90deg); background: var(--accent); color: var(--text-main); }

        /* Vibe Section - Bento Grid Style */
        .section-header { margin-bottom: 60px; text-align: center; }
        .section-header h2 { 
            font-family: var(--font-display); 
            font-size: 3rem; 
            margin-bottom: 16px; 
            letter-spacing: -1px;
        }
        .section-header p { color: var(--text-muted); font-size: 1.1rem; }

        .vibe-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            grid-auto-rows: 400px;
            gap: 24px;
        }

        .vibe-card {
            position: relative;
            border-radius: var(--radius-md);
            overflow: hidden;
            cursor: pointer;
            transition: var(--transition);
        }

        .vibe-card:nth-child(1) { grid-column: span 2; }
        .vibe-card:nth-child(2) { grid-column: span 2; }
        .vibe-card:nth-child(5) { grid-column: span 2; }

        .vibe-card img { width: 100%; height: 100%; object-fit: cover; transition: var(--transition); }
        
        .vibe-card:hover img { transform: scale(1.1); }

        .vibe-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to bottom, transparent 40%, rgba(0,0,0,0.8));
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 40px;
            transition: var(--transition);
        }

        .vibe-card:hover .vibe-overlay { background: linear-gradient(to bottom, rgba(201, 169, 110, 0.2) 0%, rgba(0,0,0,0.9)); }

        .vibe-name { color: var(--white); font-family: var(--font-display); font-size: 2.2rem; line-height: 1; }
        .vibe-count { color: var(--accent); font-weight: 700; font-size: 0.85rem; margin-top: 10px; opacity: 0; transform: translateY(10px); transition: var(--transition); }
        .vibe-card:hover .vibe-count { opacity: 1; transform: translateY(0); }

        /* Premium Stays Section */
        .premium-bg { background: var(--bg-secondary); }

        .premium-scroll {
            display: flex;
            gap: 30px;
            overflow-x: auto;
            padding: 20px 0 60px;
            scrollbar-width: none;
            -ms-overflow-style: none;
        }
        .premium-scroll::-webkit-scrollbar { display: none; }

        .stay-card {
            min-width: 420px;
            background: var(--white);
            border-radius: var(--radius-md);
            padding: 12px;
            transition: var(--transition);
            border: 1px solid rgba(0,0,0,0.03);
            box-shadow: var(--shadow-sm);
        }

        .stay-card:hover { transform: translateY(-10px); box-shadow: var(--shadow-lg); }

        .stay-img {
            height: 280px;
            width: 100%;
            border-radius: 16px;
            overflow: hidden;
            position: relative;
        }

        .stay-img img { width: 100%; height: 100%; object-fit: cover; transition: var(--transition); }
        .stay-card:hover .stay-img img { transform: scale(1.08); }

        .stay-badge {
            position: absolute;
            top: 20px; right: 20px;
            background: var(--glass);
            backdrop-filter: blur(10px);
            padding: 8px 16px;
            border-radius: 100px;
            font-size: 0.7rem;
            font-weight: 800;
            color: var(--text-main);
            text-transform: uppercase;
            letter-spacing: 1px;
            box-shadow: var(--shadow-sm);
        }

        .stay-content { padding: 24px 12px; }

        .stay-meta { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
        
        .stay-rating { display: flex; align-items: center; gap: 6px; font-weight: 800; font-size: 0.9rem; }
        .stay-rating i { color: var(--accent); }

        .stay-verified { color: var(--accent); font-size: 0.75rem; font-weight: 700; display: flex; align-items: center; gap: 6px; }

        .stay-title { font-family: var(--font-display); font-size: 1.5rem; margin-bottom: 8px; color: var(--text-main); }
        .stay-loc { color: var(--text-muted); font-size: 0.9rem; display: flex; align-items: center; gap: 8px; margin-bottom: 24px; }

        .stay-footer { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid rgba(0,0,0,0.05); pt: 20px; }
        
        .stay-price { font-size: 1.4rem; font-weight: 800; }
        .stay-price span { font-size: 0.85rem; font-weight: 500; color: var(--text-muted); }

        .btn-view {
            padding: 12px 24px;
            border-radius: 12px;
            background: var(--bg-secondary);
            color: var(--text-main);
            text-decoration: none;
            font-weight: 700;
            font-size: 0.9rem;
            transition: var(--transition);
        }

        .stay-card:hover .btn-view { background: var(--text-main); color: var(--white); }

        /* Property Types */
        .type-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 30px;
        }

        .type-card {
            background: var(--white);
            padding: 50px 40px;
            border-radius: var(--radius-md);
            text-align: center;
            border: 1px solid rgba(0,0,0,0.03);
            transition: var(--transition);
            cursor: pointer;
        }

        .type-card:hover { 
            background: var(--text-main); 
            color: var(--white);
            transform: translateY(-5px);
        }

        .type-icon {
            width: 80px;
            height: 80px;
            background: var(--bg-secondary);
            border-radius: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 30px;
            font-size: 2rem;
            color: var(--accent);
            transition: var(--transition);
        }

        .type-card:hover .type-icon { background: rgba(255,255,255,0.1); color: var(--accent); }

        .type-card h3 { font-family: var(--font-display); font-size: 1.6rem; margin-bottom: 12px; }
        .type-card p { font-size: 0.9rem; color: var(--text-muted); transition: var(--transition); }
        .type-card:hover p { color: rgba(255,255,255,0.6); }

        /* Stats Section */
        .stats {
            background: var(--hero-overlay);
            padding: 100px 0;
            color: var(--white);
        }

        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 40px; text-align: center; }
        
        .stat-val { font-family: var(--font-display); font-size: 4rem; color: var(--accent); line-height: 1; margin-bottom: 10px; }
        .stat-label { font-size: 0.9rem; font-weight: 700; color: rgba(255,255,255,0.5); text-transform: uppercase; letter-spacing: 2px; }

        /* Floating Nav fix for Hero overlap */
        header { position: absolute !important; }

        /* Scroll Progress Bar */
        #scroll-progress {
            position: fixed;
            top: 0; left: 0; height: 3px;
            background: var(--accent);
            z-index: 2000;
            width: 0%;
            transition: width 0.1s;
        }

        @media (max-width: 1024px) {
            .vibe-grid { grid-template-columns: repeat(2, 1fr); }
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
            .stay-card { min-width: 350px; }
        }

        @media (max-width: 768px) {
            .search-container { flex-direction: column; padding: 20px; border-radius: 20px; }
            .search-group { border-right: none !important; border-bottom: 1px solid rgba(0,0,0,0.08); width: 100%; }
            .btn-search { width: 100%; border-radius: 12px; height: 56px; margin-top: 10px; }
            .hero h1 { font-size: 3rem; }
            .section-header h2 { font-size: 2.2rem; }
        }
    </style>
</head>
<body>

    <div id="scroll-progress"></div>

    <!-- Global Header -->
    <%@ include file="header.jsp" %>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-bg"></div>
        <div class="hero-content">
            <span class="hero-tag">Exclusively For You</span>
            <h1>Art of Living in the <br> Himalayas</h1>
            <p>Escape to Nepal's most refined collections of stays — from artistic lofts in Patan to panoramic villas in Sarangkot.</p>
            
            <form action="search" method="GET" class="search-container">
                <div class="search-group">
                    <label><i class="fa-solid fa-location-dot"></i> Destination</label>
                    <input type="text" name="location" placeholder="Where do you want to wake up?" required>
                </div>
                <div class="search-group">
                    <label><i class="fa-solid fa-house-user"></i> Stay Type</label>
                    <select name="type">
                        <option value="">All Architectures</option>
                        <option value="Apartment">Modern Apartment</option>
                        <option value="Hostel">Social Hostel</option>
                        <option value="Hotel">Luxury Hotel</option>
                        <option value="Villa">Private Villa</option>
                    </select>
                </div>
                <div class="search-group">
                    <label><i class="fa-solid fa-credit-card"></i> Duration</label>
                    <select name="priceModel">
                        <option value="Monthly">Monthly Residency</option>
                        <option value="Daily">Short Escape</option>
                    </select>
                </div>
                <button type="submit" class="btn-search">
                    <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>
        </div>
    </section>

    <!-- Discover Your Vibe -->
    <section class="section-padding">
        <div class="container">
            <div class="section-header reveal">
                <p style="text-transform: uppercase; letter-spacing: 3px; font-weight: 800; font-size: 0.75rem; color: var(--accent); margin-bottom: 12px;">Curated Collections</p>
                <h2>Choose Your Vibe</h2>
                <p>Tailored stays matched to your lifestyle and frequency.</p>
            </div>
            
            <div class="vibe-grid">
                <c:forEach items="${vibes}" var="vibe">
                    <div class="vibe-card reveal" onclick="window.location.href='search?theme=${vibe.name}'">
                        <c:set var="vibeFallback" value="https://images.unsplash.com/photo-1449824913935-59a10b8d2000?auto=format&fit=crop&w=800&q=80"/>
                        <c:if test="${vibe.themeId % 5 == 1}"><c:set var="vibeFallback" value="https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?auto=format&fit=crop&w=800&q=80"/></c:if>
                        <c:if test="${vibe.themeId % 5 == 2}"><c:set var="vibeFallback" value="https://images.unsplash.com/photo-1444723121867-7a241cacace9?auto=format&fit=crop&w=800&q=80"/></c:if>
                        <c:if test="${vibe.themeId % 5 == 3}"><c:set var="vibeFallback" value="https://images.unsplash.com/photo-1514565131-fce0801e5785?auto=format&fit=crop&w=800&q=80"/></c:if>
                        <c:if test="${vibe.themeId % 5 == 4}"><c:set var="vibeFallback" value="https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?auto=format&fit=crop&w=800&q=80"/></c:if>
                        <img src="${not empty vibe.imageUrl ? vibe.imageUrl : vibeFallback}" alt="${vibe.name}">
                        <div class="vibe-overlay">
                            <span class="vibe-name">${vibe.name}</span>
                            <span class="vibe-count">View Collection <i class="fa-solid fa-chevron-right" style="font-size: 0.6rem;"></i></span>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Verified Stays Section -->
    <section class="section-padding premium-bg">
        <div class="container">
            <div class="section-header reveal">
                <p style="text-transform: uppercase; letter-spacing: 3px; font-weight: 800; font-size: 0.75rem; color: var(--accent); margin-bottom: 12px;">Trust & Excellence</p>
                <h2>Premium Verified Homes</h2>
                <p>Every listing is manually inspected for safety, quality, and soul.</p>
            </div>
            
            <div class="premium-scroll reveal">
                <c:forEach items="${verifiedProperties}" var="p">
                    <div class="stay-card" onclick="window.location.href='property-detail?id=${p.propertyId}'">
                        <div class="stay-img">
                            <c:set var="fallbackImg" value="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80"/>
                            <c:choose>
                                <c:when test="${p.propertyId % 8 == 1}"><c:set var="fallbackImg" value="https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80"/></c:when>
                                <c:when test="${p.propertyId % 8 == 2}"><c:set var="fallbackImg" value="https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=800&q=80"/></c:when>
                                <c:when test="${p.propertyId % 8 == 3}"><c:set var="fallbackImg" value="https://images.unsplash.com/photo-1600607687940-477a63739903?auto=format&fit=crop&w=800&q=80"/></c:when>
                                <c:when test="${p.propertyId % 8 == 4}"><c:set var="fallbackImg" value="https://images.unsplash.com/photo-1600566753190-17f0bb2a6c3e?auto=format&fit=crop&w=800&q=80"/></c:when>
                                <c:when test="${p.propertyId % 8 == 5}"><c:set var="fallbackImg" value="https://images.unsplash.com/photo-1600585154526-990dcea4db0d?auto=format&fit=crop&w=800&q=80"/></c:when>
                                <c:when test="${p.propertyId % 8 == 6}"><c:set var="fallbackImg" value="https://images.unsplash.com/photo-1600573472591-ee6b68d14c68?auto=format&fit=crop&w=800&q=80"/></c:when>
                                <c:when test="${p.propertyId % 8 == 7}"><c:set var="fallbackImg" value="https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=800&q=80"/></c:when>
                            </c:choose>
                            <img src="${not empty p.imageUrls ? p.imageUrls[0] : fallbackImg}" alt="${p.title}">
                            <div class="stay-badge">${p.propertyType}</div>
                        </div>
                        <div class="stay-content">
                            <div class="stay-meta">
                                <div class="stay-verified">
                                    <i class="fa-solid fa-circle-check"></i> KHOJ VERIFIED
                                </div>
                                <div class="stay-rating">
                                    <i class="fa-solid fa-star"></i> 4.9
                                </div>
                            </div>
                            <h3 class="stay-title">${p.title}</h3>
                            <p class="stay-loc"><i class="fa-solid fa-map-pin"></i> ${p.neighborhoodName}, ${p.cityName}</p>
                            
                            <div class="stay-footer">
                                <div class="stay-price">Rs. ${p.price} <span>/ ${p.priceModel}</span></div>
                                <a href="property-detail?id=${p.propertyId}" class="btn-view">Explore Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Property Types -->
    <section class="section-padding">
        <div class="container">
            <div class="section-header reveal">
                <h2>Browse by Architecture</h2>
            </div>
            
            <div class="type-grid">
                <c:forEach items="${propertyTypes}" var="type">
                    <div class="type-card reveal" onclick="window.location.href='search?type=${type.name}'">
                        <div class="type-icon">
                            <c:choose>
                                <c:when test="${type.name == 'Apartment'}"><i class="fa-solid fa-building"></i></c:when>
                                <c:when test="${type.name == 'Hostel'}"><i class="fa-solid fa-users-viewfinder"></i></c:when>
                                <c:when test="${type.name == 'Hotel'}"><i class="fa-solid fa-bell-concierge"></i></c:when>
                                <c:when test="${type.name == 'Villa'}"><i class="fa-solid fa-mountain-city"></i></c:when>
                                <c:otherwise><i class="fa-solid fa-house-chimney-window"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <h3>${type.name}</h3>
                        <p>Discover unique ${type.name.toLowerCase()}s curated for comfort and elegance.</p>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Stats / Trust Section -->
    <section class="stats">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-item reveal">
                    <div class="stat-val">12k+</div>
                    <div class="stat-label">Verified Listings</div>
                </div>
                <div class="stat-item reveal">
                    <div class="stat-val">45k</div>
                    <div class="stat-label">Happy Residents</div>
                </div>
                <div class="stat-item reveal">
                    <div class="stat-val">0</div>
                    <div class="stat-label">Hidden Commissions</div>
                </div>
                <div class="stat-item reveal">
                    <div class="stat-val">24/7</div>
                    <div class="stat-label">Elite Support</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Mega Footer -->
    <%@ include file="footer.jsp" %>

    <script>
        // Scroll Progress
        window.onscroll = function() {
            let winScroll = document.body.scrollTop || document.documentElement.scrollTop;
            let height = document.documentElement.scrollHeight - document.documentElement.clientHeight;
            let scrolled = (winScroll / height) * 100;
            document.getElementById("scroll-progress").style.width = scrolled + "%";
            
            // Reveal on scroll
            const reveals = document.querySelectorAll('.reveal');
            for(let i = 0; i < reveals.length; i++) {
                let windowHeight = window.innerHeight;
                let elementTop = reveals[i].getBoundingClientRect().top;
                let elementVisible = 150;
                if (elementTop < windowHeight - elementVisible) {
                    reveals[i].classList.add('active');
                }
            }
        };

        // Header color change on scroll
        window.addEventListener('scroll', function() {
            const header = document.querySelector('header');
            if (window.scrollY > 100) {
                header.style.background = "rgba(15, 14, 12, 0.95)";
                header.style.backdropFilter = "blur(10px)";
                header.style.padding = "12px 0";
            } else {
                header.style.background = "transparent";
                header.style.backdropFilter = "none";
                header.style.padding = "24px 0";
            }
        });

        // Trigger reveal on load
        document.addEventListener('DOMContentLoaded', () => {
            window.dispatchEvent(new Event('scroll'));
        });
    </script>
</body>
</html>
