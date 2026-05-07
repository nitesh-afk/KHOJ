<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us | KHOJ Premium Real Estate</title>
    
    <!-- Google Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Playfair+Display:ital,wght@0,600;0,700;0,800;1,400&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        :root {
            --primary-blue: #003580;
            --accent-gold: #C9A96E;
            --text-dark: #1C1917;
            --text-muted: #6B6560;
            --bg-light: #FAF9F6;
            --white: #FFFFFF;
            --border-color: #EDE9E3;
            --transition: all 0.4s cubic-bezier(0.25, 0.46, 0.45, 0.94);
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-light);
            color: var(--text-dark);
            line-height: 1.6;
            overflow-x: hidden;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* --- Section 1: Hero --- */
        .about-hero {
            padding: 160px 0 100px;
            background: var(--white);
            position: relative;
            overflow: hidden;
        }

        .hero-grid {
            display: grid;
            grid-template-columns: 1fr 1.1fr;
            gap: 60px;
            align-items: center;
        }

        .hero-content h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(3rem, 5vw, 4.5rem);
            line-height: 1.1;
            margin-bottom: 30px;
            color: var(--text-dark);
        }

        .hero-content h1 span {
            color: #ccc;
            font-weight: 400;
        }

        .hero-desc {
            font-size: 1.15rem;
            color: var(--text-muted);
            margin-bottom: 40px;
            max-width: 500px;
        }

        .hero-stats {
            display: flex;
            gap: 40px;
            margin-bottom: 50px;
        }

        .stat-item .stat-count {
            display: block;
            font-size: 1.8rem;
            font-weight: 800;
            color: var(--text-dark);
            margin-bottom: 5px;
        }

        .stat-item .stat-label {
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--accent-gold);
        }

        .btn-schedule {
            display: inline-flex;
            align-items: center;
            gap: 12px;
            background: var(--primary-blue);
            color: var(--white);
            padding: 18px 36px;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 700;
            transition: var(--transition);
        }

        .btn-schedule:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 53, 128, 0.2);
        }

        .hero-image-container {
            position: relative;
        }

        .hero-main-img {
            width: 100%;
            border-radius: 24px;
            box-shadow: 0 30px 60px rgba(0,0,0,0.1);
        }

        .rating-card {
            position: absolute;
            bottom: 40px;
            right: -20px;
            background: var(--white);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            max-width: 280px;
            z-index: 10;
        }

        .rating-card h4 {
            font-size: 1.2rem;
            margin-bottom: 10px;
        }

        .stars {
            color: #FFD700;
            margin-bottom: 15px;
            display: block;
        }

        .rating-text {
            font-size: 0.9rem;
            color: var(--text-muted);
            font-style: italic;
        }

        /* --- Section 2: Value Proposition --- */
        .value-prop {
            padding: 120px 0;
            background: var(--bg-light);
        }

        .value-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 80px;
            align-items: center;
        }

        .value-image img {
            width: 100%;
            border-radius: 24px;
            object-fit: cover;
        }

        .value-content h2 {
            font-family: 'Playfair Display', serif;
            font-size: 3rem;
            margin-bottom: 25px;
            line-height: 1.2;
        }

        .value-content p {
            color: var(--text-muted);
            font-size: 1.1rem;
            margin-bottom: 35px;
        }

        .tag-cloud {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .pill-tag {
            background: var(--white);
            padding: 10px 20px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            border: 1px solid var(--border-color);
            transition: var(--transition);
        }

        .pill-tag:hover {
            border-color: var(--accent-gold);
            color: var(--accent-gold);
        }

        /* --- Section 3: Operating Principles --- */
        .principles {
            padding: 120px 0;
            background: var(--white);
        }

        .section-header {
            text-align: center;
            margin-bottom: 80px;
        }

        .section-header h2 {
            font-family: 'Playfair Display', serif;
            font-size: 3.5rem;
            margin-bottom: 15px;
        }

        .principles-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            border-top: 1px solid var(--border-color);
            border-left: 1px solid var(--border-color);
        }

        .principle-card {
            padding: 40px;
            border-right: 1px solid var(--border-color);
            border-bottom: 1px solid var(--border-color);
            transition: var(--transition);
        }

        .principle-card:hover {
            background: #fdfcf9;
        }

        .principle-tag {
            font-size: 0.75rem;
            font-weight: 800;
            text-transform: uppercase;
            color: var(--primary-blue);
            letter-spacing: 1.5px;
            margin-bottom: 20px;
            display: block;
        }

        .principle-card h3 {
            font-size: 1.4rem;
            margin-bottom: 15px;
        }

        .principle-card .quote {
            font-family: 'Playfair Display', serif;
            font-style: italic;
            font-size: 1.1rem;
            color: var(--text-dark);
            margin-bottom: 15px;
            display: block;
        }

        .principle-card p {
            font-size: 0.95rem;
            color: var(--text-muted);
        }

        /* --- Section 4: Our Team --- */
        .team-section {
            padding: 120px 0;
            background: var(--bg-light);
        }

        .team-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 30px;
        }

        .team-card {
            background: var(--white);
            border-radius: 20px;
            overflow: hidden;
            transition: var(--transition);
            border: 1px solid var(--border-color);
        }

        .team-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.05);
        }

        .member-img-box {
            width: 100%;
            height: 350px;
            overflow: hidden;
        }

        .member-img-box img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: var(--transition);
        }

        .team-card:hover .member-img-box img {
            transform: scale(1.05);
        }

        .member-info {
            padding: 25px;
            position: relative;
        }

        .status-dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            display: inline-block;
            margin-right: 8px;
        }

        .status-active { background: #10B981; }
        .status-away { background: #3B82F6; }

        .member-name {
            font-size: 1.25rem;
            font-weight: 700;
            margin-bottom: 5px;
        }

        .member-role {
            font-size: 0.9rem;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 600;
        }

        /* --- Section 5: CTA & Logos --- */
        .cta-logos {
            padding: 100px 0;
            background: var(--white);
        }

        .logos-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 30px;
            margin-bottom: 100px;
            opacity: 0.6;
        }

        .logo-placeholder {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 700;
            font-size: 1.1rem;
            color: var(--text-muted);
        }

        .about-cta-panel {
            background: #E8F1FF;
            border-radius: 32px;
            overflow: hidden;
            display: grid;
            grid-template-columns: 0.8fr 1.2fr;
            align-items: center;
        }

        .cta-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .cta-text {
            padding: 80px;
        }

        .cta-text h2 {
            font-size: 2.8rem;
            margin-bottom: 25px;
            line-height: 1.2;
        }

        .cta-text p {
            font-size: 1.2rem;
            margin-bottom: 40px;
            color: #444;
        }

        .cta-link {
            display: inline-flex;
            align-items: center;
            gap: 15px;
            font-weight: 800;
            color: var(--text-dark);
            text-decoration: none;
            font-size: 1.1rem;
            transition: var(--transition);
        }

        .cta-link i {
            background: var(--white);
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        .cta-link:hover {
            color: var(--primary-blue);
        }

        .cta-link:hover i {
            background: var(--primary-blue);
            color: var(--white);
            transform: translateX(5px);
        }

        @media (max-width: 1024px) {
            .hero-grid, .value-grid, .about-cta-panel { grid-template-columns: 1fr; }
            .principles-grid { grid-template-columns: repeat(2, 1fr); }
            .team-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 768px) {
            .hero-stats { flex-direction: column; gap: 20px; }
            .principles-grid { grid-template-columns: 1fr; }
            .team-grid { grid-template-columns: 1fr; }
            .cta-text { padding: 40px; }
        }
    </style>
</head>
<body>

    <jsp:include page="/header.jsp" />

    <main>
        <!-- Section 1: Hero -->
        <section class="about-hero">
            <div class="container">
                <div class="hero-grid">
                    <div class="hero-content">
                        <h1>KHOJ: Room Finding. <span>Simplified.</span></h1>
                        <p class="hero-desc">We're reimagining the real estate journey—combining verified listings, intuitive design, and trusted agents to help people find the right home, faster and with confidence.</p>
                        
                        <div class="hero-stats">
                            <div class="stat-item">
                                <span class="stat-count">12,000+</span>
                                <span class="stat-label">Active Listings</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-count">1,200+</span>
                                <span class="stat-label">Verified Agents</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-count">3,500+</span>
                                <span class="stat-label">Bookings</span>
                            </div>
                        </div>

                        <a href="#" class="btn-schedule">Schedule a Meeting <i class="fa-solid fa-arrow-right"></i></a>
                    </div>
                    <div class="hero-image-container">
                        <img src="${pageContext.request.contextPath}/resources/images/about_hero_house_1778166838374.png" alt="Modern House" class="hero-main-img">
                        <div class="rating-card">
                            <h4>98% User Rating</h4>
                            <div class="stars">
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                                <i class="fa-solid fa-star"></i>
                            </div>
                            <p class="rating-text">"The experience was smooth from start to finish. Finding a place took seconds!"</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Section 2: Value Proposition -->
        <section class="value-prop">
            <div class="container">
                <div class="value-grid">
                    <div class="value-image">
                        <img src="${pageContext.request.contextPath}/resources/images/about_cabin_value_prop_1778166854706.png" alt="Modern Cabin">
                    </div>
                    <div class="value-content">
                        <h2>Turning property search into a personal experience</h2>
                        <p>We help homebuyers discover, explore, and secure the right property—without the friction. From high-quality listings and intelligent search filters to in-app booking and agent matching, we simplify every step of the journey.</p>
                        
                        <div class="tag-cloud">
                            <span class="pill-tag">100% Verified</span>
                            <span class="pill-tag">Transparent Pricing</span>
                            <span class="pill-tag">Local Agents</span>
                            <span class="pill-tag">Mobile-First</span>
                            <span class="pill-tag">Instant Booking</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Section 3: Operating Principles -->
        <section class="principles">
            <div class="container">
                <div class="section-header">
                    <h2>Our operating principles</h2>
                </div>
                <div class="principles-grid">
                    <div class="principle-card">
                        <span class="principle-tag">First Principles</span>
                        <h3>No Problem is Too Hard</h3>
                        <span class="quote">"We set audacious goals."</span>
                        <p>We relish tackling hard problems. We think independently, logically, and empirically about every aspect of KHOJ and our industry.</p>
                    </div>
                    <div class="principle-card">
                        <span class="principle-tag">Trust</span>
                        <h3>Driver Drives</h3>
                        <span class="quote">"We start from a place of trust."</span>
                        <p>We value outputs, not inputs. We treat each other as peers with the freedom to experiment and iterate.</p>
                    </div>
                    <div class="principle-card">
                        <span class="principle-tag">Feedback</span>
                        <h3>Fast Frequent Feedback</h3>
                        <span class="quote">"We push ourselves to provide info."</span>
                        <p>We speak openly about mistakes and facts. We actively seek critical feedback from each other.</p>
                    </div>
                    <div class="principle-card">
                        <span class="principle-tag">Speed</span>
                        <h3>Impatience is a Virtue</h3>
                        <span class="quote">"Our biggest advantage is speed."</span>
                        <p>We move to decisions swiftly and decisively. We prioritize the critical and remove the excess.</p>
                    </div>
                    <div class="principle-card">
                        <span class="principle-tag">Focus</span>
                        <h3>People First</h3>
                        <span class="quote">"We stay acutely aware."</span>
                        <p>The activities that we undertake relate to our goals. We recognize that we have more things that we want to do than we have time to do them.</p>
                    </div>
                    <div class="principle-card">
                        <span class="principle-tag">Commitment</span>
                        <h3>Design with Purpose</h3>
                        <span class="quote">"It is our commitment to our mission."</span>
                        <p>Our team works with resiliency in the face of challenges that would otherwise be overwhelming.</p>
                    </div>
                    <div class="principle-card">
                        <span class="principle-tag">Growth</span>
                        <h3>Compound Returns</h3>
                        <span class="quote">"We recognize that we cannot achieve."</span>
                        <p>Our goals through brute force. We recognize that in order to advance as individuals, as an organization, we must continuously invest in ourselves.</p>
                    </div>
                    <div class="principle-card">
                        <span class="principle-tag">Decisiveness</span>
                        <h3>Make the Call</h3>
                        <span class="quote">"The speed at which we make decisions."</span>
                        <p>Dictates our speed as a team. We recognize that if we want to make decisions quickly, we will often have to rely on imperfect information.</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Section 4: Our Team -->
        <section class="team-section">
            <div class="container">
                <div class="section-header">
                    <h2>Our Team</h2>
                </div>
                <div class="team-grid">
                    <!-- Card 1 -->
                    <div class="team-card">
                        <div class="member-img-box">
                            <img src="${pageContext.request.contextPath}/resources/images/team_male_1_1778166894294.png" alt="Nitesh Raut">
                        </div>
                        <div class="member-info">
                            <h3 class="member-name">Nitesh Raut</h3>
                            <p class="member-role"><span class="status-dot status-active"></span> Lead Developer</p>
                        </div>
                    </div>
                    <!-- Card 2 -->
                    <div class="team-card">
                        <div class="member-img-box">
                            <img src="${pageContext.request.contextPath}/resources/images/team_female_1_1778166908469.png" alt="Ismini Limbu">
                        </div>
                        <div class="member-info">
                            <h3 class="member-name">Ismini Limbu</h3>
                            <p class="member-role"><span class="status-dot status-active"></span> Backend Specialist</p>
                        </div>
                    </div>
                    <!-- Card 3 -->
                    <div class="team-card">
                        <div class="member-img-box">
                            <img src="${pageContext.request.contextPath}/resources/images/team_male_2_1778166922572.png" alt="Saito Limbu">
                        </div>
                        <div class="member-info">
                            <h3 class="member-name">Saito Limbu</h3>
                            <p class="member-role"><span class="status-dot status-away"></span> Database Architect</p>
                        </div>
                    </div>
                    <!-- Card 4 -->
                    <div class="team-card">
                        <div class="member-img-box">
                            <img src="${pageContext.request.contextPath}/resources/images/team_male_1_1778166894294.png" alt="Abhiyan Ghimire">
                        </div>
                        <div class="member-info">
                            <h3 class="member-name">Abhiyan Ghimire</h3>
                            <p class="member-role"><span class="status-dot status-active"></span> Systems Analyst</p>
                        </div>
                    </div>
                    <!-- Card 5 -->
                    <div class="team-card">
                        <div class="member-img-box">
                            <img src="${pageContext.request.contextPath}/resources/images/team_male_2_1778166922572.png" alt="Rohan Shrestha">
                        </div>
                        <div class="member-info">
                            <h3 class="member-name">Rohan Shrestha</h3>
                            <p class="member-role"><span class="status-dot status-active"></span> QA Engineer</p>
                        </div>
                    </div>

                </div>
            </div>
        </section>

        <!-- Section 5: CTA & Logos -->
        <section class="cta-logos">
            <div class="container">
                <div class="logos-row">
                    <div class="logo-placeholder"><i class="fa-solid fa-cube"></i> Acme Corp</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-circle-notch"></i> Alt+Shift</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-shield"></i> Capsule</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-bolt"></i> Catalxg</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-cloud"></i> Calescence</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-diamond"></i> CoreOS</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-square"></i> Pollinate</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-circle"></i> Ollio</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-location-arrow"></i> Galileo</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-globe"></i> Europa</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-ellipsis"></i> ennLabs</div>
                    <div class="logo-placeholder"><i class="fa-solid fa-box"></i> Cubekit</div>
                </div>

                <div class="about-cta-panel">
                    <img src="${pageContext.request.contextPath}/resources/images/about_cta_house_1778166868837.png" alt="Cozy House" class="cta-img">
                    <div class="cta-text">
                        <h2>Ready to Find Your Next Home?</h2>
                        <p>Whether you're buying, browsing, or just getting started — KHOJ makes it easy to take the next step with confidence.</p>
                        <a href="#" class="cta-link">
                            Book A Tour <i><i class="fa-solid fa-arrow-right"></i></i>
                        </a>
                    </div>
                </div>
            </div>
        </section>
    </main>

    <jsp:include page="/footer.jsp" />

</body>
</html>
