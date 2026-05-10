<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Message Details | Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
    <style>
        .detail-card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            padding: 40px;
            margin-top: 30px;
            max-width: 800px;
        }
        .message-meta {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 1px solid #f1f5f9;
            padding-bottom: 24px;
            margin-bottom: 24px;
        }
        .meta-info h2 { font-size: 1.5rem; color: #0f172a; margin-bottom: 8px; }
        .meta-info p { color: #64748b; font-size: 0.95rem; }
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
        }
        .status-new { background: #fef3c7; color: #b45309; }
        .status-read { background: #dcfce7; color: #15803d; }
        .status-archived { background: #f1f5f9; color: #475569; }
        
        .message-content {
            line-height: 1.8;
            color: #334155;
            font-size: 1.1rem;
            white-space: pre-wrap;
            background: #f8fafc;
            padding: 30px;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
        }
        .action-bar {
            display: flex;
            gap: 15px;
            margin-top: 40px;
        }
        .btn-back {
            background: #f1f5f9;
            color: #475569;
            text-decoration: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.2s;
        }
        .btn-back:hover { background: #e2e8f0; }
        .btn-archive-detail {
            background: #fee2e2;
            color: #991b1b;
            border: none;
            padding: 12px 24px;
            border-radius: 10px;
            font-weight: 600;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            transition: all 0.2s;
        }
        .btn-archive-detail:hover { background: #ef4444; color: white; }
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
                <li><a href="${pageContext.request.contextPath}/admin/dashboard"><i class="fa-solid fa-gauge-high"></i> Command Center</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/rooms"><i class="fa-solid fa-building"></i> Property Moderation</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users"></i> User Governance</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/messages" class="active"><i class="fa-solid fa-envelope"></i> Message Center</a></li>
                <li><a href="${pageContext.request.contextPath}/home"><i class="fa-solid fa-earth-asia"></i> Public Site</a></li>
            </ul>
        </div>
        <div class="sidebar-bottom">
            <a href="${pageContext.request.contextPath}/LogoutServlet"><i class="fa-solid fa-power-off"></i> Shutdown Session</a>
        </div>
    </div>

    <main class="main-content">
        <div class="header">
            <div class="header-left">
                <div class="header-eyebrow">Message Intelligence</div>
                <h1>Inquiry Details</h1>
            </div>
            <div class="header-badge">
                <i class="fa-solid fa-shield-halved"></i> SECURE VIEW
            </div>
        </div>

            <div class="detail-card">
                <div class="message-meta">
                    <div class="meta-info">
                        <h2>${message.subject}</h2>
                        <p>From: <strong>${message.fullName}</strong> (${message.email})</p>
                        <p>Received: ${message.createdAt}</p>
                    </div>
                    <span class="status-badge status-${message.status.toLowerCase()}">${message.status}</span>
                </div>

                <div class="message-content">${message.messageBody}</div>

                <div class="action-bar">
                    <a href="${pageContext.request.contextPath}/admin/messages" class="btn-back">
                        <i class="fa-solid fa-arrow-left"></i> Back to Inbox
                    </a>
                    <c:if test="${message.status != 'ARCHIVED'}">
                        <form action="${pageContext.request.contextPath}/admin/dashboard" method="POST" style="margin:0;">
                            <input type="hidden" name="action" value="updateMessageStatus">
                            <input type="hidden" name="messageId" value="${message.id}">
                            <input type="hidden" name="status" value="ARCHIVED">
                            <button type="submit" class="btn-archive-detail">
                                <i class="fa-solid fa-box-archive"></i> Archive Message
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>
        </main>
    </div>
</body>
</html>
