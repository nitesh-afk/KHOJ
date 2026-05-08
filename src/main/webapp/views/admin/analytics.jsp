<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Platform Analytics | KHOJ Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;500;600;700&family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Inter', sans-serif;
            background-color: #FAF9F6;
            color: #1C1917;
            display: flex;
            min-height: 100vh;
        }

        :root {
            --gold: #C9A96E;
            --card-border: #EDE9E3;
            --muted: #6B6560;
            --dark: #1C1917;
            --green: #2D6A4F;
            --amber: #7B4F12;
            --red: #991B1B;
        }

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
        .logo { font-family: 'Playfair Display', serif; font-size: 1.8rem; color: var(--gold); }
        .logo-subtitle {
            font-size: 0.65rem;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: rgba(255, 255, 255, 0.3);
            margin-top: 4px;
            margin-bottom: 20px;
        }
        .nav-links { list-style: none; display: flex; flex-direction: column; gap: 8px; }
        .nav-links a {
            text-decoration: none;
            padding: 12px 16px;
            border-radius: 10px;
            display: block;
            color: rgba(255, 255, 255, 0.45);
            font-size: 0.9rem;
        }
        .nav-links a:hover { color: #FFFFFF; background: rgba(255, 255, 255, 0.05); }
        .nav-links a.active {
            color: #FFFFFF;
            background: #1C1917;
            border-left: 3px solid var(--gold);
            border-radius: 0 10px 10px 0;
        }
        .sidebar-bottom { margin-top: auto; }
        .sidebar-bottom a { color: rgba(255, 255, 255, 0.35); text-decoration: none; font-size: 0.9rem; }

        .main-content {
            margin-left: 260px;
            padding: 40px 48px;
            width: calc(100% - 260px);
        }
        .header { margin-bottom: 28px; }
        .header-eyebrow {
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--gold);
            margin-bottom: 8px;
        }
        .header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            font-weight: 700;
        }

        .section {
            background: #FFFFFF;
            border: 1px solid var(--card-border);
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 16px rgba(0, 0, 0, 0.05);
        }
        .section h2 {
            font-family: 'Playfair Display', serif;
            font-size: 1.25rem;
            margin-bottom: 16px;
        }

        .bar-list { display: flex; flex-direction: column; gap: 12px; }
        .bar-row { display: grid; grid-template-columns: 260px 1fr 70px; gap: 12px; align-items: center; }
        .bar-label { font-size: 0.9rem; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .bar-track {
            height: 14px;
            background: #F5F0E8;
            border-radius: 999px;
            overflow: hidden;
            border: 1px solid #E8D9BF;
        }
        .bar-fill {
            height: 100%;
            background: linear-gradient(90deg, #D4B27A, #C9A96E);
            border-radius: 999px;
            min-width: 6px;
        }
        .bar-count { text-align: right; font-weight: 700; color: var(--muted); font-size: 0.85rem; }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }
        .stat-card {
            border: 1px solid var(--card-border);
            border-radius: 12px;
            padding: 18px 16px;
            background: #fff;
        }
        .stat-title {
            font-size: 0.78rem;
            text-transform: uppercase;
            color: var(--muted);
            letter-spacing: 0.8px;
            margin-bottom: 8px;
            font-weight: 700;
        }
        .stat-value { font-size: 1.8rem; font-weight: 800; }
        .pending .stat-value { color: var(--amber); }
        .approved .stat-value { color: var(--green); }
        .rejected .stat-value { color: var(--red); }

        table { width: 100%; border-collapse: collapse; }
        th, td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--card-border);
            text-align: left;
            font-size: 0.9rem;
        }
        th {
            background: #F7F4EF;
            color: var(--muted);
            font-size: 0.72rem;
            letter-spacing: 1px;
            text-transform: uppercase;
        }
        tr:last-child td { border-bottom: none; }

        .btn {
            border-radius: 8px;
            padding: 7px 12px;
            font-size: 0.8rem;
            font-weight: 700;
            cursor: pointer;
            border: 1px solid transparent;
        }
        .btn-approve { background: #D8F3DC; color: #2D6A4F; border-color: #B7E4C7; }
        .btn-reject { background: #FFE4E4; color: #7B1D1D; border-color: #FFC9C9; }

        .empty { color: var(--muted); font-style: italic; padding: 10px 0; }
    </style>
</head>
<body>
<div class="sidebar">
    <div>
        <div class="logo">KHOJ</div>
        <div class="logo-subtitle">Admin Control</div>
        <ul class="nav-links">
            <li><a href="${pageContext.request.contextPath}/AdminServlet">Command Center</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/rooms">Property Moderation</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/users">User Governance</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/analytics" class="active">Analytics</a></li>
            <li><a href="${pageContext.request.contextPath}/home">Public Site</a></li>
        </ul>
    </div>
    <div class="sidebar-bottom">
        <a href="${pageContext.request.contextPath}/LogoutServlet">Shutdown Session</a>
    </div>
</div>

<div class="main-content">
    <div class="header">
        <div class="header-eyebrow">Platform Intelligence</div>
        <h1>Analytics Dashboard</h1>
    </div>

    <div class="section">
        <h2>Top 5 Most Applied Properties</h2>
        <c:choose>
            <c:when test="${empty topProperties}">
                <p class="empty">No application analytics available yet.</p>
            </c:when>
            <c:otherwise>
                <c:set var="maxCount" value="${topProperties[0].applicationCount}" />
                <c:if test="${maxCount <= 0}">
                    <c:set var="maxCount" value="1" />
                </c:if>
                <div class="bar-list">
                    <c:forEach var="property" items="${topProperties}">
                        <div class="bar-row">
                            <div class="bar-label">${property.propertyTitle}</div>
                            <div class="bar-track">
                                <div class="bar-fill" style="width: ${property.applicationCount * 100 / maxCount}%;"></div>
                            </div>
                            <div class="bar-count">${property.applicationCount}</div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="section">
        <h2>Application Status Breakdown</h2>
        <div class="stat-grid">
            <div class="stat-card pending">
                <div class="stat-title">Pending</div>
                <div class="stat-value">${statusBreakdown.PENDING}</div>
            </div>
            <div class="stat-card approved">
                <div class="stat-title">Approved</div>
                <div class="stat-value">${statusBreakdown.APPROVED}</div>
            </div>
            <div class="stat-card rejected">
                <div class="stat-title">Rejected</div>
                <div class="stat-value">${statusBreakdown.REJECTED}</div>
            </div>
        </div>
    </div>

    <div class="section">
        <h2>Monthly User Registrations</h2>
        <table>
            <thead>
            <tr>
                <th>Month</th>
                <th>User Count</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty monthlyUsers}">
                    <tr>
                        <td colspan="2" class="empty">No registration data found.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="entry" items="${monthlyUsers}">
                        <tr>
                            <td>${entry.month}</td>
                            <td>${entry.userCount}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>

    <div class="section">
        <h2>Pending Landlord Approvals</h2>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Full Name</th>
                <th>Email</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:choose>
                <c:when test="${empty pendingLandlords}">
                    <tr>
                        <td colspan="4" class="empty">No pending landlord approvals.</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="landlord" items="${pendingLandlords}">
                        <tr>
                            <td>#${landlord.id}</td>
                            <td>${landlord.fullName}</td>
                            <td>${landlord.email}</td>
                            <td>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="approveLandlord">
                                    <input type="hidden" name="userId" value="${landlord.id}">
                                    <button type="submit" class="btn btn-approve">Approve</button>
                                </form>
                                <form action="${pageContext.request.contextPath}/AdminServlet" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="rejectLandlord">
                                    <input type="hidden" name="userId" value="${landlord.id}">
                                    <button type="submit" class="btn btn-reject">Reject</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
