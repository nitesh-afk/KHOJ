<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
    .mega-footer {
        background-color: #f5f5f5;
        padding: 50px 0 30px;
        color: #333;
        font-size: 0.9rem;
        margin-top: 60px;
        border-top: 1px solid #ddd;
    }

    .footer-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 40px;
        margin-bottom: 40px;
    }

    .footer-col h4 {
        font-size: 1rem;
        font-weight: 700;
        margin-bottom: 20px;
        color: #1a1a1a;
    }

    .footer-col ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .footer-col ul li {
        margin-bottom: 10px;
    }

    .footer-col ul li a {
        color: #003580;
        text-decoration: none;
        transition: 0.2s;
    }

    .footer-col ul li a:hover {
        color: #001e4a;
        text-decoration: underline;
    }

    .footer-bottom {
        border-top: 1px solid #ddd;
        padding-top: 20px;
        text-align: center;
        color: #666;
        font-size: 0.85rem;
    }
</style>

<footer class="mega-footer">
    <div class="container">
        <div class="footer-grid">
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
