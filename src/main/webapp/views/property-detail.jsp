<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${property.title} | KHOJ</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="resources/css/style.css">
    
    <style>
        .detail-container { max-width: 1100px; margin: 40px auto; display: grid; grid-template-columns: 2fr 1fr; gap: 30px; }
        .gallery { display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; margin-bottom: 20px; }
        .gallery img { width: 100%; height: 300px; object-fit: cover; border-radius: 8px; }
        .gallery img:first-child { grid-column: span 2; height: 500px; }
        .info-card { background: white; padding: 25px; border-radius: 12px; box-shadow: var(--card-shadow); }
        .amenity-list { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-top: 20px; }
        .amenity-item { display: flex; align-items: center; gap: 10px; font-weight: 500; }
        .price-tag { font-size: 2rem; font-weight: 800; color: var(--primary-blue); margin-bottom: 20px; }
        .booking-card { position: sticky; top: 20px; }
        .btn-apply { background: var(--primary-blue); color: white; width: 100%; padding: 15px; border: none; border-radius: 8px; font-size: 1.1rem; font-weight: 700; cursor: pointer; }
    </style>
</head>
<body>

    <header style="background: var(--primary-blue); padding: 15px 0;">
        <div class="hero-content" style="display: flex; justify-content: space-between; align-items: center;">
            <h2 style="margin: 0; color: white; font-weight: 800; cursor: pointer;" onclick="window.location.href='home'">KHOJ</h2>
        </div>
    </header>

    <div class="detail-container">
        <div class="main-content">
            <div class="gallery">
                <c:forEach items="${property.imageUrls}" var="url" varStatus="status">
                    <img src="${url}" alt="Property Image ${status.count}">
                </c:forEach>
                <c:if test="${empty property.imageUrls}">
                    <img src="https://placehold.co/1100x500/003580/FFFFFF?text=No+Images+Available" alt="Placeholder">
                </c:if>
            </div>

            <div class="info-card">
                <div class="card-badges" style="margin-bottom: 15px;">
                    <span class="badge badge-type" style="font-size: 0.9rem;">${property.propertyType}</span>
                    <c:if test="${property.verified}">
                        <span class="badge badge-status" style="font-size: 0.9rem; background: #dcfce7; color: #166534;"><i class="fa-solid fa-circle-check"></i> Verified</span>
                    </c:if>
                </div>
                <h1 style="font-size: 2.2rem; margin-bottom: 10px;">${property.title}</h1>
                <p style="color: #666; font-size: 1.1rem; margin-bottom: 20px;">
                    <i class="fa-solid fa-location-dot"></i> ${property.neighborhoodName}, ${property.cityName} (${property.themeName})
                </p>
                
                <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;">
                
                <h3>Description</h3>
                <p style="line-height: 1.6; color: #444; font-size: 1.05rem;">${property.description}</p>
                
                <h3 style="margin-top: 40px;">Amenities</h3>
                <div class="amenity-list">
                    <c:forEach items="${property.amenities}" var="amenity">
                        <div class="amenity-item">
                            <i class="fa-solid fa-check" style="color: var(--primary-blue);"></i> ${amenity}
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div class="sidebar">
            <div class="info-card booking-card">
                <p style="font-weight: 700; margin-bottom: 5px;">Price</p>
                <div class="price-tag">Rs. ${property.price} <span style="font-size: 1rem; color: #666; font-weight: 500;">/ ${property.priceModel}</span></div>
                
                <p style="font-size: 0.9rem; color: #555; margin-bottom: 20px;">
                    <strong>Landlord:</strong> ${property.landlordName}<br>
                    <strong>Status:</strong> ${property.furnishingStatus}
                </p>

                <form action="ApplyServlet" method="POST">
                    <input type="hidden" name="propertyId" value="${property.propertyId}">
                    <button type="submit" class="btn-apply">Check Availability</button>
                </form>
                
                <p style="font-size: 0.8rem; color: #888; text-align: center; margin-top: 15px;">
                    <i class="fa-solid fa-shield-halved"></i> Secure Payment & Data Protection
                </p>
            </div>
        </div>
    </div>

    <!-- Mega Footer Include -->
    <%@ include file="../footer.jsp" %>

</body>
</html>
