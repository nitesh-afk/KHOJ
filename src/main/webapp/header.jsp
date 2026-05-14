<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header id="mainHeader">
    <div class="container header-content">
        <a href="${pageContext.request.contextPath}/home" class="logo">KHOJ</a>
        <nav class="nav-actions">
            <a href="${pageContext.request.contextPath}/home" class="nav-link">Explore</a>
            <a href="${pageContext.request.contextPath}/about" class="nav-link">Our Story</a>
            <a href="${pageContext.request.contextPath}/contact" class="nav-link">Support</a>
            <div class="nav-divider"></div>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-premium">Management</a>
                        </c:when>
                        <c:when test="${sessionScope.user.role == 'LANDLORD'}">
                            <a href="${pageContext.request.contextPath}/landlord/dashboard" class="btn-premium">Host Portal</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/tenant/dashboard" class="btn-premium">My Journey</a>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link logout-link">
                        <i class="fa-solid fa-power-off"></i>
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/LoginServlet" class="nav-link">Login</a>
                    <a href="${pageContext.request.contextPath}/RegisterServlet" class="btn-premium">Join KHOJ</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>

<style>
    header {
        position: absolute;
        top: 0; left: 0;
        width: 100%;
        z-index: 1000;
        padding: 30px 0;
        transition: all 0.6s cubic-bezier(0.22, 1, 0.36, 1);
        background: transparent;
    }

    header.scrolled {
        position: fixed;
        background: rgba(15, 14, 12, 0.9);
        backdrop-filter: blur(15px);
        padding: 15px 0;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
    }

    .header-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .logo {
        font-family: 'Playfair Display', serif;
        font-size: 2.2rem;
        font-weight: 900;
        color: #C9A96E;
        text-decoration: none;
        letter-spacing: -1.5px;
        transition: transform 0.3s ease;
    }

    .logo:hover { transform: scale(1.05); }

    .nav-actions {
        display: flex;
        gap: 32px;
        align-items: center;
    }

    .nav-link {
        color: rgba(255,255,255,0.85);
        text-decoration: none;
        font-weight: 600;
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 1.5px;
        transition: all 0.3s ease;
        font-family: 'Plus Jakarta Sans', sans-serif;
    }

    .nav-link:hover {
        color: #C9A96E;
        transform: translateY(-1px);
    }

    .nav-divider {
        width: 1px;
        height: 20px;
        background: rgba(255,255,255,0.15);
    }

    .btn-premium {
        background: #C9A96E;
        color: #1C1917;
        padding: 12px 28px;
        border-radius: 12px;
        font-weight: 800;
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        text-decoration: none;
        transition: all 0.4s cubic-bezier(0.22, 1, 0.36, 1);
        box-shadow: 0 8px 15px rgba(201, 169, 110, 0.2);
    }

    .btn-premium:hover {
        background: #FFFFFF;
        transform: translateY(-2px);
        box-shadow: 0 12px 20px rgba(255, 255, 255, 0.15);
    }

    .logout-link {
        font-size: 1.1rem;
        opacity: 0.6;
    }
    .logout-link:hover { opacity: 1; color: #EF4444 !important; }

    @media (max-width: 768px) {
        .nav-actions .nav-link:not(.logout-link), .nav-divider { display: none; }
    }
</style>
