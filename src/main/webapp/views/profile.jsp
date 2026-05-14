<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home Base | ${profileUser.fullName}</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --glass-bg: rgba(255, 255, 255, 0.7);
            --glass-border: rgba(255, 255, 255, 0.3);
            --accent: #C9A96E;
            --accent-glow: rgba(201, 169, 110, 0.3);
            --text-main: #1C1917;
            --text-muted: #6B6560;
            --success: #10B981;
            --error: #EF4444;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: radial-gradient(circle at top left, #FDFCFB 0%, #E2D1C3 100%);
            color: var(--text-main);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        /* Abstract background shapes for glassmorphism pop */
        .bg-shape {
            position: fixed;
            z-index: -1;
            border-radius: 50%;
            filter: blur(80px);
        }
        .shape-1 { width: 400px; height: 400px; background: #FDE68A; top: -100px; right: -100px; opacity: 0.4; }
        .shape-2 { width: 300px; height: 300px; background: #C9A96E; bottom: 100px; left: -50px; opacity: 0.2; }

        .navbar {
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            backdrop-filter: blur(10px);
            background: rgba(255,255,255,0.2);
            border-bottom: 1px solid var(--glass-border);
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .brand {
            font-family: 'Playfair Display', serif;
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-main);
            text-decoration: none;
            letter-spacing: -1px;
        }

        .main-container {
            flex: 1;
            max-width: 1100px;
            margin: 40px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 350px 1fr;
            gap: 30px;
        }

        /* Left Side: Profile Card */
        .profile-card {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            padding: 40px 30px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
            height: fit-content;
        }

        .avatar-container {
            width: 140px;
            height: 140px;
            margin: 0 auto 24px;
            position: relative;
        }

        .avatar {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid #fff;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .status-dot {
            width: 18px;
            height: 18px;
            background: var(--success);
            border: 3px solid #fff;
            border-radius: 50%;
            position: absolute;
            bottom: 5px;
            right: 15px;
        }

        .user-name {
            font-size: 1.5rem;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .role-badge {
            display: inline-block;
            padding: 6px 16px;
            border-radius: 100px;
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 30px;
        }
        .badge-landlord { background: #EEF2FF; color: #4F46E5; }
        .badge-tenant { background: #ECFDF5; color: #059669; }

        .stats-grid {
            display: grid;
            grid-template-columns: 1fr;
            gap: 15px;
            margin-top: 20px;
            border-top: 1px solid var(--glass-border);
            padding-top: 25px;
        }

        .stat-item {
            padding: 15px;
            background: rgba(255,255,255,0.4);
            border-radius: 16px;
            text-align: left;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .stat-icon {
            width: 40px;
            height: 40px;
            border-radius: 12px;
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--accent);
            font-size: 1.2rem;
        }

        .stat-info .stat-value {
            font-size: 1.1rem;
            font-weight: 700;
            display: block;
        }

        .stat-info .stat-label {
            font-size: 0.75rem;
            color: var(--text-muted);
            font-weight: 600;
        }

        /* Right Side: Edit Sections */
        .content-area {
            display: flex;
            flex-direction: column;
            gap: 30px;
        }

        .glass-panel {
            background: var(--glass-bg);
            backdrop-filter: blur(20px);
            border: 1px solid var(--glass-border);
            border-radius: 24px;
            padding: 35px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.03);
        }

        .section-title {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .input-group {
            margin-bottom: 20px;
        }

        .input-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-muted);
            margin-bottom: 8px;
            margin-left: 5px;
        }

        .input-group input {
            width: 100%;
            padding: 14px 18px;
            border-radius: 14px;
            border: 1px solid var(--glass-border);
            background: rgba(255,255,255,0.5);
            font-family: inherit;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            outline: none;
        }

        .input-group input:focus {
            background: #fff;
            border-color: var(--accent);
            box-shadow: 0 0 0 4px var(--accent-glow);
        }

        .btn-primary {
            background: var(--text-main);
            color: #fff;
            padding: 14px 30px;
            border-radius: 14px;
            border: none;
            font-weight: 700;
            font-size: 0.95rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 10px;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .alert {
            padding: 15px 20px;
            border-radius: 14px;
            margin-bottom: 25px;
            font-weight: 600;
            font-size: 0.9rem;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .alert-success { background: #D1FAE5; color: #065F46; }
        .alert-error { background: #FEE2E2; color: #991B1B; }

        @media (max-width: 900px) {
            .main-container { grid-template-columns: 1fr; }
            .form-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="bg-shape shape-1"></div>
<div class="bg-shape shape-2"></div>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="brand">KHOJ</a>
    <a href="${pageContext.request.contextPath}/LogoutServlet" style="color: var(--text-muted); text-decoration: none; font-weight: 600; font-size: 0.9rem;">
        <i class="fa-solid fa-power-off"></i> Logout
    </a>
</nav>

<div class="main-container">
    <!-- Profile Card -->
    <aside class="profile-card">
        <div class="avatar-container">
            <img src="${not empty profileUser.profileImg ? profileUser.profileImg : 'https://api.dicebear.com/7.x/avataaars/svg?seed='.concat(profileUser.fullName)}" alt="Avatar" class="avatar">
            <div class="status-dot"></div>
        </div>
        
        <h2 class="user-name">${profileUser.fullName}</h2>
        
        <span class="role-badge ${profileUser.role == 'LANDLORD' ? 'badge-landlord' : 'badge-tenant'}">
            <i class="fa-solid ${profileUser.role == 'LANDLORD' ? 'fa-crown' : 'fa-user-check'}"></i>
            ${profileUser.role == 'LANDLORD' ? 'Verified Landlord' : 'Active Tenant'}
        </span>
        
        <div class="stats-grid">
            <div class="stat-item">
                <div class="stat-icon"><i class="fa-solid fa-calendar-days"></i></div>
                <div class="stat-info">
                    <span class="stat-value">${profileUser.createdAt}</span>
                    <span class="stat-label">Member Since</span>
                </div>
            </div>
            
            <div class="stat-item">
                <div class="stat-icon">
                    <i class="fa-solid ${profileUser.role == 'LANDLORD' ? 'fa-building' : 'fa-file-signature'}"></i>
                </div>
                <div class="stat-info">
                    <span class="stat-value">${activityCount}</span>
                    <span class="stat-label">${activityLabel}</span>
                </div>
            </div>
        </div>
    </aside>

    <!-- Settings Area -->
    <main class="content-area">
        
        <c:if test="${param.success == 'true'}">
            <div class="alert alert-success">
                <i class="fa-solid fa-circle-check"></i> Identity vault updated successfully.
            </div>
        </c:if>
        
        <c:if test="${not empty errorMessage || param.error == 'user_not_found'}">
            <div class="alert alert-error">
                <i class="fa-solid fa-triangle-exclamation"></i> 
                <c:choose>
                    <c:when test="${param.error == 'user_not_found'}">Profile session lost. Displaying cached data.</c:when>
                    <c:otherwise>${errorMessage}</c:otherwise>
                </c:choose>
            </div>
        </c:if>

        <div class="glass-panel">
            <h2 class="section-title"><i class="fa-solid fa-user-gear"></i> Personal Identity</h2>
            <form action="${pageContext.request.contextPath}/profile" method="post">
                <input type="hidden" name="action" value="updateProfile">
                
                <div class="form-grid">
                    <div class="input-group">
                        <label>Full Legal Name</label>
                        <input type="text" name="fullName" value="${profileUser.fullName}" required>
                    </div>
                    <div class="input-group">
                        <label>Contact Email</label>
                        <input type="email" name="email" value="${profileUser.email}" required>
                    </div>
                    <div class="input-group">
                        <label>Phone Number</label>
                        <input type="text" name="phone" value="${profileUser.phoneNumber}" placeholder="+977-9800000000">
                    </div>
                </div>
                
                <button type="submit" class="btn-primary">
                    Update Profile <i class="fa-solid fa-arrow-right"></i>
                </button>
            </form>
        </div>

        <div class="glass-panel">
            <h2 class="section-title"><i class="fa-solid fa-shield-halved"></i> Security & Access</h2>
            <form action="${pageContext.request.contextPath}/profile" method="post">
                <input type="hidden" name="action" value="updatePassword">
                
                <div class="form-grid">
                    <div class="input-group">
                        <label>Current Password</label>
                        <input type="password" name="currentPassword" required>
                    </div>
                    <div></div> <!-- Spacer -->
                    <div class="input-group">
                        <label>New Password</label>
                        <input type="password" name="newPassword" required>
                    </div>
                    <div class="input-group">
                        <label>Confirm New Password</label>
                        <input type="password" name="confirmPassword" required>
                    </div>
                </div>
                
                <button type="submit" class="btn-primary">
                    Revise Password <i class="fa-solid fa-lock"></i>
                </button>
            </form>
        </div>
        
    </main>
</div>

</body>
</html>
