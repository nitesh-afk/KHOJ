<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>KHOJ | Your Premium Real Estate & Travel Portal</title>
    
    <!-- Google Fonts & FontAwesome -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-blue: #003580;
            --accent-yellow: #ffb700;
            --dark-text: #1a1a1a;
            --light-bg: #f5f7fa;
            --white: #ffffff;
            --verified-gold: #d4af37;
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--light-bg);
            color: var(--dark-text);
        }

        .container { max-width: 1140px; margin: 0 auto; padding: 0 20px; }

        /* Hero & Search */
        .hero {
            background: linear-gradient(135deg, var(--primary-blue) 0%, #002244 100%);
            color: var(--white);
            padding: 80px 0 110px;
            text-align: center;
        }

        .hero h1 { font-size: 3.5rem; margin: 0 0 15px; font-weight: 800; letter-spacing: -1.5px; }
        .hero p { font-size: 1.3rem; opacity: 0.9; margin: 0; font-weight: 400; }

        .search-wrapper {
            margin-top: -55px;
            z-index: 10;
            position: relative;
        }

        .search-box {
            background: var(--white);
            padding: 12px;
            border-radius: 12px;
            box-shadow: 0 12px 40px rgba(0,0,0,0.18);
            display: flex;
            gap: 15px;
            align-items: center;
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
        }

        .search-item {
            flex: 1;
            padding: 10px 20px;
            border-right: 1px solid #eee;
            display: flex;
            flex-direction: column;
        }

        .search-item:last-child { border-right: none; }
        .search-item label { font-size: 0.7rem; font-weight: 800; color: #777; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 0.5px; }
        .search-item input, .search-item select { border: none; font-size: 1.05rem; font-weight: 700; outline: none; background: transparent; color: var(--dark-text); }

        .btn-search {
            background: var(--primary-blue);
            color: var(--white);
            border: none;
            padding: 18px 45px;
            font-size: 1.1rem;
            font-weight: 800;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 53, 128, 0.3);
        }

        .btn-search:hover { background: #002b66; transform: translateY(-2px); box-shadow: 0 6px 20px rgba(0, 53, 128, 0.4); }

        /* Swimlane Specific Styles */
        .swimlane-section { padding: 50px 0; }
        .swimlane-container {
            display: flex;
            flex-wrap: nowrap;
            overflow-x: auto;
            gap: 24px;
            padding: 15px 0 40px;
            scrollbar-width: none;
            -ms-overflow-style: none;
            scroll-behavior: smooth;
        }
        .swimlane-container::-webkit-scrollbar { display: none; }

        /* Vibe Card */
        .vibe-card {
            min-width: 280px;
            height: 280px;
            position: relative;
            border-radius: 20px;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .vibe-card:hover { transform: translateY(-8px) scale(1.02); box-shadow: 0 20px 40px rgba(0,0,0,0.2); }
        .vibe-card img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.6s ease; }
        .vibe-card:hover img { transform: scale(1.1); }
        
        .vibe-overlay {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to bottom, transparent 0%, rgba(0,0,0,0.2) 50%, rgba(0,0,0,0.7) 100%);
        }

        .vibe-card .vibe-name {
            position: absolute;
            bottom: 30px;
            left: 0;
            width: 100%;
            color: white;
            font-size: 1.8rem;
            font-weight: 800;
            text-align: center;
            text-shadow: 0 2px 15px rgba(0,0,0,0.5);
            letter-spacing: -0.5px;
        }

        /* Premium Card */
        .premium-card {
            min-width: 320px;
            background: white;
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 10px 35px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.03);
            transition: all 0.3s ease;
            position: relative;
        }
        .premium-card:hover { transform: translateY(-12px); box-shadow: 0 20px 50px rgba(0,0,0,0.12); }
        .premium-card img { width: 100%; height: 220px; object-fit: cover; }
        
        .furnishing-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background: rgba(255,255,255,0.9);
            backdrop-filter: blur(5px);
            color: var(--dark-text);
            padding: 6px 14px;
            border-radius: 30px;
            font-size: 0.75rem;
            font-weight: 800;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .verified-shield { 
            color: var(--verified-gold); 
            font-weight: 700; 
            font-size: 0.85rem; 
            display: flex; 
            align-items: center; 
            gap: 5px; 
            background: rgba(212, 175, 55, 0.1);
            padding: 4px 10px;
            border-radius: 4px;
        }
        
        /* Type Pill */
        .type-pill {
            min-width: 160px;
            background: white;
            padding: 25px 20px;
            border-radius: 24px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.04);
            border: 1px solid #f0f0f0;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 12px;
        }
        .type-pill:hover { 
            background: var(--primary-blue); 
            color: white; 
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0, 53, 128, 0.2);
        }
        .type-pill i { font-size: 1.8rem; }
        .type-pill span { font-weight: 700; font-size: 0.95rem; }

        /* Shared Components */
        .section-header { margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
        .section-header h2 { font-size: 1.8rem; font-weight: 800; margin: 0; letter-spacing: -0.5px; }
        .section-header .view-all { 
            color: var(--primary-blue); 
            text-decoration: none; 
            font-weight: 700; 
            font-size: 0.9rem; 
            display: flex; 
            align-items: center; 
            gap: 5px; 
        }
        .section-header .view-all:hover { text-decoration: underline; }

        .badge {
            display: inline-block;
            background: #f0f4ff;
            color: var(--primary-blue);
            font-size: 0.7rem;
            font-weight: 800;
            padding: 5px 12px;
            border-radius: 6px;
            text-transform: uppercase;
        }

        .card-title { font-size: 1.25rem; font-weight: 800; margin: 0 0 8px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; color: var(--dark-text); }
        .card-location { font-size: 0.9rem; color: #666; margin-bottom: 15px; display: flex; align-items: center; gap: 6px; }
        
        .card-footer { border-top: 1px solid #f5f5f5; padding-top: 20px; display: flex; justify-content: space-between; align-items: center; }
        .price { font-size: 1.4rem; font-weight: 900; color: var(--primary-blue); }
        .price span { font-size: 0.85rem; font-weight: 600; color: #777; }
    </style>
</head>
<body>

    <!-- Header Area -->
    <header style="background: var(--primary-blue); padding: 20px 0; position: sticky; top: 0; z-index: 1000; box-shadow: 0 4px 20px rgba(0,0,0,0.1);">
        <div class="container" style="display: flex; justify-content: space-between; align-items: center;">
            <div style="font-size: 2rem; font-weight: 900; color: white; letter-spacing: -2px; cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="location.href='home'">
                <i class="fa-solid fa-earth-asia" style="color: var(--accent-yellow);"></i> KHOJ
            </div>
            <div style="display: flex; gap: 30px; align-items: center;">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <a href="my-bookings" style="color: white; text-decoration: none; font-weight: 700; font-size: 0.95rem;">My Bookings</a>
                        <div style="color: white; font-weight: 700; display: flex; align-items: center; gap: 10px; background: rgba(255,255,255,0.1); padding: 8px 15px; border-radius: 50px;">
                            <i class="fa-solid fa-circle-user" style="font-size: 1.2rem; color: var(--accent-yellow);"></i>
                            ${sessionScope.user.fullName}
                        </div>
                        <a href="LogoutServlet" style="color: #ff9e9e; text-decoration: none; font-weight: 800; font-size: 0.95rem;">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="#" style="color: white; text-decoration: none; font-weight: 700; font-size: 0.95rem;">List your property</a>
                        <a href="LoginServlet" style="background: var(--white); color: var(--primary-blue); padding: 10px 25px; border-radius: 8px; text-decoration: none; font-weight: 800; font-size: 0.95rem; box-shadow: 0 4px 10px rgba(0,0,0,0.2);">Sign In</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="container">
            <h1>Find your perfect home away from home</h1>
            <p>Explore thousands of verified properties, from luxury villas to cozy student apartments.</p>
        </div>
    </section>

    <!-- Advanced Search Box -->
    <div class="container search-wrapper">
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
            <button type="submit" class="btn-search">Find Stays</button>
        </form>
    </div>

    <!-- Section 1: Discover Your Vibe -->
    <div class="container swimlane-section">
        <div class="section-header">
            <h2>Discover Your Vibe</h2>
            <a href="search" class="view-all">Explore all themes <i class="fa-solid fa-arrow-right"></i></a>
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

    <!-- Section 2: Verified Premium Stays -->
    <div style="background: white; border-top: 1px solid #eee; border-bottom: 1px solid #eee;">
        <div class="container swimlane-section">
            <div class="section-header">
                <h2>Verified Premium Stays</h2>
                <a href="search?verified=true" class="view-all">See more verified <i class="fa-solid fa-arrow-right"></i></a>
            </div>
            <div class="swimlane-container">
                <c:forEach items="${verifiedProperties}" var="p">
                    <div class="premium-card" onclick="window.location.href='property-detail?id=${p.propertyId}'" style="cursor: pointer;">
                        <img src="${not empty p.imageUrls ? p.imageUrls[0] : 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80'}" alt="${p.title}">
                        <span class="furnishing-badge">${p.furnishingStatus}</span>
                        <div style="padding: 24px;">
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                                <span class="badge">${p.propertyType}</span>
                                <span class="verified-shield"><i class="fa-solid fa-shield-halved"></i> Verified</span>
                            </div>
                            <h3 class="card-title">${p.title}</h3>
                            <p class="card-location"><i class="fa-solid fa-location-dot" style="color: var(--primary-blue);"></i> ${p.neighborhoodName}, ${p.cityName}</p>
                            <div class="card-footer">
                                <div class="price">Rs. ${p.price} <span>/ ${p.priceModel}</span></div>
                                <div style="color: #27ae60; font-size: 0.8rem; font-weight: 700; display: flex; align-items: center; gap: 4px;">
                                    <i class="fa-solid fa-calendar-check"></i> Available
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <!-- Section 3: Find Your Perfect Setup -->
    <div class="container swimlane-section" style="padding-bottom: 80px;">
        <div class="section-header">
            <h2>Find Your Perfect Setup</h2>
        </div>
        <div class="swimlane-container">
            <c:forEach items="${propertyTypes}" var="type">
                <div class="type-pill" onclick="window.location.href='search?type=${type.name}'">
                    <div style="font-size: 2rem;">
                        <c:choose>
                            <c:when test="${type.name == 'Apartment'}"><i class="fa-solid fa-building"></i></c:when>
                            <c:when test="${type.name == 'Hostel'}"><i class="fa-solid fa-bed"></i></c:when>
                            <c:when test="${type.name == 'Hotel'}"><i class="fa-solid fa-hotel"></i></c:when>
                            <c:when test="${type.name == 'Villa'}"><i class="fa-solid fa-house-chimney"></i></c:when>
                            <c:otherwise><i class="fa-solid fa-house"></i></c:otherwise>
                        </c:choose>
                    </div>
                    <span>${type.name}</span>
                </div>
            </c:forEach>
        </div>
    </div>


    <!-- Mega Footer Include -->
    <%@ include file="footer.jsp" %>

</body>
</html>