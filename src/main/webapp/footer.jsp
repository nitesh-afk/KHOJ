<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
    .mega-footer {
        background-color: #1C1917;
        padding: 80px 0 30px;
        color: #FFFFFF;
        font-family: 'Inter', sans-serif;
    }

    .footer-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 40px;
        margin-bottom: 60px;
    }

    .footer-col .footer-logo {
        font-family: 'Playfair Display', serif;
        font-size: 2.2rem;
        font-weight: 700;
        color: #C9A96E;
        margin-bottom: 20px;
        display: inline-block;
        text-decoration: none;
    }

    .footer-col h4 {
        font-family: 'Inter', sans-serif;
        font-size: 1rem;
        font-weight: 700;
        margin-bottom: 24px;
        color: #FFFFFF;
        letter-spacing: 0.5px;
    }

    .footer-col ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .footer-col ul li {
        margin-bottom: 12px;
    }

    .footer-col ul li a {
        color: rgba(255,255,255,0.6);
        text-decoration: none;
        transition: color 0.3s ease;
        font-size: 0.95rem;
    }

    .footer-col ul li a:hover {
        color: #FFFFFF;
    }

    .footer-bottom {
        border-top: 1px solid rgba(255,255,255,0.15);
        padding-top: 30px;
        text-align: center;
        color: rgba(255,255,255,0.5);
        font-size: 0.85rem;
    }
</style>

<footer class="mega-footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-col" style="grid-column: span 1;">
                <a href="home" class="footer-logo">KHOJ</a>
                <p style="color: rgba(255,255,255,0.6); font-size: 0.95rem; line-height: 1.6; margin-top: 0;">
                    Your premium real estate and travel portal. Discover verified homes, apartments, and villas across Nepal.
                </p>
            </div>
            <div class="footer-col">
                <h4>Support</h4>
                <ul>
                    <li><a href="#">Help Centre</a></li>
                    <li><a href="#">Safety Information</a></li>
                    <li><a href="#">Cancellation Options</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>Discover Nepal</h4>
                <ul>
                    <li><a href="#">Kathmandu Apartments</a></li>
                    <li><a href="#">Pokhara Stays</a></li>
                    <li><a href="#">Weekend Escapes</a></li>
                    <li><a href="#">Nature & Safari</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>For Landlords</h4>
                <ul>
                    <li><a href="#">List your property</a></li>
                    <li><a href="#">Landlord Guidelines</a></li>
                    <li><a href="#">Trust & Safety</a></li>
                </ul>
            </div>
            <div class="footer-col">
                <h4>About KHOJ</h4>
                <ul>
                    <li><a href="#">About Us</a></li>
                    <li><a href="#">Careers</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms of Service</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2026 KHOJ. All rights reserved.</p>
        </div>
    </div>
</footer>
