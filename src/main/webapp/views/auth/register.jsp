<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join KHOJ | Your Portal to Premium Stays</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Playfair+Display:wght@400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --bg-primary: #FAF9F6;
            --hero-overlay: #1C1917;
            --accent-gold: #C9A96E;
            --text-primary: #1C1917;
            --text-secondary: #6B6560;
            --card-surface: #FFFFFF;
            --card-border: #EDE9E3;
            --transition-premium: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        body {
            font-family: 'Inter', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            display: flex;
            min-height: 100vh;
        }

        .auth-image {
            flex: 1.2;
            display: none;
            background-image: url('https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            position: relative;
        }

        @media (min-width: 900px) {
            .auth-image { display: block; }
        }

        .auth-image::after {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; bottom: 0;
            background: linear-gradient(to bottom, rgba(28,25,23,0.1) 0%, rgba(28,25,23,0.8) 100%);
        }

        .back-home {
            position: absolute;
            top: 40px;
            left: 40px;
            color: white;
            text-decoration: none;
            font-family: 'Inter', sans-serif;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 10px;
            z-index: 10;
            transition: var(--transition-premium);
        }

        .back-home:hover {
            color: var(--accent-gold);
            transform: translateX(-5px);
        }

        .auth-content {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 40px 20px;
            background: var(--card-surface);
            overflow-y: auto;
        }

        .auth-card {
            width: 100%;
            max-width: 440px;
            animation: fadeUp 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94) forwards;
            opacity: 0;
            transform: translateY(20px);
            margin: auto;
        }

        @keyframes fadeUp {
            to { opacity: 1; transform: translateY(0); }
        }

        .auth-logo {
            font-family: 'Playfair Display', serif;
            font-size: 2.2rem;
            font-weight: 700;
            color: var(--accent-gold);
            text-decoration: none;
            margin-bottom: 30px;
            display: inline-block;
        }

        h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2.4rem;
            font-weight: 700;
            color: var(--text-primary);
            margin: 0 0 10px;
            letter-spacing: -0.5px;
        }

        .auth-subtitle {
            color: var(--text-secondary);
            font-size: 1rem;
            margin-bottom: 30px;
            line-height: 1.5;
        }

        .form-row {
            display: flex;
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .form-row .form-group {
            margin-bottom: 0;
            flex: 1;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 8px;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 16px;
            border: 1px solid var(--card-border);
            border-radius: 12px;
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            color: var(--text-primary);
            background: var(--bg-primary);
            transition: var(--transition-premium);
            box-sizing: border-box;
            outline: none;
            appearance: none;
        }
        
        .form-group select {
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%231C1917' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6 9 12 15 18 9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 16px center;
            background-size: 16px;
            padding-right: 40px;
        }

        .form-group input:focus, .form-group select:focus {
            border-color: var(--accent-gold);
            box-shadow: 0 0 0 4px rgba(201, 169, 110, 0.1);
            background: var(--card-surface);
        }

        button[type="submit"] {
            width: 100%;
            padding: 16px;
            background: var(--accent-gold);
            color: var(--text-primary);
            border: none;
            border-radius: 12px;
            font-family: 'Inter', sans-serif;
            font-size: 1rem;
            font-weight: 800;
            cursor: pointer;
            transition: var(--transition-premium);
            margin-top: 10px;
        }

        button[type="submit"]:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(201, 169, 110, 0.3);
            background: #b5955c;
        }

        .auth-footer {
            margin-top: 30px;
            text-align: center;
            font-size: 0.95rem;
            color: var(--text-secondary);
        }

        .auth-footer a {
            color: var(--text-primary);
            font-weight: 600;
            text-decoration: none;
            transition: color 0.3s ease;
            border-bottom: 1px solid transparent;
        }

        .auth-footer a:hover {
            color: var(--accent-gold);
            border-bottom: 1px solid var(--accent-gold);
        }

        .alert {
            padding: 14px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            font-size: 0.95rem;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert-error {
            background: #FEF2F2;
            color: #991B1B;
            border: 1px solid #FCA5A5;
        }

        .mobile-back {
            display: none;
            margin-top: 30px;
            text-align: center;
        }
        @media (max-width: 899px) {
            .mobile-back { display: block; }
        }
    </style>
</head>
<body>
    <div class="auth-image">
        <a href="${pageContext.request.contextPath}/home" class="back-home">
            <i class="fa-solid fa-arrow-left"></i> Back to Home
        </a>
    </div>

    <div class="auth-content">
        <div class="auth-card">
            <a href="${pageContext.request.contextPath}/home" class="auth-logo">KHOJ</a>
            
            <h2>Join KHOJ</h2>
            <p class="auth-subtitle">Create an account to unlock premium properties and verified landlords across Nepal.</p>
            
            <% if (request.getParameter("error") != null) { %>
                <div class="alert alert-error">
                    <i class="fa-solid fa-circle-exclamation"></i> Registration Failed: <%= request.getParameter("error") %>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/RegisterServlet" method="post">
                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" placeholder="e.g. John Doe" required>
                </div>
                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" placeholder="john@example.com" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>
                <div class="form-group">
                    <label for="role">I am a:</label>
                    <select id="role" name="role">
                        <option value="TENANT">Tenant (Looking for stays)</option>
                        <option value="LANDLORD">Landlord (Listing properties)</option>
                    </select>
                </div>
                <button type="submit">Create Account</button>
            </form>

            <div class="auth-footer">
                <p>Already have an account? <a href="${pageContext.request.contextPath}/views/auth/login.jsp">Log in here</a></p>
            </div>

            <div class="mobile-back">
                <a href="${pageContext.request.contextPath}/home" style="color: var(--text-secondary); text-decoration: none; font-weight: 500; font-size: 0.9rem;">
                    <i class="fa-solid fa-arrow-left"></i> Back to Home
                </a>
            </div>
        </div>
    </div>
</body>
</html>