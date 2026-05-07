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
    
    <style>
        .table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            padding: 20px;
            overflow-x: auto;
            margin-top: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            font-family: 'Inter', sans-serif;
        }
        th, td {
            padding: 16px;
            text-align: left;
            border-bottom: 1px solid #f1f5f9;
        }
        th {
            font-weight: 700;
            color: #475569;
            background-color: #f8fafc;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
        tr:hover {
            background-color: #f8fafc;
        }
        .status-unread {
            color: #b45309;
            background: #fef3c7;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
        }
        .status-archived {
            color: #475569;
            background: #f1f5f9;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
        }
        .btn-action {
            padding: 8px 14px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            transition: all 0.2s ease;
            font-size: 0.9rem;
        }
        .btn-archive {
            background: #fee2e2;
            color: #991b1b;
        }
        .btn-archive:hover {
            background: #ef4444;
            color: white;
            transform: translateY(-2px);
        }
        .message-body {
            max-width: 300px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: #475569;
        }
        .sender-info strong {
            color: #0f172a;
            font-size: 1rem;
        }
        .sender-info span {
            color: #64748b;
            font-size: 0.85rem;
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        
        <!-- Dashboard Sidebar -->
        <aside class="sidebar">
            <div class="sidebar-brand">Admin Panel</div>
            <ul class="sidebar-nav">
                <li><a href="${pageContext.request.contextPath}/AdminServlet"><i class="fa-solid fa-chart-line"></i> Dashboard</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/rooms"><i class="fa-solid fa-house"></i> Manage Rooms</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/users"><i class="fa-solid fa-users"></i> Manage Users</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/messages" class="active"><i class="fa-solid fa-envelope"></i> Message Center</a></li>
            </ul>
        </aside>

        <!-- Main Content Area -->
        <main class="main-content">
            <div class="header-area">
                <h1>Message Center</h1>
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
                                <td style="font-weight: 600;">${msg.subject}</td>
                                <td class="message-body" title="${msg.messageBody}">${msg.messageBody}</td>
                                <td>
                                    <span class="status-${msg.status.toLowerCase()}">${msg.status}</span>
                                </td>
                                <td>
                                    <c:if test="${msg.status != 'ARCHIVED'}">
                                        <form action="${pageContext.request.contextPath}/AdminServlet" method="POST" style="margin:0;">
                                            <input type="hidden" name="action" value="updateMessageStatus">
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
