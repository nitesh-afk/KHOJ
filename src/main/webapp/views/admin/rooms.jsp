<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Room Moderation | KHOJ Admin</title>
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
            margin-bottom: 40px;
        }
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
        .header p.subtitle {
            font-family: 'Inter', sans-serif;
            font-size: 0.95rem;
            color: #6B6560;
            margin-top: 8px;
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

        /* Buttons */
        .btn {
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: transform 0.3s cubic-bezier(0.25, 0.46, 0.45, 0.94);
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn:hover { transform: translateY(-1px); }
        .btn-approve-lg {
            background: #C9A96E;
            color: #1C1917;
            border: none;
            padding: 8px 18px;
            font-weight: 700;
            font-size: 0.85rem;
        }
        .btn-revoke-lg {
            background: #F0EDE8;
            color: #6B6560;
            border: 1px solid #EDE9E3;
            padding: 8px 18px;
            font-weight: 600;
            font-size: 0.85rem;
        }

        /* Empty State */
        .empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 0;
            color: #C9A96E;
        }
        .empty-state i {
            font-size: 3rem;
            opacity: 0.6;
            margin-bottom: 16px;
        }
        .empty-state p {
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            color: #6B6560;
            font-weight: 500;
        }
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
                <li><a href="${pageContext.request.contextPath}/AdminServlet"><i class="fa-solid fa-gauge-high"></i> Command Center</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/rooms" class="active"><i class="fa-solid fa-building"></i> Property Moderation</a></li>
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
            <div class="header-eyebrow">Admin Control</div>
            <h1>Property Moderation Queue</h1>
            <p class="subtitle">Review and approve or revoke property listings below.</p>
        </div>

        <div class="section-wrapper">
            <c:choose>
                <c:when test="${empty rooms}">
                    <div class="empty-state">
                        <i class="fa-solid fa-building"></i>
                        <p>No properties in the moderation queue</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>Listing</th>
                                <th>Location</th>
                                <th>Price</th>
                                <th>Approval Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="room" items="${rooms}">
                                <tr>
                                    <td>
                                        <div class="cell-bold">${room.title}</div>
                                        <div class="cell-muted">Owner ID: #${room.ownerId}</div>
                                    </td>
                                    <td>${room.location}</td>
                                    <td>Rs. ${room.price}</td>
                                    <td>
                                        <span class="badge ${room.approved ? 'badge-success' : 'badge-warning'}">
                                            ${room.approved ? 'APPROVED' : 'PENDING APPROVAL'}
                                        </span>
                                    </td>
                                    <td>
                                        <c:if test="${!room.approved}">
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="approveRoom">
                                                <input type="hidden" name="roomId" value="${room.id}">
                                                <input type="hidden" name="approve" value="true">
                                                <button type="submit" class="btn btn-approve-lg">Approve Listing</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${room.approved}">
                                            <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display: inline;">
                                                <input type="hidden" name="action" value="approveRoom">
                                                <input type="hidden" name="roomId" value="${room.id}">
                                                <input type="hidden" name="approve" value="false">
                                                <button type="submit" class="btn btn-revoke-lg">Revoke</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
