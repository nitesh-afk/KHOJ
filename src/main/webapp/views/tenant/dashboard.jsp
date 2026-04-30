<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Find Your Room | KHOJ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .search-hero {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            padding: 4rem 2rem;
            border-radius: 1.5rem;
            color: white;
            text-align: center;
            margin-bottom: 3rem;
        }
        .search-box {
            background: white;
            padding: 0.5rem;
            border-radius: 999px;
            display: flex;
            max-width: 600px;
            margin: 2rem auto 0;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .search-box input {
            flex: 1;
            border: none;
            padding: 1rem 1.5rem;
            border-radius: 999px;
            font-size: 1rem;
            outline: none;
        }
        .search-btn {
            background: #2563eb;
            color: white;
            border: none;
            padding: 0.75rem 2rem;
            border-radius: 999px;
            font-weight: 600;
            cursor: pointer;
        }
        .room-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
        }
        .room-card {
            background: white;
            border-radius: 1rem;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            transition: 0.3s;
            text-decoration: none;
            color: inherit;
        }
        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .room-img {
            width: 100%;
            height: 200px;
            background: #e2e8f0;
            object-fit: cover;
        }
        .room-info {
            padding: 1.5rem;
        }
        .room-price {
            font-size: 1.25rem;
            font-weight: 700;
            color: #2563eb;
        }
    </style>
</head>
<body style="background-color: #f5f7fa; display: block; margin: 0; padding: 0;">

    <!-- Premium Top Navigation -->
    <nav style="width: 100%; background: #003580; color: white; padding: 1rem 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 1000;">
        <div style="max-width: 1140px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between; align-items: center;">
            <div style="font-size: 1.8rem; font-weight: 800; letter-spacing: -1px; cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="location.href='home'">
                <i class="fa-solid fa-earth-asia" style="color: #ffb700;"></i> KHOJ
            </div>
            <div style="display: flex; gap: 25px; align-items: center;">
                <a href="${pageContext.request.contextPath}/search" style="text-decoration: none; color: white; font-weight: 700; font-size: 0.95rem; border-bottom: 2px solid #ffb700; padding-bottom: 4px;">Discovery</a>
                <a href="${pageContext.request.contextPath}/my-bookings" style="text-decoration: none; color: rgba(255,255,255,0.8); font-weight: 600; font-size: 0.95rem;">My Bookings</a>
                <a href="${pageContext.request.contextPath}/LogoutServlet" style="text-decoration: none; color: #ff9e9e; font-weight: 700; font-size: 0.95rem;">Logout</a>
            </div>
        </div>
    </nav>

    <div class="container" style="max-width: 1140px; margin: 40px auto; padding: 0 20px;">
        
        <div class="search-hero" style="background: linear-gradient(135deg, #003580 0%, #002244 100%); border-radius: 20px; padding: 60px 40px; text-align: center; margin-bottom: 50px;">
            <h1 style="font-size: 3rem; font-weight: 800; margin-bottom: 15px; letter-spacing: -1px;">Find your perfect home.</h1>
            <p style="font-size: 1.2rem; opacity: 0.9; margin-bottom: 30px;">Explore verified student accommodations and premium rentals.</p>
            <form action="${pageContext.request.contextPath}/search" method="get" class="search-box" style="background: white; padding: 10px; border-radius: 12px; display: flex; max-width: 700px; margin: 0 auto; box-shadow: 0 15px 35px rgba(0,0,0,0.2);">
                <input type="text" name="query" value="${searchQuery}" placeholder="Search by area (e.g. Kathmandu, Koteshwor)..." style="flex: 1; border: none; padding: 15px 25px; font-size: 1.1rem; outline: none; font-weight: 500;">
                <button type="submit" class="search-btn" style="background: #003580; color: white; border: none; padding: 0 35px; border-radius: 8px; font-weight: 800; cursor: pointer; transition: 0.2s;">Search</button>
            </form>
        </div>

        <c:if test="${param.msg == 'applied'}">
            <div class="badge badge-available" style="margin-bottom: 30px; width: 100%; text-align: center; display: block; padding: 15px; border-radius: 8px; font-weight: 700;">
                🎉 Application submitted successfully! Tracking it in 'My Bookings'.
            </div>
        </c:if>

        <h2 style="font-size: 1.8rem; font-weight: 800; margin-bottom: 30px; color: #1a1a1a; display: flex; align-items: center; gap: 12px;">
            <c:choose>
                <c:when test="${not empty searchQuery}"><i class="fa-solid fa-magnifying-glass" style="color: #003580;"></i> Results for "${searchQuery}"</c:when>
                <c:otherwise><i class="fa-solid fa-fire" style="color: #ffb700;"></i> Top Available Rooms</c:otherwise>
            </c:choose>
        </h2>

        <div class="room-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 30px;">
            <c:forEach var="room" items="${rooms}">
                <a href="${pageContext.request.contextPath}/RoomDetails?id=${room.id}" class="room-card" style="display: block; background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.05); text-decoration: none; color: inherit; transition: all 0.3s ease; border: 1px solid #f0f0f0;">
                    <div style="position: relative;">
                        <img src="${not empty room.imageUrl ? room.imageUrl : 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=600&q=80'}" class="room-img" alt="${room.title}" style="width: 100%; height: 220px; object-fit: cover;">
                        <span style="position: absolute; top: 15px; right: 15px; background: rgba(0,0,0,0.6); backdrop-filter: blur(5px); color: white; padding: 5px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 700;">
                            ${room.roomType}
                        </span>
                    </div>
                    <div class="room-info" style="padding: 24px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                            <span class="badge badge-available" style="padding: 4px 10px; border-radius: 4px; font-size: 0.7rem; font-weight: 800; text-transform: uppercase;">Verified</span>
                            <span class="room-price" style="font-size: 1.4rem; font-weight: 900; color: #003580;">Rs. ${room.price} <small style="font-size: 0.8rem; font-weight: 500; color: #777;">/mo</small></span>
                        </div>
                        <h3 style="margin: 0 0 10px; font-size: 1.25rem; font-weight: 800; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">${room.title}</h3>
                        <p style="color: #64748b; font-size: 0.9rem; margin: 0; display: flex; align-items: center; gap: 6px;">
                            <i class="fa-solid fa-location-dot" style="color: #003580;"></i> ${room.location}
                        </p>
                    </div>
                </a>
            </c:forEach>
            
            <c:if test="${empty rooms}">
                <div style="grid-column: 1 / -1; text-align: center; padding: 100px 20px; background: white; border-radius: 20px; border: 2px dashed #e2e8f0;">
                    <i class="fa-solid fa-search-minus" style="font-size: 4rem; color: #cbd5e1; margin-bottom: 20px;"></i>
                    <h3 style="font-size: 1.5rem; font-weight: 700; color: #475569;">No properties found</h3>
                    <p style="color: #64748b; max-width: 400px; margin: 10px auto 30px;">We couldn't find any rooms matching your criteria. Try adjusting your search area.</p>
                    <a href="${pageContext.request.contextPath}/search" style="color: #003580; font-weight: 800; text-decoration: none; border-bottom: 2px solid #003580; padding-bottom: 2px;">Clear all filters</a>
                </div>
            </c:if>
        </div>
    </div>

</body>
</html>
