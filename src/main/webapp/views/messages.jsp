<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Message Center | KHOJ</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-primary: #FAF9F6;
            --nav-bg: #1C1917;
            --accent-gold: #C9A96E;
            --text-primary: #1C1917;
            --text-secondary: #6B6560;
            --glass-bg: rgba(255, 255, 255, 0.7);
            --glass-border: rgba(237, 233, 227, 0.6);
            --msg-sent: #1C1917;
            --msg-received: #F5F4F0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            margin: 0;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }

        .main-container {
            flex: 1;
            display: grid;
            grid-template-columns: 350px 1fr;
            max-width: 1400px;
            margin: 20px auto;
            width: 95%;
            background: var(--glass-bg);
            backdrop-filter: blur(15px);
            border: 1px solid var(--glass-border);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 32px rgba(0,0,0,0.05);
        }

        /* INBOX SIDEBAR */
        .inbox-sidebar {
            border-right: 1px solid var(--glass-border);
            display: flex;
            flex-direction: column;
            background: rgba(255,255,255,0.3);
        }

        .sidebar-header {
            padding: 24px;
            border-bottom: 1px solid var(--glass-border);
        }

        .sidebar-header h2 {
            margin: 0;
            font-size: 1.4rem;
            font-weight: 800;
        }

        .inbox-list {
            flex: 1;
            overflow-y: auto;
        }

        .inbox-item {
            padding: 16px 24px;
            border-bottom: 1px solid rgba(0,0,0,0.03);
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .inbox-item:hover {
            background: rgba(201, 169, 110, 0.05);
        }

        .inbox-item.active {
            background: rgba(201, 169, 110, 0.1);
            border-left: 4px solid var(--accent-gold);
        }

        .inbox-item .name { font-weight: 700; font-size: 0.95rem; display: flex; justify-content: space-between; align-items: center; }
        .inbox-item .property { font-size: 0.75rem; color: var(--accent-gold); text-transform: uppercase; letter-spacing: 0.5px; }
        .inbox-item .preview { font-size: 0.85rem; color: var(--text-secondary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .unread-dot { width: 8px; height: 8px; background: #ef4444; border-radius: 50%; display: inline-block; box-shadow: 0 0 8px rgba(239, 68, 68, 0.5); }
        .inbox-item.unread { background: rgba(201, 169, 110, 0.03); }
        .inbox-item.unread .name { color: #000; }
        .inbox-item.unread .preview { color: var(--text-primary); font-weight: 500; }

        /* CHAT WINDOW */
        .chat-window {
            display: flex;
            flex-direction: column;
            background: #FFFFFF;
        }

        .chat-header {
            padding: 16px 24px;
            border-bottom: 1px solid var(--glass-border);
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--glass-bg);
            backdrop-filter: blur(10px);
        }

        .chat-header .user-info h3 { margin: 0; font-size: 1.1rem; }
        .chat-header .user-info p { margin: 2px 0 0; font-size: 0.8rem; color: var(--text-secondary); }

        .chat-messages {
            flex: 1;
            padding: 24px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 16px;
            background: #FAF9F6;
        }

        .message-bubble {
            max-width: 70%;
            padding: 12px 18px;
            border-radius: 14px;
            font-size: 0.95rem;
            line-height: 1.5;
            position: relative;
        }

        .message-bubble.sent {
            align-self: flex-end;
            background: var(--msg-sent);
            color: #FFFFFF;
            border-bottom-right-radius: 2px;
        }

        .message-bubble.received {
            align-self: flex-start;
            background: var(--msg-received);
            color: var(--text-primary);
            border: 1px solid var(--glass-border);
            border-bottom-left-radius: 2px;
        }

        .message-time {
            font-size: 0.7rem;
            margin-top: 4px;
            opacity: 0.6;
            display: block;
            text-align: right;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 4px;
        }
        .read-status { color: var(--accent-gold); font-size: 0.7rem; font-weight: 700; }

        .chat-input-area {
            padding: 20px 24px;
            border-top: 1px solid var(--glass-border);
            background: #FFFFFF;
        }

        .chat-form {
            display: flex;
            gap: 12px;
        }

        .chat-form input {
            flex: 1;
            padding: 14px 20px;
            border-radius: 12px;
            border: 1px solid var(--card-border);
            background: #FAF9F6;
            font-family: inherit;
            outline: none;
            transition: border-color 0.2s;
        }

        .chat-form input:focus { border-color: var(--accent-gold); }

        .btn-send {
            background: var(--accent-gold);
            color: white;
            border: none;
            padding: 0 24px;
            border-radius: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: transform 0.1s;
        }

        .btn-send:active { transform: scale(0.95); }

        .empty-chat {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            color: var(--text-secondary);
            opacity: 0.5;
        }

        .empty-chat i { font-size: 4rem; margin-bottom: 16px; }
    </style>
</head>
<body>

    <header style="background: var(--nav-bg); padding: 15px 0;">
        <div style="width: 95%; max-width: 1400px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center;">
            <h2 style="margin: 0; color: var(--accent-gold); font-weight: 800; cursor: pointer;" onclick="window.location.href='home'">KHOJ</h2>
            <nav style="display: flex; gap: 20px; color: rgba(255,255,255,0.7); font-size: 0.9rem;">
                <a href="home" style="color: inherit; text-decoration: none;">Explore</a>
                <a href="${sessionScope.user.role == 'TENANT' ? 'tenant/dashboard' : 'landlord/dashboard'}" style="color: inherit; text-decoration: none;">Dashboard</a>
            </nav>
        </div>
    </header>

    <div class="main-container">
        <!-- Sidebar -->
        <div class="inbox-sidebar">
            <div class="sidebar-header">
                <h2>Messages</h2>
            </div>
            <div class="inbox-list">
                <c:forEach var="item" items="${inbox}">
                    <div class="inbox-item ${param.with == item.otherUserId && param.property == item.propertyId ? 'active' : ''} ${item.unreadCount > 0 ? 'unread' : ''}" 
                         onclick="window.location.href='messages?with=${item.otherUserId}&property=${item.propertyId}'">
                        <span class="property">${item.propertyTitle}</span>
                        <div class="name">
                            ${item.otherUserName}
                            <c:if test="${item.unreadCount > 0}">
                                <span class="unread-dot"></span>
                            </c:if>
                        </div>
                        <span class="preview">${item.lastMessage}</span>
                    </div>
                </c:forEach>
                <c:if test="${empty inbox}">
                    <div style="padding: 40px 24px; text-align: center; color: var(--text-secondary); font-size: 0.9rem;">
                        No conversations yet.
                    </div>
                </c:if>
            </div>
        </div>

        <!-- Chat Area -->
        <div class="chat-window">
            <c:choose>
                <c:when test="${not empty chat}">
                    <div class="chat-header">
                        <div class="user-info">
                            <h3>Conversation with ${chat[0].senderId == sessionScope.user.id ? chat[0].receiverName : chat[0].senderName}</h3>
                            <p>Regarding: <strong>${property.title}</strong></p>
                        </div>
                        <div class="property-link">
                            <a href="property-detail?id=${property.propertyId}" style="color: var(--accent-gold); font-weight: 600; text-decoration: none; font-size: 0.85rem;">View Property</a>
                        </div>
                    </div>

                    <div class="chat-messages" id="chatMessages">
                        <c:forEach var="msg" items="${chat}">
                            <div class="message-bubble ${msg.senderId == sessionScope.user.id ? 'sent' : 'received'}">
                                ${msg.content}
                                <span class="message-time">
                                    <fmt:formatDate value="${msg.sentAt}" pattern="HH:mm" />
                                    <c:if test="${msg.senderId == sessionScope.user.id}">
                                        <span class="read-status">
                                            <c:choose>
                                                <c:when test="${msg.read}"><i class="fa-solid fa-check-double"></i> Read</c:when>
                                                <c:otherwise><i class="fa-solid fa-check"></i> Sent</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </c:if>
                                </span>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="chat-input-area">
                        <form class="chat-form" action="messages" method="POST">
                            <input type="hidden" name="receiverId" value="${otherUserId}">
                            <input type="hidden" name="propertyId" value="${property.propertyId}">
                            <input type="text" name="content" placeholder="Type your message here..." required autocomplete="off">
                            <button type="submit" class="btn-send">Send</button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-chat">
                        <i class="fa-solid fa-comments"></i>
                        <p>Select a conversation to start chatting</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script>
        // Auto-scroll to bottom of chat
        const chatMessages = document.getElementById('chatMessages');
        if (chatMessages) {
            chatMessages.scrollTop = chatMessages.scrollHeight;
        }
    </script>

</body>
</html>
