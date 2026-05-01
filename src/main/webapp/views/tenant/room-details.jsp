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
<body style="background-color: #f5f7fa; display: block; margin: 0; padding: 0;">

    <!-- Premium Top Navigation -->
    <nav style="width: 100%; background: #003580; color: white; padding: 1rem 0; box-shadow: 0 2px 10px rgba(0,0,0,0.1); position: sticky; top: 0; z-index: 1000;">
        <div style="max-width: 1140px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between; align-items: center;">
            <div style="font-size: 1.8rem; font-weight: 800; letter-spacing: -1px; cursor: pointer; display: flex; align-items: center; gap: 8px;" onclick="location.href='home'">
                <i class="fa-solid fa-earth-asia" style="color: #ffb700;"></i> KHOJ
            </div>
            <div style="display: flex; gap: 25px; align-items: center;">
                <a href="${pageContext.request.contextPath}/search" style="text-decoration: none; color: rgba(255,255,255,0.8); font-weight: 600; font-size: 0.95rem;"><i class="fa-solid fa-arrow-left"></i> Back to Discovery</a>
                <a href="${pageContext.request.contextPath}/my-bookings" style="text-decoration: none; color: rgba(255,255,255,0.8); font-weight: 600; font-size: 0.95rem;">My Bookings</a>
            </div>
        </div>
    </nav>

    <div class="detail-container" style="max-width: 1140px; margin: 40px auto; padding: 0 20px; display: grid; grid-template-columns: 1.5fr 1fr; gap: 40px;">
        <div>
            <div style="position: relative; border-radius: 20px; overflow: hidden; box-shadow: 0 15px 45px rgba(0,0,0,0.12);">
                <img src="${not empty room.imageUrls ? room.imageUrls[0] : 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=1000&q=80'}" class="main-img" alt="${room.title}" style="width: 100%; height: 500px; object-fit: cover;">
                <div style="position: absolute; bottom: 30px; left: 30px; background: rgba(255,255,255,0.9); backdrop-filter: blur(5px); padding: 10px 20px; border-radius: 12px; font-weight: 800; color: #003580; box-shadow: 0 4px 15px rgba(0,0,0,0.1);">
                    <i class="fa-solid fa-camera"></i> Verified Property Image
                </div>
            </div>
            
            <div style="margin-top: 30px;">
                <h1 style="font-size: 2.8rem; font-weight: 800; color: #1a1a1a; margin: 0 0 10px; letter-spacing: -1px;">${room.title}</h1>
                <p style="color: #64748b; font-size: 1.2rem; display: flex; align-items: center; gap: 8px; margin-bottom: 30px;">
                    <i class="fa-solid fa-location-dot" style="color: #003580;"></i> ${room.neighborhoodName}, ${room.cityName}
                </p>
                
                <div style="background: white; border-radius: 16px; padding: 30px; border: 1px solid #eee; margin-bottom: 30px;">
                    <h3 style="font-size: 1.4rem; font-weight: 800; color: #1a1a1a; margin-bottom: 15px; border-bottom: 2px solid #f0f0f0; padding-bottom: 10px;">About this stay</h3>
                    <p style="line-height: 1.8; color: #475569; font-size: 1.1rem; margin: 0;">
                        ${not empty room.description ? room.description : 'Welcome to this premium property listed on KHOJ. This space offers a comfortable and secure environment, perfectly suited for students or working professionals looking for a high-quality living experience in Kathmandu.'}
                    </p>
                </div>
                
                <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
                    <div style="background: white; padding: 20px; border-radius: 12px; border: 1px solid #eee; text-align: center;">
                        <i class="fa-solid fa-bed" style="font-size: 1.5rem; color: #003580; margin-bottom: 10px;"></i>
                        <div style="font-size: 0.8rem; color: #777; text-transform: uppercase; font-weight: 700;">Type</div>
                        <div style="font-weight: 800; color: #1a1a1a;">${room.propertyType}</div>
                    </div>
                    <div style="background: white; padding: 20px; border-radius: 12px; border: 1px solid #eee; text-align: center;">
                        <i class="fa-solid fa-shield-check" style="font-size: 1.5rem; color: #27ae60; margin-bottom: 10px;"></i>
                        <div style="font-size: 0.8rem; color: #777; text-transform: uppercase; font-weight: 700;">Safety</div>
                        <div style="font-weight: 800; color: #1a1a1a;">Verified</div>
                    </div>
                    <div style="background: white; padding: 20px; border-radius: 12px; border: 1px solid #eee; text-align: center;">
                        <i class="fa-solid fa-wifi" style="font-size: 1.5rem; color: #003580; margin-bottom: 10px;"></i>
                        <div style="font-size: 0.8rem; color: #777; text-transform: uppercase; font-weight: 700;">Internet</div>
                        <div style="font-weight: 800; color: #1a1a1a;">High Speed</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="booking-sidebar">
            <div class="booking-card" style="background: white; padding: 35px; border-radius: 20px; box-shadow: 0 15px 50px rgba(0,0,0,0.08); border: 1px solid #eee; position: sticky; top: 100px;">
                <div style="font-size: 2.5rem; font-weight: 900; color: #003580; margin-bottom: 5px;">Rs. ${room.price}</div>
                <div style="font-size: 1.1rem; color: #64748b; margin-bottom: 25px;">Monthly inclusive of taxes</div>
                
                <div style="display: flex; flex-direction: column; gap: 15px; margin-bottom: 30px;">
                    <div style="display: flex; justify-content: space-between; font-size: 0.95rem;">
                        <span style="color: #666;">Service Fee</span>
                        <span style="font-weight: 700; color: #27ae60;">Free for Students</span>
                    </div>
                    <div style="display: flex; justify-content: space-between; font-size: 0.95rem;">
                        <span style="color: #666;">Refund Policy</span>
                        <span style="font-weight: 700;">Flexible</span>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/ApplyServlet" method="post">
                    <input type="hidden" name="propertyId" value="${room.propertyId}">
                    <button type="submit" class="apply-btn" style="background: #003580; color: white; border: none; width: 100%; padding: 18px; border-radius: 12px; font-size: 1.2rem; font-weight: 800; cursor: pointer; box-shadow: 0 8px 25px rgba(0, 53, 128, 0.2); transition: 0.3s;">
                        Apply to Rent Now
                    </button>
                </form>
                
                <div style="text-align: center; margin-top: 20px; color: #64748b; font-size: 0.85rem; display: flex; align-items: center; gap: 8px; justify-content: center;">
                    <i class="fa-solid fa-lock" style="color: #27ae60;"></i> Secure Application via KHOJ
                </div>
            </div>
        </div>
    </div>

</body>
</html>
