<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add New Room | KHOJ</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .form-container {
            max-width: 600px;
            background: white;
            padding: 2rem;
            border-radius: 1rem;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            margin-top: 2rem;
        }
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.5rem;
        }
        .form-group-full {
            grid-column: span 2;
        }
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            font-size: 0.875rem;
        }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            font-size: 1rem;
            box-sizing: border-box;
        }
        .form-actions {
            margin-top: 2rem;
            display: flex;
            gap: 1rem;
        }
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.5rem;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            border: none;
        }
        .btn-primary { background: #2563eb; color: white; }
        .btn-secondary { background: #f1f5f9; color: #64748b; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-logo">KHOJ Landlord</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/LandlordDashboard">Dashboard</a></li>
            <li><a href="${pageContext.request.contextPath}/my-rooms">My Rooms</a></li>
            <li><a href="${pageContext.request.contextPath}/views/landlord/add-room.jsp" class="active">Add New Room</a></li>
            <li><a href="${pageContext.request.contextPath}/applications">Applications</a></li>
            <li><a href="${pageContext.request.contextPath}/views/auth/login.jsp" style="margin-top: 2rem; color: #ef4444;">Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <h1>Add New Room Listing</h1>
        </div>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/RoomServlet" method="post">
                <div class="form-grid">
                    <div class="form-group-full">
                        <label for="title">Property Title</label>
                        <input type="text" id="title" name="title" placeholder="e.g., Luxury Single Room near University" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="price">Monthly Rent (Rs.)</label>
                        <input type="number" id="price" name="price" placeholder="5000" required>
                    </div>

                    <div class="form-group">
                        <label for="roomType">Room Type</label>
                        <select id="roomType" name="roomType">
                            <option value="Single">Single Room</option>
                            <option value="Double">Double Room</option>
                            <option value="Flat">Full Flat</option>
                            <option value="Hostel">Hostel Bed</option>
                        </select>
                    </div>

                    <div class="form-group-full">
                        <label for="location">Location / Area</label>
                        <input type="text" id="location" name="location" placeholder="e.g., Koteshwor, Kathmandu" required>
                    </div>

                    <div class="form-group-full">
                        <label for="imageUrl">Image URL (Optional)</label>
                        <input type="text" id="imageUrl" name="imageUrl" placeholder="https://example.com/room.jpg">
                    </div>

                    <div class="form-group-full">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="4" placeholder="Mention amenities like WiFi, Water, Parking..."></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Publish Listing</button>
                    <a href="${pageContext.request.contextPath}/LandlordDashboard" class="btn btn-secondary">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
