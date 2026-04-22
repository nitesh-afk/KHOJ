<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${room.title} | KHOJ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .detail-container {
            max-width: 1000px;
            margin: 2rem auto;
            display: grid;
            grid-template-columns: 1.5fr 1fr;
            gap: 2rem;
            padding: 0 5%;
        }
        .main-img {
            width: 100%;
            height: 450px;
            object-fit: cover;
            border-radius: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .booking-card {
            background: white;
            padding: 2rem;
            border-radius: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 2rem;
        }
        .apply-btn {
            width: 100%;
            padding: 1rem;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 0.75rem;
            font-size: 1.125rem;
            font-weight: 700;
            cursor: pointer;
            margin-top: 1.5rem;
            transition: 0.2s;
        }
        .apply-btn:hover { background: #1d4ed8; }
    </style>
</head>
<body style="background-color: #f8fafc;">

    <nav style="padding: 1.5rem 10%; background: white; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between;">
        <a href="${pageContext.request.contextPath}/search" style="text-decoration: none; color: #2563eb; font-weight: 600;">← Back to Discovery</a>
        <div style="font-weight: 700; color: #2563eb;">KHOJ</div>
    </nav>

    <div class="detail-container">
        <div>
            <img src="${not empty room.imageUrl ? room.imageUrl : 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1000&q=80'}" class="main-img" alt="Room Image">
            <h1 style="margin-top: 2rem; font-size: 2.25rem;">${room.title}</h1>
            <p style="color: #64748b; font-size: 1.125rem; margin-bottom: 2rem;">📍 ${room.location}</p>
            
            <hr style="border: 0; border-top: 1px solid #e2e8f0; margin-bottom: 2rem;">
            
            <h3>Description</h3>
            <p style="line-height: 1.8; color: #334155; font-size: 1.1rem;">
                ${not empty room.description ? room.description : 'No description provided for this listing.'}
            </p>
        </div>

        <div class="booking-card">
            <div style="font-size: 2rem; font-weight: 800; color: #1e293b;">Rs. ${room.price} <span style="font-size: 1rem; color: #64748b; font-weight: 400;">/ month</span></div>
            <div style="margin-top: 1rem;">
                <span class="badge badge-available" style="padding: 0.5rem 1rem;">${room.roomType}</span>
                <span class="badge badge-available" style="padding: 0.5rem 1rem; margin-left: 5px;">Verified Listing</span>
            </div>

            <form action="${pageContext.request.contextPath}/ApplyServlet" method="post">
                <input type="hidden" name="roomId" value="${room.id}">
                <button type="submit" class="apply-btn">Apply to Rent</button>
            </form>
            <p style="text-align: center; color: #64748b; font-size: 0.8125rem; margin-top: 1rem;">
                You won't be charged yet. The landlord will review your application.
            </p>
        </div>
    </div>

</body>
</html>
