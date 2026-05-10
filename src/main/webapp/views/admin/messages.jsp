<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message Center | Admin Dashboard</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Using the global style and dashboard CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css">
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
                    <div class="header-eyebrow">Communication Intelligence</div>
                    <h1>Message Center</h1>
                </div>
                <div class="header-badge">
                    <i class="fa-solid fa-envelope"></i> ${messages.size()} INQUIRIES
                </div>
            </div>

            <c:if test="${param.msg == 'status_updated'}">
                <div style="background-color: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; padding: 12px 20px; border-radius: 8px; margin-top: 20px; font-weight: 600; display: flex; align-items: center; gap: 10px;">
                    <i class="fa-solid fa-circle-check"></i> Status Updated Successfully!
                </div>
            </c:if>

            <div class="table-container">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Date</th>
                            <th>Sender</th>
                            <th>Subject</th>
                            <th>Message</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${messages}" var="msg">
                            <tr>
                                <td>#${msg.id}</td>
                                <td><span style="font-size:0.85rem; color:#64748b;">${msg.createdAt}</span></td>
                                <td class="sender-info">
                                    <strong>${msg.fullName}</strong><br>
                                    <span>${msg.email}</span>
                                </td>
                                <td style="font-weight: 600;">
                                    <a href="${pageContext.request.contextPath}/admin/message-detail?id=${msg.id}" style="text-decoration: none; color: inherit; border-bottom: 1px dashed #cbd5e1;">
                                        ${msg.subject}
                                    </a>
                                </td>
                                <td class="message-body" title="${msg.messageBody}">
                                    <a href="${pageContext.request.contextPath}/admin/message-detail?id=${msg.id}" style="text-decoration: none; color: inherit;">
                                        ${msg.messageBody}
                                    </a>
                                </td>
                                <td>
                                    <span class="status-${msg.status.toLowerCase()}">${msg.status}</span>
                                </td>
                                <td>
                                    <c:if test="${msg.status != 'ARCHIVED'}">
                                        <form action="${pageContext.request.contextPath}/admin/update-message-status" method="POST" style="margin:0;">
                                            <input type="hidden" name="messageId" value="${msg.id}">
                                            <input type="hidden" name="status" value="ARCHIVED">
                                            <button type="submit" class="btn-action btn-archive">
                                                <i class="fa-solid fa-box-archive"></i> Archive
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${msg.status == 'ARCHIVED'}">
                                        <span style="color: #94a3b8; font-size: 0.9rem; font-style: italic;">Archived</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty messages}">
                            <tr>
                                <td colspan="6" style="text-align:center; padding: 40px; color: #64748b;">
                                    <i class="fa-solid fa-inbox" style="font-size: 2rem; margin-bottom: 10px; display: block;"></i>
                                    No messages found in the inbox.
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
