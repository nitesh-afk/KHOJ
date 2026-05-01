<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add New Room | KHOJ</title>
    <!-- Google Fonts & FontAwesome -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --bg-primary: #FAF9F6;
            --sidebar-bg: #1C1917;
            --sidebar-active: #2C2925;
            --sidebar-text: rgba(255,255,255,0.55);
            --sidebar-text-hover: #FFFFFF;
            --accent-gold: #C9A96E;
            --text-primary: #1C1917;
            --text-secondary: #6B6560;
            --card-surface: #FFFFFF;
            --card-border: #EDE9E3;
            --transition-premium: all 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            display: flex;
        }

        h1, h2, h3, .sidebar-logo {
            font-family: 'Playfair Display', serif;
        }

        /* SIDEBAR */
        .sidebar {
            width: 260px;
            background-color: var(--sidebar-bg);
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            display: flex;
            flex-direction: column;
            padding: 30px 20px;
            box-sizing: border-box;
        }

        .sidebar-logo {
            font-size: 1.6rem;
            color: var(--accent-gold);
            margin: 0;
        }

        .sidebar-tagline {
            font-family: 'Inter', sans-serif;
            font-size: 0.7rem;
            color: rgba(255,255,255,0.4);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 40px;
            display: block;
        }

        .nav-links {
            list-style: none;
            padding: 0;
            margin: 0;
            flex-grow: 1;
        }

        .nav-links li {
            margin-bottom: 8px;
        }

        .nav-links a {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px 16px;
            border-radius: 10px;
            text-decoration: none;
            color: var(--sidebar-text);
            font-size: 0.95rem;
            font-weight: 500;
            transition: var(--transition-premium);
        }

        .nav-links a i {
            width: 20px;
            font-size: 0.9rem;
            text-align: center;
        }

        .nav-links a:hover {
            color: var(--sidebar-text-hover);
            background: rgba(255,255,255,0.06);
        }

        .nav-links a.active {
            color: var(--sidebar-text-hover);
            background: var(--sidebar-active);
            border-left: 3px solid var(--accent-gold);
            border-radius: 0 10px 10px 0;
        }

        .sidebar-bottom {
            border-top: 1px solid rgba(255,255,255,0.1);
            padding-top: 20px;
            margin-top: auto;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 15px;
        }

        .user-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: var(--accent-gold);
            color: var(--text-primary);
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
        }

        .user-info {
            display: flex;
            flex-direction: column;
        }

        .user-name {
            color: white;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .user-role {
            color: rgba(255,255,255,0.45);
            font-size: 0.7rem;
        }

        .logout-link {
            color: rgba(255,255,255,0.45);
            text-decoration: none;
            font-size: 0.85rem;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: var(--transition-premium);
        }

        .logout-link:hover {
            color: #FFB4A2;
        }

        /* MAIN CONTENT */
        .main-content {
            margin-left: 260px;
            padding: 40px 48px;
            background-color: var(--bg-primary);
            min-height: 100vh;
            width: 100%;
            box-sizing: border-box;
        }

        .header {
            margin-bottom: 40px;
        }

        .header h1 {
            font-size: 2rem;
            color: var(--text-primary);
            margin: 0 0 8px 0;
        }

        .header .subtitle {
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            color: var(--text-secondary);
            margin: 0;
        }

        /* FORM STYLES */
        .form-card {
            background: var(--card-surface);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 40px;
            max-width: 780px;
            box-shadow: 0 2px 16px rgba(0,0,0,0.05);
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }

        .form-group-full {
            grid-column: span 2;
        }

        .form-group label, .form-group-full label {
            display: block;
            font-family: 'Inter', sans-serif;
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 8px;
        }

        .form-group input, 
        .form-group select, 
        .form-group-full input, 
        .form-group-full textarea {
            width: 100%;
            box-sizing: border-box;
            padding: 13px 16px;
            border: 1px solid var(--card-border);
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            color: var(--text-primary);
            background: var(--card-surface);
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-group select, .form-group-full select {
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%231C1917' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 16px;
            padding-right: 40px;
            width: 100%;
            box-sizing: border-box;
            padding: 13px 16px;
            border: 1px solid var(--card-border);
            border-radius: 10px;
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            color: var(--text-primary);
            background-color: var(--card-surface);
            outline: none;
            transition: border-color 0.2s ease, box-shadow 0.2s ease;
        }

        .form-group input:focus, 
        .form-group select:focus, 
        .form-group-full input:focus, 
        .form-group-full select:focus,
        .form-group-full textarea:focus {
            border-color: var(--accent-gold);
            box-shadow: 0 0 0 3px rgba(201, 169, 110, 0.15);
        }

        .form-group-full textarea {
            min-height: 120px;
            resize: vertical;
        }

        .form-actions {
            display: flex;
            gap: 16px;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 1px solid var(--card-border);
        }

        .btn-publish {
            background: var(--accent-gold);
            color: var(--text-primary);
            font-family: 'Inter', sans-serif;
            font-weight: 800;
            padding: 14px 36px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            font-size: 1rem;
            letter-spacing: 0.3px;
            transition: var(--transition-premium);
        }

        .btn-publish:hover {
            background: #B8935A;
            transform: translateY(-1px);
        }

        .btn-cancel {
            background: #F7F4EF;
            color: var(--text-secondary);
            font-family: 'Inter', sans-serif;
            font-weight: 600;
            padding: 14px 28px;
            border-radius: 10px;
            text-decoration: none;
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
            transition: var(--transition-premium);
        }

        .btn-cancel:hover {
            background: var(--card-border);
            transform: translateY(-1px);
        }
    </style>
</head>
<body>

    <div class="sidebar">
        <h2 class="sidebar-logo">KHOJ</h2>
        <span class="sidebar-tagline">Landlord Portal</span>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/LandlordDashboard"><i class="fa-solid fa-gauge-high"></i> Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/my-rooms"><i class="fa-solid fa-door-open"></i> My Rooms</a></li>
            <li><a href="${pageContext.request.contextPath}/views/landlord/add-room.jsp" class="active"><i class="fa-solid fa-circle-plus"></i> Add Listing</a></li>
            <li><a href="${pageContext.request.contextPath}/applications"><i class="fa-solid fa-inbox"></i> Applications</a></li>
        </ul>
        <div class="sidebar-bottom">
            <div class="user-profile">
                <div class="user-avatar">${fn:substring(sessionScope.user.fullName, 0, 1)}</div>
                <div class="user-info">
                    <span class="user-name">${sessionScope.user.fullName}</span>
                    <span class="user-role">Landlord</span>
                </div>
            </div>
            <a href="${pageContext.request.contextPath}/LogoutServlet" class="logout-link"><i class="fa-solid fa-right-from-bracket"></i> Sign out</a>
        </div>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Add New Listing</h1>
            <c:if test="${not empty param.error}">
              <div style="background:#FFE4E4; border-left:4px solid #E24B4A; 
                           border-radius:0 10px 10px 0; color:#7B1D1D; 
                           padding:14px 20px; margin-top:16px; margin-bottom:24px; font-weight:600;">
                <c:choose>
                  <c:when test="${param.error == 'missing_fields'}">
                    Please fill in all required fields including neighborhood and property type.
                  </c:when>
                  <c:when test="${param.error == 'invalid_number'}">
                    Invalid input. Please check all numeric fields.
                  </c:when>
                  <c:when test="${param.error == 'failed'}">
                    Failed to save the listing. Please try again.
                  </c:when>
                </c:choose>
              </div>
            </c:if>
            <p class="subtitle">Fill in the details below to publish your property on KHOJ.</p>
        </div>

        <div class="form-card">
            <form action="${pageContext.request.contextPath}/RoomServlet" method="post">
                <div class="form-grid">
                    <div class="form-group-full">
                        <label for="title">Property Title</label>
                        <input type="text" id="title" name="title" placeholder="e.g., Luxury Single Room near University" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="price">Rent/Rate (Rs.)</label>
                        <input type="number" id="price" name="price" placeholder="5000" required>
                    </div>

                    <div class="form-group">
                        <label for="priceModel">Price Model</label>
                        <select id="priceModel" name="priceModel" required>
                            <option value="Monthly">Monthly Rent</option>
                            <option value="Daily">Daily Rate</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="typeId">Property Type</label>
                        <select id="typeId" name="typeId" required>
                            <option value="">Select type...</option>
                            <option value="1">Apartment</option>
                            <option value="2">Hostel</option>
                            <option value="3">Hotel</option>
                            <option value="4">Villa</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="furnishingStatus">Furnishing Status</label>
                        <select id="furnishingStatus" name="furnishingStatus" required>
                            <option value="Fully Furnished">Fully Furnished</option>
                            <option value="Semi Furnished">Semi Furnished</option>
                            <option value="Unfurnished">Unfurnished</option>
                        </select>
                    </div>

                    <div class="form-group-full">
                        <label for="neighborhoodId">Location / Area</label>
                        <select id="neighborhoodId" name="neighborhoodId" required>
                            <option value="">Select neighborhood...</option>
                            <option value="1">Thamel, Kathmandu</option>
                            <option value="2">Koteshwor, Kathmandu</option>
                            <option value="3">Lakeside, Pokhara</option>
                            <option value="4">Mahendrapool, Pokhara</option>
                            <option value="5">Biratnagar City, Biratnagar</option>
                            <option value="6">Dharan Bazaar, Dharan</option>
                        </select>
                    </div>

                    <div class="form-group-full">
                        <label for="imageUrl">Image URL (Optional)</label>
                        <input type="text" id="imageUrl" name="imageUrl" placeholder="https://example.com/room.jpg">
                    </div>

                    <div class="form-group-full">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" placeholder="Mention amenities like WiFi, Water, Parking..."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn-publish">Publish Listing</button>
                    <a href="${pageContext.request.contextPath}/LandlordDashboard" class="btn-cancel">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
