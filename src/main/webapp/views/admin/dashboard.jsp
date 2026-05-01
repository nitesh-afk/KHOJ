<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Master Command Center | KHOJ Admin</title>
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
        .sidebar-bottom a i {
            width: 16px;
            text-align: center;
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
            font-size: 2rem;
            color: #1C1917;
            font-weight: 700;
        }
        .header-badge {
            background: #1C1917;
            color: #C9A96E;
            border: 1px solid rgba(201, 169, 110, 0.4);
            border-radius: 20px;
            padding: 8px 18px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Stat Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: #FFFFFF;
            border: 1px solid #EDE9E3;
            border-radius: 16px;
            padding: 28px 24px;
            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.05);
            transition: transform 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }
        .stat-card:hover { transform: scale(1.02); }
        .stat-card.card-users { border-bottom: 3px solid #2563EB; }
        .stat-card.card-rooms { border-bottom: 3px solid #C9A96E; }
        .stat-card.card-pending { border-bottom: 3px solid #B91C1C; }

        .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            margin-bottom: 24px;
        }
        .stat-card.card-users .stat-icon { background: #E8F4FD; color: #2563EB; }
        .stat-card.card-rooms .stat-icon { background: #FFF3DC; color: #C9A96E; }
        .stat-card.card-pending .stat-icon { background: #FFE4E4; color: #B91C1C; }

        .stat-number {
            font-family: 'Inter', sans-serif;
            font-size: 2.2rem;
            font-weight: 800;
            line-height: 1.2;
            margin-bottom: 4px;
        }
        .stat-card.card-users .stat-number,
        .stat-card.card-rooms .stat-number { color: #1C1917; }
        .stat-card.card-pending .stat-number { color: #B91C1C; }

        .stat-label {
            font-family: 'Inter', sans-serif;
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #6B6560;
        }

        /* Sections & Tables */
        .section-wrapper {
            background: #FFFFFF;
            border: 1px solid #EDE9E3;
            border-radius: 16px;
            padding: 28px;
            margin-bottom: 32px;
            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.05);
        }
        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
        }
        .section-header h2 {
            font-family: 'Playfair Display', serif;
            font-size: 1.3rem;
            color: #1C1917;
            font-weight: 600;
        }
        .live-pill {
            background: #D8F3DC;
            color: #2D6A4F;
            border-radius: 20px;
            padding: 4px 12px;
            font-size: 0.72rem;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .live-dot {
            width: 6px;
            height: 6px;
            background: #2D6A4F;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0%, 100% { opacity: 0.5; }
            50% { opacity: 1; }
        }

        table { width: 100%; border-collapse: collapse; }
        th {
            background: #F7F4EF;
            font-family: 'Inter', sans-serif;
            font-size: 0.7rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #6B6560;
            font-weight: 600;
            padding: 12px 16px;
            text-align: left;
        }
        th:first-child { border-top-left-radius: 8px; border-bottom-left-radius: 8px; }
        th:last-child { border-top-right-radius: 8px; border-bottom-right-radius: 8px; }

        td {
            padding: 14px 16px;
            font-family: 'Inter', sans-serif;
            font-size: 0.9rem;
            color: #1C1917;
            border-bottom: 1px solid #EDE9E3;
            transition: background 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }
        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #FDFAF6; }

        .cell-bold { font-weight: 600; }
        .cell-muted { color: #6B6560; font-size: 0.8rem; margin-top: 4px; }

        /* Badges */
        .badge {
            border-radius: 6px;
            padding: 4px 10px;
            font-size: 0.7rem;
            font-weight: 700;
            text-transform: uppercase;
            display: inline-block;
        }
        .badge-success { background: #D8F3DC; color: #2D6A4F; }
        .badge-warning { background: #FFF3CD; color: #7B4F12; }
        .badge-danger { background: #FFE4E4; color: #7B1D1D; }
        .badge-role { background: #F0EDE8; color: #6B6560; }

        /* Buttons */
        .btn {
            border-radius: 8px;
            padding: 7px 14px;
            font-family: 'Inter', sans-serif;
            font-size: 0.8rem;
            font-weight: 600;
            cursor: pointer;
            border: 1px solid transparent;
            transition: transform 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn:hover { transform: translateY(-1px); }
        .btn-approve { background: #D8F3DC; color: #2D6A4F; border-color: #B7E4C7; }
        .btn-revoke { background: #FFF3CD; color: #7B4F12; border-color: #FFE08A; }
        .btn-deactivate { background: #FFF3CD; color: #7B4F12; border-color: #FFE08A; }
        .btn-delete { background: #FFE4E4; color: #7B1D1D; border-color: #FFC9C9; }
    </style>
</head>
<body>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <div class="sidebar-top">
            <div class="logo-section">
                <div class="logo">KHOJ</div>
                <div class="logo-subtitle">Admin Control</div>
            </div>
            <hr class="sidebar-divider">
            <div class="superuser-badge">
                <div class="superuser-avatar">A</div>
                <div class="superuser-info">
                    <span class="superuser-name">System Admin</span>
                    <span class="superuser-role">SUPERUSER</span>
                </div>
            </div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/AdminServlet" class="active"><i class="fa-solid fa-gauge-high"></i> Command Center</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/rooms"><i class="fa-solid fa-building"></i> Property Moderation</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users"></i> User Governance</a></li>
                <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-earth-asia"></i> Public Site</a></li>
            </ul>
        </div>
        <div class="sidebar-bottom">
            <a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-power-off"></i> Shutdown Session</a>
        </div>
    </div>

    <!-- MAIN CONTENT -->
    <div class="main-content">
        <div class="header">
            <div class="header-left">
                <div class="header-eyebrow">System Intelligence</div>
                <h1>Command Center</h1>
            </div>
            <div class="header-badge">
                <i class="fa-solid fa-shield-halved"></i> SUPERUSER
            </div>
        </div>

        <!-- Global Statistics -->
        <div class="stats-grid">
            <div class="stat-card card-users">
                <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
                <div class="stat-number">${stats.totalUsers}</div>
                <div class="stat-label">Total Users</div>
            </div>
            <div class="stat-card card-rooms">
                <div class="stat-icon"><i class="fa-solid fa-building"></i></div>
                <div class="stat-number">${stats.totalRooms}</div>
                <div class="stat-label">Total Properties</div>
            </div>
            <div class="stat-card card-pending">
                <div class="stat-icon"><i class="fa-regular fa-clock"></i></div>
                <div class="stat-number">${stats.pendingApps}</div>
                <div class="stat-label">Pending Applications</div>
            </div>
        </div>

        <!-- Property Moderation Section -->
        <div class="section-wrapper">
            <div class="section-header">
                <h2>Property Moderation Queue</h2>
                <div class="live-pill">
                    <div class="live-dot"></div> Live
                </div>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Property</th>
                        <th>Location</th>
                        <th>Price</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="room" items="${rooms}">
                        <tr>
                            <td class="cell-bold">${room.title}</td>
                            <td>${room.location}</td>
                            <td>Rs. ${room.price}</td>
                            <td>
                                <span class="badge ${room.approved ? 'badge-success' : 'badge-warning'}">
                                    ${room.approved ? 'PUBLIC' : 'HELD'}
                                </span>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="approveRoom">
                                    <input type="hidden" name="roomId" value="${room.id}">
                                    <input type="hidden" name="approve" value="${!room.approved}">
                                    <button type="submit" class="btn ${room.approved ? 'btn-revoke' : 'btn-approve'}">
                                        ${room.approved ? 'Revoke' : 'Approve'}
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- User Governance Section -->
        <div class="section-wrapper">
            <div class="section-header">
                <h2>User Governance</h2>
            </div>
            <table>
                <thead>
                    <tr>
                        <th>Identity</th>
                        <th>Role</th>
                        <th>State</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr>
                            <td>
                                <div class="cell-bold">${u.fullName}</div>
                                <div class="cell-muted">${u.email}</div>
                            </td>
                            <td><span class="badge badge-role">${u.role}</span></td>
                            <td>
                                <span class="badge ${u.status == 'ACTIVE' ? 'badge-success' : 'badge-warning'}">
                                    ${u.status}
                                </span>
                            </td>
                            <td>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="deactivateUser">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <button type="submit" class="btn btn-deactivate">Deactivate</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="deleteUser">
                                    <input type="hidden" name="userId" value="${u.id}">
                                    <button type="submit" class="btn btn-delete" onclick="return confirm('Nuclear Option: Delete user?')">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
