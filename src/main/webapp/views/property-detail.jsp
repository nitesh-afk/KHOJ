<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
        :root {
            --bg-primary: #FAF9F6;
            --nav-bg: #1C1917;
            --accent-gold: #C9A96E;
            --accent-gold-dark: #B8935A;
            --text-primary: #1C1917;
            --text-secondary: #6B6560;
            --card-surface: #FFFFFF;
            --card-border: #EDE9E3;
            --success-green: #2D6A4F;
        }
        body {
            background: var(--bg-primary);
            color: var(--text-primary);
        }
        .detail-container { max-width: 1100px; margin: 40px auto; display: grid; grid-template-columns: 2fr 1fr; gap: 30px; }
        .gallery { display: grid; grid-template-columns: repeat(2, 1fr); gap: 10px; margin-bottom: 20px; }
        .gallery img { width: 100%; height: 300px; object-fit: cover; border-radius: 8px; }
        .gallery img:first-child { grid-column: span 2; height: 500px; }
        .info-card {
            background: var(--card-surface);
            padding: 25px;
            border-radius: 12px;
            border: 1px solid var(--card-border);
            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.05);
        }
        .amenity-list { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; margin-top: 20px; }
        .amenity-item { display: flex; align-items: center; gap: 10px; font-weight: 500; color: var(--text-primary); }
        .price-tag { font-size: 2rem; font-weight: 800; color: var(--text-primary); margin-bottom: 20px; }
        .booking-card { position: sticky; top: 20px; }
        .btn-apply {
            background: var(--nav-bg);
            color: var(--accent-gold);
            width: 100%;
            padding: 15px;
            border: 1px solid rgba(201, 169, 110, 0.35);
            border-radius: 8px;
            font-size: 1.05rem;
            font-weight: 700;
            cursor: pointer;
        }
        .btn-apply:hover { background: #13100f; }
        .btn-wishlist { margin-top: 12px; width: 100%; padding: 12px; border: none; border-radius: 8px; font-size: 0.95rem; font-weight: 700; cursor: pointer; }
        .btn-wishlist.add { background: #F5F0E8; color: var(--accent-gold-dark); border: 1px solid #E8D9BF; }
        .btn-wishlist.remove { background: #FFE4E4; color: #991b1b; border: 1px solid #FFC9C9; }
        .reviews-section { max-width: 1100px; margin: 0 auto 40px; }
        .review-summary {
            background: var(--card-surface);
            border-radius: 12px;
            border: 1px solid var(--card-border);
            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.05);
            padding: 20px 24px;
            margin-bottom: 16px;
        }
        .review-card {
            background: var(--card-surface);
            border-radius: 12px;
            border: 1px solid var(--card-border);
            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.05);
            padding: 18px 20px;
            margin-bottom: 12px;
        }
        .review-meta { color: var(--text-secondary); font-size: 0.9rem; margin-bottom: 8px; }
        .review-stars { color: #f59e0b; font-size: 1rem; letter-spacing: 1px; margin-bottom: 8px; }
        .review-form {
            background: var(--card-surface);
            border-radius: 12px;
            border: 1px solid var(--card-border);
            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.05);
            padding: 22px;
            margin-top: 18px;
        }
        .review-form label { display: block; font-weight: 600; margin-bottom: 6px; }
        .review-form select, .review-form textarea { width: 100%; padding: 10px; border: 1px solid var(--card-border); border-radius: 8px; margin-bottom: 12px; font-family: inherit; background: #fff; }
        .review-form textarea { min-height: 120px; resize: vertical; }
        .review-btn { background: var(--accent-gold); color: var(--text-primary); border: none; border-radius: 8px; padding: 11px 16px; font-weight: 700; cursor: pointer; }
        .review-btn:hover { background: var(--accent-gold-dark); }
        .review-counter { text-align: right; color: var(--text-secondary); font-size: 0.85rem; margin-top: -6px; margin-bottom: 10px; }
        .already-reviewed { background: #fffbeb; color: #92400e; border: 1px solid #fcd34d; padding: 12px; border-radius: 8px; margin-top: 12px; }
    </style>
</head>
<body>

    <header style="background: var(--nav-bg); padding: 15px 0; border-bottom: 1px solid rgba(201, 169, 110, 0.25);">
        <div class="hero-content" style="display: flex; justify-content: space-between; align-items: center;">
            <h2 style="margin: 0; color: var(--accent-gold); font-weight: 800; cursor: pointer;" onclick="window.location.href='home'">KHOJ</h2>
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
                <h1 style="font-size: 2.2rem; margin-bottom: 10px; color: var(--text-primary);">${property.title}</h1>
                <p style="color: var(--text-secondary); font-size: 1.1rem; margin-bottom: 20px;">
                    <i class="fa-solid fa-location-dot" style="color: var(--accent-gold);"></i> ${property.neighborhoodName}, ${property.cityName} (${property.themeName})
                </p>
                
                <hr style="border: 0; border-top: 1px solid var(--card-border); margin: 30px 0;">
                
                <h3>Description</h3>
                <p style="line-height: 1.6; color: #444; font-size: 1.05rem;">${property.description}</p>
                
                <h3 style="margin-top: 40px;">Amenities & Perks</h3>
                <div class="amenity-list">
                    <c:forEach items="${property.detailedAmenities}" var="amenity">
                        <div class="amenity-item">
                            <i class="fa-solid ${not empty amenity.iconCode ? amenity.iconCode : 'fa-circle-check'}" style="color: var(--accent-gold); width: 20px;"></i> 
                            ${amenity.name}
                        </div>
                    </c:forEach>
                    <c:if test="${empty property.detailedAmenities}">
                        <p style="color: var(--text-secondary); font-size: 0.9rem;">Standard amenities included.</p>
                    </c:if>
                </div>
            </div>
        </div>

        <div class="sidebar">
            <div class="info-card booking-card">
                <p style="font-weight: 700; margin-bottom: 5px;">Price</p>
                <div class="price-tag">Rs. ${property.price} <span style="font-size: 1rem; color: var(--text-secondary); font-weight: 500;">/ ${property.priceModel}</span></div>
                
                <p style="font-size: 0.9rem; color: var(--text-secondary); margin-bottom: 20px; line-height: 1.8;">
                    <strong>Landlord:</strong> ${property.landlordName}<br>
                    <strong>Contact:</strong> ${property.landlordPhone}<br>
                    <strong>Email:</strong> ${property.landlordEmail}<br>
                    <strong>Bedrooms:</strong> ${property.bedrooms}<br>
                    <strong>Status:</strong> ${property.furnishingStatus}
                </p>

                <c:if test="${not empty sessionScope.user && sessionScope.user.role == 'TENANT'}">
                    <form action="${pageContext.request.contextPath}/wishlist" method="POST">
                        <input type="hidden" name="propertyId" value="${property.propertyId}">
                        <c:choose>
                            <c:when test="${isWishlisted}">
                                <input type="hidden" name="action" value="remove">
                                <button type="submit" class="btn-wishlist remove">Remove from wishlist</button>
                            </c:when>
                            <c:otherwise>
                                <input type="hidden" name="action" value="add">
                                <button type="submit" class="btn-wishlist add">Save to wishlist</button>
                            </c:otherwise>
                        </c:choose>
                    </form>
                </c:if>

                <c:choose>
                    <c:when test="${hasApplied}">
                        <div style="background: rgba(201, 169, 110, 0.1); backdrop-filter: blur(8px); border: 1px solid rgba(201, 169, 110, 0.3); color: var(--accent-gold-dark); padding: 15px; border-radius: 8px; text-align: center; font-weight: 700; margin-bottom: 10px;">
                            <i class="fa-solid fa-clock-rotate-left"></i> Application Pending
                        </div>
                        <a href="${pageContext.request.contextPath}/messages?with=${property.landlordId}&property=${property.propertyId}" 
                           style="display: block; text-align: center; background: #FFF; color: var(--nav-bg); border: 1px solid var(--nav-bg); padding: 12px; border-radius: 8px; text-decoration: none; font-weight: 700; margin-bottom: 10px;">
                           <i class="fa-solid fa-message"></i> Message Landlord
                        </a>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/ApplyServlet" method="POST">
                            <input type="hidden" name="propertyId" value="${property.propertyId}">
                            <button type="submit" class="btn-apply">Check Availability</button>
                        </form>
                    </c:otherwise>
                </c:choose>
                
                <c:if test="${param.error == 'AlreadyApplied'}">
                    <div style="background: rgba(255, 251, 235, 0.7); backdrop-filter: blur(10px); color: #92400e; border: 1px solid rgba(252, 211, 77, 0.5); padding: 12px; border-radius: 8px; margin-top: 15px; font-weight: 600; font-size: 0.85rem;">
                        <i class="fa-solid fa-circle-info"></i> You have already applied for this property.
                    </div>
                </c:if>
                <c:if test="${param.error == 'SystemBusy'}">
                    <div style="background: rgba(254, 242, 242, 0.7); backdrop-filter: blur(10px); color: #991b1b; border: 1px solid rgba(254, 202, 202, 0.5); padding: 12px; border-radius: 8px; margin-top: 15px; font-weight: 600; font-size: 0.85rem;">
                        <i class="fa-solid fa-circle-exclamation"></i> System busy. Please try again later.
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <div class="reviews-section">
        <div class="review-summary">
            <h2 style="margin-bottom: 6px;">Guest Reviews</h2>
            <p style="color:#444;">
                <c:choose>
                    <c:when test="${not empty reviews}">
                        Average rating:
                        <strong><fmt:formatNumber value="${avgRating}" maxFractionDigits="1" minFractionDigits="1" /></strong>
                        <span style="color:#f59e0b; margin: 0 5px;">
                            <c:forEach begin="1" end="5" var="i">
                                <i class="fa-solid fa-star${i <= avgRating ? '' : '-o'}" style="color: ${i <= avgRating ? '#f59e0b' : '#ddd'}"></i>
                            </c:forEach>
                        </span>
                        (${reviews.size()} verified reviews)
                    </c:when>
                    <c:otherwise>
                        No ratings yet for this property.
                    </c:otherwise>
                </c:choose>
            </p>
        </div>

        <c:choose>
            <c:when test="${empty reviews}">
                <div class="review-card">
                    <p style="color:#666;">No reviews yet. Be the first to review this property.</p>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="review" items="${reviews}">
                    <div class="review-card">
                        <div class="review-meta">
                            <strong>${review.tenantName}</strong> • ${review.createdAt}
                        </div>
                        <div class="review-stars">
                            <c:forEach begin="1" end="${review.rating}" var="i">★</c:forEach>
                        </div>
                        <p>${review.comment}</p>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <c:if test="${not empty sessionScope.user && sessionScope.user.role == 'TENANT'}">
            <c:set var="alreadyReviewed" value="false" />
            <c:forEach var="review" items="${reviews}">
                <c:if test="${review.tenantName == sessionScope.user.fullName}">
                    <c:set var="alreadyReviewed" value="true" />
                </c:if>
            </c:forEach>

            <c:choose>
                <c:when test="${alreadyReviewed}">
                    <div class="already-reviewed">You have already reviewed this property.</div>
                </c:when>
                <c:otherwise>
                    <div class="review-form">
                        <h3 style="margin-bottom: 14px;">Write a review</h3>
                        <form action="${pageContext.request.contextPath}/review" method="POST">
                            <input type="hidden" name="propertyId" value="${property.propertyId}">

                            <label for="rating">Rating</label>
                            <select id="rating" name="rating" required>
                                <option value="5">5 ★★★★★</option>
                                <option value="4">4 ★★★★</option>
                                <option value="3">3 ★★★</option>
                                <option value="2">2 ★★</option>
                                <option value="1">1 ★</option>
                            </select>

                            <label for="comment">Comment</label>
                            <textarea id="comment" name="comment" maxlength="500" required></textarea>
                            <div id="commentCounter" class="review-counter">0 / 500</div>

                            <button type="submit" class="review-btn">Submit review</button>
                        </form>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>
    </div>

    <!-- Mega Footer Include -->
    <%@ include file="../footer.jsp" %>

    <script>
        (function () {
            const comment = document.getElementById("comment");
            const counter = document.getElementById("commentCounter");
            if (!comment || !counter) return;
            const updateCounter = function () {
                counter.textContent = comment.value.length + " / 500";
            };
            comment.addEventListener("input", updateCounter);
            updateCounter();
        })();
    </script>

</body>
</html>
