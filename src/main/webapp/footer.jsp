<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
    .mega-footer {
        background-color: #0F0E0C;
        padding: 120px 0 60px;
        color: #FFFFFF;
        font-family: 'Plus Jakarta Sans', sans-serif;
        position: relative;
        overflow: hidden;
    }

    /* Subtle glow behind footer */
    .mega-footer::before {
        content: '';
        position: absolute;
        top: -150px; left: 50%;
        width: 600px; height: 300px;
        background: radial-gradient(circle, rgba(201, 169, 110, 0.05) 0%, transparent 70%);
        transform: translateX(-50%);
        z-index: 0;
    }

    .mega-footer .container {
        position: relative;
        z-index: 1;
        max-width: 1300px;
        margin: 0 auto;
        padding: 0 30px;
    }

    .footer-grid {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr 1fr 1fr;
        gap: 60px;
        margin-bottom: 80px;
    }

    .footer-col .footer-logo {
        font-family: 'Playfair Display', serif;
        font-size: 2.8rem;
        font-weight: 900;
        color: #C9A96E;
        margin-bottom: 24px;
        display: inline-block;
        text-decoration: none;
        letter-spacing: -2px;
    }

    .footer-col h4 {
        font-size: 0.8rem;
        font-weight: 800;
        margin-bottom: 30px;
        color: #FFFFFF;
        letter-spacing: 2px;
        text-transform: uppercase;
        opacity: 0.9;
    }

    .footer-col ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .footer-col ul li {
        margin-bottom: 16px;
    }

    .footer-col ul li a {
        color: rgba(255,255,255,0.5);
        text-decoration: none;
        transition: all 0.3s ease;
        font-size: 0.9rem;
        font-weight: 500;
    }

    .footer-col ul li a:hover {
        color: #C9A96E;
        padding-left: 5px;
    }

    .footer-social {
        display: flex;
        gap: 20px;
        margin-top: 30px;
    }

    .footer-social a {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: rgba(255,255,255,0.05);
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        text-decoration: none;
        transition: all 0.3s ease;
        font-size: 1rem;
    }

    .footer-social a:hover {
        background: #C9A96E;
        color: #1C1917;
        transform: translateY(-3px);
    }

    .footer-bottom {
        border-top: 1px solid rgba(255,255,255,0.08);
        padding-top: 40px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: rgba(255,255,255,0.4);
        font-size: 0.8rem;
        font-weight: 500;
    }

    .footer-links-secondary {
        display: flex;
        gap: 30px;
    }

    .footer-links-secondary a {
        color: inherit;
        text-decoration: none;
        transition: color 0.3s ease;
    }

    .footer-links-secondary a:hover { color: white; }

    @media (max-width: 1024px) {
        .footer-grid { grid-template-columns: repeat(3, 1fr); }
        .footer-col:first-child { grid-column: span 3; }
    }

    @media (max-width: 768px) {
        .footer-grid { grid-template-columns: repeat(2, 1fr); }
        .footer-col:first-child { grid-column: span 2; }
        .footer-bottom { flex-direction: column; gap: 20px; text-align: center; }
    }
</style>

<footer class="mega-footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col">
                <a href="home" class="footer-logo">KHOJ</a>
                <p style="color: rgba(255,255,255,0.5); font-size: 0.95rem; line-height: 1.8; margin-top: 0; max-width: 320px;">
                    Nepal's definitive portal for premium living. We curate verified homes, apartments, and artistic residencies for the discerning traveler and resident.
                </p>
                <div class="footer-social">
                    <a href="#"><i class="fa-brands fa-instagram"></i></a>
                    <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                    <a href="#"><i class="fa-brands fa-x-twitter"></i></a>
                </div>
            </div>
            <div class="footer-col">
                <h4>Support</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/contact">Contact Us</a></li>
                    <li><a href="#">Help Centre</a></li>
                    <li><a href="#">Safety Protocols</a></li>
                    <li><a href="#">Guest Policy</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Collections</h4>
                <ul>
                    <li><a href="#">Modern Lofts</a></li>
                    <li><a href="#">Mountain Villas</a></li>
                    <li><a href="#">Heritage Homes</a></li>
                    <li><a href="#">Serene Escapes</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>For Hosts</h4>
                <ul>
                    <li><a href="#">List Property</a></li>
                    <li><a href="#">Host Guidelines</a></li>
                    <li><a href="#">Insurance Coverage</a></li>
                    <li><a href="#">Host Community</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Company</h4>
                <ul>
                    <li><a href="${pageContext.request.contextPath}/about">Our Story</a></li>
                    <li><a href="#">Journal</a></li>
                    <li><a href="#">Impact</a></li>
                    <li><a href="#">Careers</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 KHOJ REALTY. All rights reserved.</p>
            <div class="footer-links-secondary">
                <a href="#">Privacy Policy</a>
                <a href="#">Terms of Use</a>
                <a href="#">Cookies</a>
            </div>
        </div>
    </div>
</footer>
