<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Contact Us | KHOJ Premium</title>

  <!-- Typography & Icons -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800&family=Playfair+Display:wght@600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <!-- Link to the main style.css to inherit the core tokens -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">

  <style>
    /* Standalone overrides for the Contact Glassmorphism logic */
    :root {
      /* Fallback variables if style.css is modified */
      --contact-blue: #003580;
      --contact-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
      --contact-transition: all 0.3s ease;
    }

    .contact-page {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 120px 20px 80px 20px; /* offset for fixed headers */
      /* Subtle premium gradient background */
      background-image: linear-gradient(135deg, #f5f7fa 0%, #eef2f6 100%);
    }

    .contact-wrapper {
      width: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
    }

    .contact-heading {
      text-align: center;
      font-family: 'Playfair Display', serif;
      /* Fluid typography using clamp() */
      font-size: clamp(2.5rem, 6vw, 4rem);
      font-weight: 700;
      color: var(--hero-overlay, #1C1917);
      margin-bottom: 2rem;
    }

    /* The Glassmorphism Container */
    .contact-container {
      max-width: 1100px;
      width: 100%;
      display: grid;
      grid-template-columns: 1fr 1.2fr;
      gap: 3rem;

      /* Glassmorphism Implementation */
      background: rgba(255, 255, 255, 0.75);
      backdrop-filter: blur(16px);
      -webkit-backdrop-filter: blur(16px); /* Safari support */
      border: 1px solid rgba(255, 255, 255, 0.5);
      border-radius: 24px;
      box-shadow: var(--card-shadow, var(--contact-shadow));
      padding: 3.5rem;
    }

    @media (max-width: 860px) {
      .contact-container {
        grid-template-columns: 1fr;
        padding: 2.5rem;
        gap: 2.5rem;
      }
    }

    /* --- Left Side: Information --- */
    .contact-info {
      display: flex;
      flex-direction: column;
      gap: 1.8rem;
    }

    .contact-info h2 {
      font-size: 2rem;
      margin-bottom: 0.5rem;
      color: #1a1a1a;
      font-family: 'Inter', sans-serif;
      font-weight: 800;
    }

    .contact-info p {
      color: #555;
      line-height: 1.6;
      font-size: 1.1rem;
      margin-bottom: 1rem;
    }

    .info-item {
      display: flex;
      align-items: center;
      gap: 1.2rem;
      font-size: 1.15rem;
      color: #333;
      font-weight: 600;
    }

    .info-item i {
      color: var(--accent-gold, #C9A96E);
      font-size: 1.6rem;
      width: 35px;
      text-align: center;
    }

    /* --- Right Side: The Form --- */
    .contact-form {
      display: flex;
      flex-direction: column;
      gap: 1.5rem;
    }

    .form-group {
      display: flex;
      flex-direction: column;
      gap: 0.6rem;
    }

    .form-group label {
      font-size: 0.95rem;
      font-weight: 700;
      color: #444;
      font-family: 'Inter', sans-serif;
    }

    .form-group input,
    .form-group textarea {
      width: 100%;
      padding: 14px 18px;
      border: 2px solid #e2e8f0;
      border-radius: 12px;
      background: rgba(255, 255, 255, 0.9);
      font-family: 'Inter', sans-serif;
      font-size: 1.05rem;
      transition: var(--transition, var(--contact-transition));
      box-sizing: border-box;
    }

    /* Glowing Gold Border on Focus */
    .form-group input:focus,
    .form-group textarea:focus {
      outline: none;
      border-color: var(--accent-gold, #C9A96E);
      box-shadow: 0 0 0 4px rgba(201, 169, 110, 0.2);
      background: #ffffff;
    }

    .form-group textarea {
      resize: vertical;
      min-height: 140px;
    }

    .btn-submit {
      background-color: var(--accent-gold, #C9A96E);
      color: #1C1917;
      border: none;
      border-radius: 12px;
      padding: 16px 24px;
      font-size: 1.15rem;
      font-weight: 700;
      cursor: pointer;
      transition: var(--transition, var(--contact-transition));
      margin-top: 10px;
      font-family: 'Inter', sans-serif;
    }

    .btn-submit:hover {
      background-color: #b5955c;
      transform: translateY(-3px);
      box-shadow: 0 8px 20px rgba(201, 169, 110, 0.4);
    }

    /* Alert Styling */
    .alert-success {
      background-color: #dcfce7;
      color: #15803d;
      border: 1px solid #bbf7d0;
      padding: 1.2rem;
      border-radius: 12px;
      font-weight: 700;
      font-size: 1.05rem;
      text-align: center;
      margin-bottom: 1.5rem;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
    }
  </style>
</head>
<body>

<!-- Inline Header since header.jsp does not exist -->
<header style="background: var(--hero-overlay, #1C1917); padding: 20px 0; box-shadow: 0 4px 20px rgba(0,0,0,0.1);">
  <div class="contact-wrapper" style="max-width: 1100px; margin: 0 auto; display: flex; justify-content: space-between; align-items: center;">
    <h2 style="margin: 0; color: var(--accent-gold, #C9A96E); font-weight: 700; cursor: pointer; font-family: 'Playfair Display', serif; font-size: 2.2rem; letter-spacing: 1px;" onclick="window.location.href='${pageContext.request.contextPath}/home'">KHOJ</h2>
  </div>
</header>

<div class="contact-page">
  <div class="contact-wrapper">

    <h1 class="contact-heading">Get In Touch</h1>

    <!-- Glassmorphism Container -->
    <div class="contact-container">

      <!-- Left Column -->
      <div class="contact-info">
        <h2>We're here to help</h2>
        <p>Whether you have a question about our verified properties, payment models, or need technical assistance, our support team is available 24/7.</p>

        <div class="info-item">
          <i class="fa-solid fa-location-dot"></i>
          <span>Kathmandu Valley, Nepal</span>
        </div>
        <div class="info-item">
          <i class="fa-solid fa-phone"></i>
          <span>+977 1-400-KHOJ</span>
        </div>
        <div class="info-item">
          <i class="fa-solid fa-envelope"></i>
          <span>support@khoj.com.np</span>
        </div>
      </div>

      <!-- Right Column -->
      <form class="contact-form" action="${pageContext.request.contextPath}/contact" method="POST">

        <c:if test="${not empty successMsg}">
          <div class="alert-success">
            <i class="fa-solid fa-circle-check"></i> ${successMsg}
          </div>
        </c:if>

        <div class="form-group">
          <label for="fullName">Full Name</label>
          <input type="text" id="fullName" name="fullName" required placeholder="e.g. Nitesh Raut">
        </div>

        <div class="form-group">
          <label for="email">Email Address</label>
          <input type="email" id="email" name="email" required placeholder="name@domain.com">
        </div>

        <div class="form-group">
          <label for="subject">Subject</label>
          <input type="text" id="subject" name="subject" required placeholder="How can we assist you?">
        </div>

        <div class="form-group">
          <label for="message">Message</label>
          <textarea id="message" name="message" required placeholder="Please describe your inquiry in detail..."></textarea>
        </div>

        <button type="submit" class="btn-submit">
          Send Message <i class="fa-solid fa-paper-plane" style="margin-left: 8px;"></i>
        </button>
      </form>
    </div>

  </div>
</div>

<!-- Strict Requirement: Use existing footer.jsp -->
<jsp:include page="../footer.jsp" />

</body>
</html>
