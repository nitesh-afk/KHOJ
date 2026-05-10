<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header id="mainHeader">
    <div class="container header-content">
        <a href="${pageContext.request.contextPath}/home" class="logo">KHOJ</a>
        <nav class="nav-actions">
            <a href="${pageContext.request.contextPath}/home" class="nav-link">Home</a>
            <a href="${pageContext.request.contextPath}/about" class="nav-link">About Us</a>
            <a href="${pageContext.request.contextPath}/contact" class="nav-link">Contact</a>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link btn-premium">Admin Dash</a>
                        </c:when>
                        <c:when test="${sessionScope.user.role == 'LANDLORD'}">
                            <a href="${pageContext.request.contextPath}/landlord/dashboard" class="nav-link btn-premium">Host Portal</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/tenant/dashboard" class="nav-link btn-premium">My Journey</a>
                        </c:otherwise>
                    </c:choose>
                    <a href="${pageContext.request.contextPath}/LogoutServlet" class="nav-link" style="opacity: 0.7;">Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/LoginServlet" class="nav-link">Login</a>
                    <a href="${pageContext.request.contextPath}/RegisterServlet" class="nav-link btn-premium">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>

<style>
    header {
        position: fixed;
        top: 0;
        width: 100%;
        z-index: 1000;
        padding: 20px 0;
        transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        background: transparent;
    }

    header.scrolled {
        background: #1C1917;
        padding: 15px 0;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
    }

    .header-content {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .logo {
        font-family: 'Playfair Display', serif;
        font-size: 2rem;
        font-weight: 700;
        color: #C9A96E;
        text-decoration: none;
        letter-spacing: 1px;
    }

    .nav-actions {
        display: flex;
        gap: 30px;
        align-items: center;
    }

    .nav-link {
        color: white;
        text-decoration: none;
        font-weight: 500;
        font-size: 0.95rem;
        transition: all 0.3s ease;
        font-family: 'Inter', sans-serif;
    }

    .nav-link:hover {
        color: #C9A96E;
    }

    .btn-premium {
        background: #C9A96E;
        color: #1C1917;
        padding: 10px 24px;
        border-radius: 50px;
        font-weight: 700;
    }

    .btn-premium:hover {
        background: #FFFFFF;
        color: #1C1917;
        transform: translateY(-2px);
    }
</style>

<script>
    window.addEventListener('scroll', function() {
        const header = document.getElementById('mainHeader');
        if (window.scrollY > 50) {
            header.classList.add('scrolled');
        } else {
            header.classList.remove('scrolled');
        }
    });
</script>
