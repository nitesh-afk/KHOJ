<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Wishlist | KHOJ</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background-color: #FAF9F6;
            color: #1C1917;
            display: flex;
            min-height: 100vh;
        }

        /* Sidebar Styles */
        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 260px;
            height: 100vh;
            background-color: #0F0E0C;
            padding: 24px 20px;
            display: flex;
            flex-direction: column;
            z-index: 100;
        }
        .sidebar-top { flex: 1; }
        .logo-section { margin-bottom: 16px; }
        .logo {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            color: #C9A96E;
        }
        .logo-subtitle {
            font-family: 'Inter', sans-serif;
            font-size: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: rgba(255, 255, 255, 0.3);
            margin-top: 4px;
        }
        .sidebar-divider {
            border: 0;
            border-bottom: 1px solid rgba(201, 169, 110, 0.2);
            margin: 16px 0;
        }
        .superuser-badge {
            background: rgba(201, 169, 110, 0.1);
            border: 1px solid rgba(201, 169, 110, 0.3);
            border-radius: 8px;
            padding: 10px 14px;
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 32px;
        }
        .superuser-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #C9A96E;
            color: #1C1917;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }
        .superuser-info { display: flex; flex-direction: column; }
        .superuser-name {
            font-family: 'Inter', sans-serif;
            font-size: 0.82rem;
            color: #FFFFFF;
            font-weight: 600;
        }
        .superuser-role {
            font-family: 'Inter', sans-serif;
            font-size: 0.65rem;
            color: #C9A96E;
            text-transform: uppercase;
            margin-top: 2px;
        }

        .nav-links { list-style: none; display: flex; flex-direction: column; gap: 8px; }
        .nav-links a {
            text-decoration: none;
            padding: 12px 16px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            gap: 12px;
            color: rgba(255, 255, 255, 0.45);
            font-size: 0.9rem;
            transition: all 0.2s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }
        .nav-links a i {
            font-size: 0.9rem;
            width: 16px;
            text-align: center;
        }
        .nav-links a:hover {
            color: #FFFFFF;
            background: rgba(255, 255, 255, 0.05);
        }
        .nav-links a.active {
            color: #FFFFFF;
            background: #1C1917;
            border-left: 3px solid #C9A96E;
            border-radius: 0 10px 10px 0;
        }

        .sidebar-bottom {
            margin-top: auto;
            border-top: 1px solid rgba(255, 255, 255, 0.08);
            padding-top: 16px;
        }
        .sidebar-bottom a {
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
            color: rgba(255, 255, 255, 0.35);
            font-size: 0.9rem;
            padding: 12px 16px;
            border-radius: 10px;
            transition: color 0.2s;
        }
        .sidebar-bottom a:hover { color: #FFB4A2; }

        /* Main Content */
        .main-content {
            margin-left: 260px;
            padding: 40px 48px;
            width: calc(100% - 260px);
            min-height: 100vh;
        }

        /* Top Header */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 40px;
        }
        .header-left { display: flex; flex-direction: column; }
        .header-eyebrow {
            font-family: 'Inter', sans-serif;
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #C9A96E;
            margin-bottom: 8px;
        }
        .header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2.2rem;
            color: #1C1917;
            font-weight: 700;
        }
        .count-pill {
            background: #1C1917;
            color: #C9A96E;
            border: 1px solid rgba(201, 169, 110, 0.4);
            border-radius: 20px;
            padding: 8px 18px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* Flash Messages */
        .flash {
            display: none;
            padding: 16px;
            border-radius: 12px;
            margin-bottom: 30px;
            font-weight: 600;
            text-align: center;
        }
        .flash.success {
            background: #D8F3DC;
            color: #2D6A4F;
            border: 1px solid #B7E4C7;
        }
        .flash.error {
            background: #FFE4E4;
            color: #991B1B;
            border: 1px solid #FFC9C9;
        }

        /* Wishlist Grid */
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 24px;
        }
        .wishlist-card {
            background: #FFFFFF;
            border-radius: 16px;
            padding: 24px;
            border: 1px solid #EDE9E3;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
            display: flex;
            flex-direction: column;
            transition: all 0.3s ease;
        }
        .wishlist-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 30px rgba(0,0,0,0.08);
            border-color: rgba(201, 169, 110, 0.3);
        }
        .property-title {
            font-family: 'Playfair Display', serif;
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 8px;
            color: #1C1917;
        }
        .price {
            font-size: 1.1rem;
            color: #C9A96E;
            font-weight: 700;
            margin-bottom: 20px;
        }
        .card-actions {
            margin-top: auto;
            display: flex;
            gap: 12px;
        }
        .btn {
            flex: 1;
            text-decoration: none;
            padding: 12px;
            border-radius: 8px;
            font-size: 0.85rem;
            font-weight: 700;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
        }
        .btn-view {
            background: #1C1917;
            color: #C9A96E;
            border: 1px solid rgba(201, 169, 110, 0.3);
        }
        .btn-view:hover { background: #000; }
        .btn-remove {
            background: #FAF9F6;
            color: #991B1B;
            border: 1px solid #FFC9C9;
        }
        .btn-remove:hover { background: #FFE4E4; }

        /* Empty State */
        .empty-state {
            grid-column: 1 / -1;
            background: #FFFFFF;
            border: 1px dashed #C9A96E;
            border-radius: 16px;
            padding: 60px 20px;
            text-align: center;
        }
        .empty-state i {
            font-size: 3rem;
            color: rgba(201, 169, 110, 0.4);
            margin-bottom: 16px;
        }
        .empty-state h3 {
            font-family: 'Playfair Display', serif;
            font-size: 1.5rem;
            color: #1C1917;
            margin-bottom: 8px;
        }
        .empty-state p {
            color: #6B6560;
            font-size: 0.9rem;
            margin-bottom: 24px;
        }
        .browse-link {
            display: inline-block;
            background: #C9A96E;
            color: #1C1917;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-weight: 700;
        }
        .browse-link:hover { background: #B8965B; }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-top">
            <div class="logo-section">
                <div class="logo">KHOJ</div>
                <div class="logo-subtitle">Tenant Portal</div>
            </div>
            <hr class="sidebar-divider">
            <div class="superuser-badge">
                <div class="superuser-avatar">${not empty sessionScope.user.fullName ? sessionScope.user.fullName.substring(0,1) : 'T'}</div>
                <div class="superuser-info">
                    <span class="superuser-name">${sessionScope.user.fullName}</span>
                    <span class="superuser-role">TENANT</span>
                </div>
            </div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/search"><i class="fa-solid fa-compass"></i> Property Discovery</a></li>
                <li><a href="${pageContext.request.contextPath}/my-bookings"><i class="fa-solid fa-bookmark"></i> My Applications</a></li>
                <li><a href="${pageContext.request.contextPath}/wishlist" class="active"><i class="fa-solid fa-heart"></i> My Wishlist</a></li>
                <li><a href="${pageContext.request.contextPath}/profile"><i class="fa-solid fa-user"></i> My Profile</a></li>
            </ul>
        </div>
        <div class="sidebar-bottom">
            <a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-power-off"></i> Secure Logout</a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <div class="header">
            <div class="header-left">
                <div class="header-eyebrow">Your Collections</div>
                <h1>My Saved Properties</h1>
            </div>
            <div class="count-pill">
                ${fn:length(wishlists)} PROPERTIES
            </div>
        </div>

        <div id="flashMessage" class="flash"></div>

        <c:choose>
            <c:when test="${empty wishlists}">
                <div class="empty-state">
                    <i class="fa-solid fa-heart-crack"></i>
                    <h3>No saved properties yet</h3>
                    <p>Start exploring listings and save the ones you love to view them later.</p>
                    <a class="browse-link" href="${pageContext.request.contextPath}/search">Browse Properties</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="wishlist-grid">
                    <c:forEach var="wishlist" items="${wishlists}">
                        <div class="wishlist-card">
                            <h3 class="property-title">${wishlist.propertyTitle}</h3>
                            <p class="price">Rs. ${wishlist.price} <small style="font-weight: 500; font-size: 0.8rem; color: #6B6560;">/month</small></p>

                            <div class="card-actions">
                                <a class="btn btn-view" href="${pageContext.request.contextPath}/property-detail?id=${wishlist.propertyId}">
                                    View Details
                                </a>

                                <form action="${pageContext.request.contextPath}/wishlist" method="post" style="flex:1;">
                                    <input type="hidden" name="action" value="remove">
                                    <input type="hidden" name="propertyId" value="${wishlist.propertyId}">
                                    <button type="submit" class="btn btn-remove">Remove</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script>
        (function () {
            const params = new URLSearchParams(window.location.search);
            const msg = params.get("msg");
            const error = params.get("error");
            const flashEl = document.getElementById("flashMessage");

            if (!flashEl) return;

            if (msg === "added" || msg === "removed") {
                flashEl.classList.add("success");
                flashEl.innerHTML = '<i class="fa-solid fa-circle-check"></i> ' + (msg === "added" ? "Property added to wishlist." : "Property removed from wishlist.");
                flashEl.style.display = "block";
            } else if (error) {
                flashEl.classList.add("error");
                let text = "Something went wrong. Please try again.";
                if (error === "remove_failed") text = "Could not remove property from wishlist.";
                else if (error === "add_failed") text = "Could not add property to wishlist.";
                else if (error === "invalid_property") text = "Invalid property selected.";
                
                flashEl.innerHTML = '<i class="fa-solid fa-circle-exclamation"></i> ' + text;
                flashEl.style.display = "block";
            }
        })();
    </script>
</body>
</html>
