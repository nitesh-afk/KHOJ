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
<body style="background-color: #f8fafc;">

    <div class="main-content" style="margin-left: 0; padding: 2rem 10%;">
        
        <nav style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
            <div style="font-size: 1.5rem; font-weight: 700; color: #2563eb;">KHOJ Discovery</div>
            <div style="display: flex; gap: 2rem; align-items: center;">
                <a href="${pageContext.request.contextPath}/search" style="text-decoration: none; color: #2563eb; font-weight: 700;">Browse</a>
                <a href="${pageContext.request.contextPath}/my-bookings" style="text-decoration: none; color: #64748b; font-weight: 500;">My Bookings</a>
                <a href="${pageContext.request.contextPath}/views/auth/login.jsp" class="badge badge-occupied" style="text-decoration: none;">Logout</a>
            </div>
        </nav>

        <div class="search-hero">
            <h1 style="font-size: 2.5rem; margin-bottom: 1rem;">Find your perfect student home.</h1>
            <p style="opacity: 0.9;">Thousands of verified rooms near universities in Kathmandu.</p>
            <form action="${pageContext.request.contextPath}/search" method="get" class="search-box">
                <input type="text" name="query" value="${searchQuery}" placeholder="Search by area (e.g. Koteshwor, Balkhu)...">
                <button type="submit" class="search-btn">Search Now</button>
            </form>
        </div>

        <c:if test="${param.msg == 'applied'}">
            <div class="badge badge-available" style="margin-bottom: 2rem; width: 100%; text-align: center; display: block; padding: 1rem;">
                🎉 Application submitted! The landlord will review your request.
            </div>
        </c:if>

        <h2 style="margin-bottom: 2rem;">
            <c:choose>
                <c:when test="${not empty searchQuery}">Results for "${searchQuery}"</c:when>
                <c:otherwise>Featured Available Rooms</c:otherwise>
            </c:choose>
        </h2>

        <div class="room-grid">
            <c:forEach var="room" items="${rooms}">
                <a href="${pageContext.request.contextPath}/RoomDetails?id=${room.id}" class="room-card">
                    <img src="${not empty room.imageUrl ? room.imageUrl : 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=400&q=80'}" class="room-img" alt="Room Image">
                    <div class="room-info">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                            <span class="badge badge-available">${room.roomType}</span>
                            <span class="room-price">Rs. ${room.price}</span>
                        </div>
                        <h3 style="margin: 0.5rem 0; font-size: 1.125rem;">${room.title}</h3>
                        <p style="color: #64748b; font-size: 0.875rem; margin-bottom: 0;">📍 ${room.location}</p>
                    </div>
                </a>
            </c:forEach>
            <c:if test="${empty rooms}">
                <div style="grid-column: span 3; text-align: center; padding: 4rem; color: #64748b;">
                    <p style="font-size: 1.25rem;">No rooms found in this area. Try searching for something else!</p>
                </div>
            </c:if>
        </div>
    </div>

</body>
</html>
