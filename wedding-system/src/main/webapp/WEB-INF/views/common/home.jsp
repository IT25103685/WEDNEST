<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="WEDNEST — Sri Lanka's most elegant wedding hall reservation platform. Find beautiful venues, premium packages and trusted vendors for your special day.">
    <title>WEDNEST — Sri Lankan Wedding Reservation Platform</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>

<!-- ====================================================
     NAVIGATION BAR
     ==================================================== -->
<nav class="navbar" id="mainNav">
    <a href="${pageContext.request.contextPath}/" class="navbar-brand">
        <div class="brand-icon">🪷</div>
        <span class="brand-text">WED<span class="brand-nest">NEST</span></span>
    </a>

    <button class="nav-toggle" id="navToggle" aria-label="Open navigation">
        <span></span><span></span><span></span>
    </button>

    <ul class="navbar-nav" id="navbar-nav">
        <li><a href="#home" class="active">Home</a></li>
        <li><a href="#venues">Venues</a></li>
        <li><a href="#packages">Packages</a></li>
        <li><a href="#vendors">Vendors</a></li>
        <li><a href="#gallery">Gallery</a></li>
        <li><a href="#about">About</a></li>
        <li><a href="#contact">Contact</a></li>
    </ul>

    <div class="navbar-actions">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-sm">Login</a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-sm">Register</a>
    </div>
</nav>

<!-- ====================================================
     HERO SECTION
     ==================================================== -->
<section class="hero" id="home">
    <!-- Corner decorative elements -->
    <div class="hero-corner-decor top-right">✦</div>
    <div class="hero-corner-decor bottom-left">✦</div>

    <div class="container">
        <div class="hero-content">
            <!-- Left: Text -->
            <div class="hero-text">
                <div class="hero-eyebrow anim-fade-up">Sri Lanka's Premier Wedding Platform</div>

                <h1 class="hero-title anim-fade-up delay-1">
                    Your Dream<br>
                    Wedding,<br>
                    <em>Perfectly Planned.</em>
                </h1>

                <p class="hero-sub anim-fade-up delay-2">
                    Discover beautiful wedding halls, curated packages and trusted vendors for your most special day. Begin your forever story with WEDNEST.
                </p>

                <div class="hero-actions anim-fade-up delay-3">
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-lg" id="heroFindVenue">
                        🌸 Find Your Perfect Venue
                    </a>
                    <a href="#packages" class="btn btn-secondary btn-lg" id="heroExplorePackages">
                        Explore Packages
                    </a>
                </div>

                <div class="hero-stats anim-fade-up delay-4">
                    <div class="hero-stat-item">
                        <div class="num">120+</div>
                        <div class="lbl">Premium Venues</div>
                    </div>
                    <div class="hero-stat-item">
                        <div class="num">1,800+</div>
                        <div class="lbl">Happy Couples</div>
                    </div>
                    <div class="hero-stat-item">
                        <div class="num">350+</div>
                        <div class="lbl">Trusted Vendors</div>
                    </div>
                </div>
            </div>

            <!-- Right: Wedding Couple Illustration -->
            <div class="hero-visual anim-fade-up delay-2">
                <div class="couple-wrap" id="coupleWrap">
                    <!-- Decorative rings -->
                    <div class="couple-ring couple-ring-1"></div>
                    <div class="couple-ring couple-ring-2"></div>

                    <!-- Gold sparkles -->
                    <div class="sparkle sparkle-1">✦</div>
                    <div class="sparkle sparkle-2">✦</div>
                    <div class="sparkle sparkle-3">✦</div>
                    <div class="sparkle sparkle-4">✦</div>
                    <div class="sparkle sparkle-5">✦</div>
                    <div class="sparkle sparkle-6">✦</div>

                    <img
                        src="${pageContext.request.contextPath}/resources/images/wedding-couple.jpg"
                        alt="Traditional Sri Lankan Kandyan wedding couple"
                        class="couple-img"
                        id="coupleImg"
                    />
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ====================================================
     THIN GOLD DIVIDER
     ==================================================== -->
<div style="padding: 0; margin: 0; position:relative; z-index:1;">
    <div class="gold-rule" style="margin: 0;"></div>
</div>

<!-- ====================================================
     VENUE SECTION
     ==================================================== -->
<section class="section" id="venues">
    <div class="container">
        <div class="section-header reveal">
            <div class="section-divider">
                <div class="line"></div>
                <div class="diamond"></div>
                <div class="line"></div>
            </div>
            <p class="text-gold" style="font-size:12px;font-weight:700;letter-spacing:2.5px;text-transform:uppercase;margin-bottom:12px;">Our Venues</p>
            <h2>Find Your Perfect<br>Wedding Venue</h2>
            <p>From intimate garden ceremonies to grand ballrooms, discover venues across Sri Lanka that will make your day unforgettable.</p>
        </div>

        <!-- Search Bar -->
        <div class="reveal" style="background:var(--white);border-radius:var(--radius-lg);border:1px solid var(--border-color);box-shadow:var(--shadow-card);padding:28px 32px;margin-bottom:48px;">
            <form method="post" action="${pageContext.request.contextPath}/couple/search-venues" style="display:grid;grid-template-columns:1fr 1fr auto;gap:16px;align-items:end;">
                <div>
                    <label class="form-label">Wedding Date</label>
                    <input type="date" name="eventDate" class="form-control" required id="venueSearchDate">
                </div>
                <div>
                    <label class="form-label">Expected Guests</label>
                    <input type="number" name="guestCount" min="1" max="2000" placeholder="e.g. 250" class="form-control" id="venueSearchGuests">
                </div>
                <button type="submit" class="btn btn-primary" style="height:48px;padding:0 32px;" id="venueSearchBtn">
                    🔍 Search
                </button>
            </form>
        </div>

        <!-- Venue Cards Grid -->
        <div class="grid grid-3">

            <!-- Venue Card 1 -->
            <div class="venue-card reveal delay-1" id="venueCard1">
                <div class="venue-img">
                    <img src="https://images.unsplash.com/photo-1519741497674-611481863552?w=600&auto=format&fit=crop&q=80" alt="Grand Ballroom Colombo" loading="lazy">
                    <span class="badge badge-available" style="position:absolute;top:14px;right:14px;">✓ Available</span>
                </div>
                <div class="venue-info">
                    <h3 class="venue-name">Grand Ballroom Colombo</h3>
                    <div class="venue-meta">
                        <span class="venue-meta-item"><span class="icon">📍</span> Colombo 3</span>
                        <span class="venue-meta-item"><span class="icon">👥</span> Up to 500 guests</span>
                    </div>
                    <div class="venue-price">Rs. 180,000 <span>/ event</span></div>
                    <div style="margin-top:16px;">
                        <a href="${pageContext.request.contextPath}/couple/search-venues" class="btn btn-primary btn-sm w-full" style="width:100%;justify-content:center;" id="venueCard1Btn">View Details</a>
                    </div>
                </div>
            </div>

            <!-- Venue Card 2 -->
            <div class="venue-card reveal delay-2" id="venueCard2">
                <div class="venue-img">
                    <img src="https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=600&auto=format&fit=crop&q=80" alt="Kandyan Heritage Hall" loading="lazy">
                    <span class="badge badge-available" style="position:absolute;top:14px;right:14px;">✓ Available</span>
                </div>
                <div class="venue-info">
                    <h3 class="venue-name">Kandyan Heritage Hall</h3>
                    <div class="venue-meta">
                        <span class="venue-meta-item"><span class="icon">📍</span> Kandy</span>
                        <span class="venue-meta-item"><span class="icon">👥</span> Up to 350 guests</span>
                    </div>
                    <div class="venue-price">Rs. 140,000 <span>/ event</span></div>
                    <div style="margin-top:16px;">
                        <a href="${pageContext.request.contextPath}/couple/search-venues" class="btn btn-primary btn-sm" style="width:100%;justify-content:center;" id="venueCard2Btn">View Details</a>
                    </div>
                </div>
            </div>

            <!-- Venue Card 3 -->
            <div class="venue-card reveal delay-3" id="venueCard3">
                <div class="venue-img">
                    <img src="https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=600&auto=format&fit=crop&q=80" alt="Royal Lotus Garden" loading="lazy">
                    <span class="badge badge-pending" style="position:absolute;top:14px;right:14px;">⏳ Limited</span>
                </div>
                <div class="venue-info">
                    <h3 class="venue-name">Royal Lotus Garden</h3>
                    <div class="venue-meta">
                        <span class="venue-meta-item"><span class="icon">📍</span> Galle</span>
                        <span class="venue-meta-item"><span class="icon">👥</span> Up to 200 guests</span>
                    </div>
                    <div class="venue-price">Rs. 95,000 <span>/ event</span></div>
                    <div style="margin-top:16px;">
                        <a href="${pageContext.request.contextPath}/couple/search-venues" class="btn btn-primary btn-sm" style="width:100%;justify-content:center;" id="venueCard3Btn">View Details</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center reveal" style="margin-top:40px;">
            <a href="${pageContext.request.contextPath}/couple/search-venues" class="btn btn-secondary btn-lg" id="viewAllVenuesBtn">
                View All Venues →
            </a>
        </div>
    </div>
</section>

<!-- ====================================================
     PACKAGES SECTION
     ==================================================== -->
<section class="section" id="packages" style="background: var(--ivory);">
    <div class="container">
        <div class="section-header reveal">
            <div class="section-divider">
                <div class="line"></div>
                <div class="diamond"></div>
                <div class="line"></div>
            </div>
            <p class="text-gold" style="font-size:12px;font-weight:700;letter-spacing:2.5px;text-transform:uppercase;margin-bottom:12px;">Wedding Packages</p>
            <h2>Choose Your<br>Perfect Package</h2>
            <p>From intimate celebrations to grand occasions, our curated packages ensure every detail is handled with care and elegance.</p>
        </div>

        <div class="grid grid-3">

            <!-- Standard Package -->
            <div class="package-card reveal delay-1" id="packageStandard">
                <div class="package-tier">Standard</div>
                <div class="package-name">Essentials</div>
                <div class="package-price">Rs. 95,000 <small>/ event</small></div>
                <div class="package-capacity">👥 Up to 150 guests</div>
                <div class="package-divider"></div>
                <ul class="package-features">
                    <li><span class="check">✦</span> Venue reservation (6 hrs)</li>
                    <li><span class="check">✦</span> Basic décor & floral setup</li>
                    <li><span class="check">✦</span> Catering for 150 pax</li>
                    <li><span class="check">✦</span> Sound & lighting system</li>
                    <li><span class="check">✦</span> 1 Coordinator on the day</li>
                    <li><span class="check">✦</span> Basic photography (4 hrs)</li>
                </ul>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-secondary btn-full" id="packageStandardBtn">Get Started</a>
            </div>

            <!-- Premium Package -->
            <div class="package-card reveal delay-2" id="packagePremium">
                <div class="package-tier">Premium</div>
                <div class="package-name">Elegance</div>
                <div class="package-price">Rs. 195,000 <small>/ event</small></div>
                <div class="package-capacity">👥 Up to 300 guests</div>
                <div class="package-divider"></div>
                <ul class="package-features">
                    <li><span class="check">✦</span> Venue reservation (10 hrs)</li>
                    <li><span class="check">✦</span> Premium floral & décor design</li>
                    <li><span class="check">✦</span> Full catering — buffet & table service</li>
                    <li><span class="check">✦</span> Pro sound, LED lighting & projectors</li>
                    <li><span class="check">✦</span> 2 Dedicated coordinators</li>
                    <li><span class="check">✦</span> Photography + Videography (8 hrs)</li>
                    <li><span class="check">✦</span> Traditional drumming & welcome</li>
                </ul>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-full" id="packagePremiumBtn">Get Started</a>
            </div>

            <!-- Luxury Package -->
            <div class="package-card luxury reveal delay-3" id="packageLuxury">
                <span class="package-popular">⭐ Most Popular</span>
                <div class="package-tier">Luxury</div>
                <div class="package-name">Royal</div>
                <div class="package-price">Rs. 395,000 <small>/ event</small></div>
                <div class="package-capacity">👥 Up to 500 guests</div>
                <div class="package-divider"></div>
                <ul class="package-features">
                    <li><span class="check">✦</span> Exclusive venue (Full day)</li>
                    <li><span class="check">✦</span> Bespoke Kandyan floral design</li>
                    <li><span class="check">✦</span> 5-course fine dining experience</li>
                    <li><span class="check">✦</span> Cinematic lighting & AV production</li>
                    <li><span class="check">✦</span> Full planning team (4 coordinators)</li>
                    <li><span class="check">✦</span> Luxury photography + cinematic film</li>
                    <li><span class="check">✦</span> Traditional Kandyan dancers</li>
                    <li><span class="check">✦</span> Bridal suite & honeymoon night</li>
                    <li><span class="check">✦</span> Guest management & concierge</li>
                </ul>
                <a href="${pageContext.request.contextPath}/register" class="btn btn-gold btn-full" id="packageLuxuryBtn">Book Royal Package</a>
            </div>
        </div>
    </div>
</section>

<!-- ====================================================
     VENDORS SECTION
     ==================================================== -->
<section class="section" id="vendors">
    <div class="container">
        <div class="section-header reveal">
            <div class="section-divider">
                <div class="line"></div>
                <div class="diamond"></div>
                <div class="line"></div>
            </div>
            <p class="text-gold" style="font-size:12px;font-weight:700;letter-spacing:2.5px;text-transform:uppercase;margin-bottom:12px;">Trusted Vendors</p>
            <h2>Handpicked Specialists<br>For Your Day</h2>
            <p>All our vendors are carefully vetted to ensure excellence for your celebration.</p>
        </div>

        <div class="grid grid-4 reveal">
            <div class="card text-center" style="padding:32px 20px;cursor:default;" id="vendorFloral">
                <div style="font-size:40px;margin-bottom:14px;">🌸</div>
                <h4 style="color:var(--maroon);margin-bottom:6px;font-weight:600;">Florists</h4>
                <p style="font-size:13px;color:var(--muted);">Traditional & modern floral designs</p>
            </div>
            <div class="card text-center" style="padding:32px 20px;cursor:default;" id="vendorPhoto">
                <div style="font-size:40px;margin-bottom:14px;">📸</div>
                <h4 style="color:var(--maroon);margin-bottom:6px;font-weight:600;">Photography</h4>
                <p style="font-size:13px;color:var(--muted);">Cinematic wedding films & photos</p>
            </div>
            <div class="card text-center" style="padding:32px 20px;cursor:default;" id="vendorCatering">
                <div style="font-size:40px;margin-bottom:14px;">🍛</div>
                <h4 style="color:var(--maroon);margin-bottom:6px;font-weight:600;">Catering</h4>
                <p style="font-size:13px;color:var(--muted);">Sri Lankan & international cuisine</p>
            </div>
            <div class="card text-center" style="padding:32px 20px;cursor:default;" id="vendorDecor">
                <div style="font-size:40px;margin-bottom:14px;">✨</div>
                <h4 style="color:var(--maroon);margin-bottom:6px;font-weight:600;">Décor & Design</h4>
                <p style="font-size:13px;color:var(--muted);">Luxurious setups & Poruwa design</p>
            </div>
        </div>
    </div>
</section>

<!-- ====================================================
     CTA BANNER
     ==================================================== -->
<section style="background: var(--maroon); padding: 72px 0; position:relative; overflow:hidden; z-index:1;" id="about">
    <div style="position:absolute;inset:0;background-image:radial-gradient(circle at 20% 50%, rgba(212,175,55,0.12) 0%, transparent 50%),radial-gradient(circle at 80% 50%, rgba(212,175,55,0.08) 0%, transparent 50%);pointer-events:none;"></div>
    <div class="container text-center reveal" style="position:relative;z-index:1;">
        <p style="font-size:12px;font-weight:700;letter-spacing:2.5px;text-transform:uppercase;color:var(--gold);margin-bottom:16px;">Begin Your Journey</p>
        <h2 style="font-family:'Cormorant Garamond',serif;font-size:clamp(32px,4vw,52px);color:var(--white);margin-bottom:16px;line-height:1.2;">
            Ready to Plan Your<br><em style="color:var(--gold-light);">Perfect Wedding?</em>
        </h2>
        <p style="color:rgba(255,255,255,0.7);font-size:17px;max-width:480px;margin:0 auto 36px;line-height:1.7;">
            Join thousands of couples who have planned their dream wedding with WEDNEST.
        </p>
        <div style="display:flex;gap:16px;justify-content:center;flex-wrap:wrap;">
            <a href="${pageContext.request.contextPath}/register" class="btn btn-gold btn-lg" id="ctaRegisterBtn">Start Planning Today</a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-secondary btn-lg" style="color:white;border-color:rgba(255,255,255,0.4);background:rgba(255,255,255,0.08);" id="ctaLoginBtn">Login to Dashboard</a>
        </div>
    </div>
</section>

<!-- ====================================================
     CONTACT / FOOTER
     ==================================================== -->
<footer class="footer" id="contact">
    <div class="container">
        <div class="footer-grid">
            <div>
                <div class="footer-brand">WED<span>NEST</span></div>
                <p class="footer-desc">Sri Lanka's premier wedding hall reservation platform. Connecting couples with the finest venues and vendors for their most memorable day.</p>
            </div>
            <div>
                <div class="footer-heading">Platform</div>
                <ul class="footer-links">
                    <li><a href="#venues">Find Venues</a></li>
                    <li><a href="#packages">Packages</a></li>
                    <li><a href="#vendors">Vendors</a></li>
                    <li><a href="${pageContext.request.contextPath}/register">Register</a></li>
                </ul>
            </div>
            <div>
                <div class="footer-heading">Company</div>
                <ul class="footer-links">
                    <li><a href="#about">About Us</a></li>
                    <li><a href="#contact">Contact</a></li>
                    <li><a href="#">Privacy Policy</a></li>
                    <li><a href="#">Terms of Service</a></li>
                </ul>
            </div>
            <div>
                <div class="footer-heading">Contact</div>
                <ul class="footer-links">
                    <li><a href="tel:+94112345678">📞 +94 11 234 5678</a></li>
                    <li><a href="mailto:hello@wednest.lk">✉ hello@wednest.lk</a></li>
                    <li><a href="#">📍 Colombo 7, Sri Lanka</a></li>
                </ul>
            </div>
        </div>
        <div class="footer-bottom">
            <span>© 2026 WEDNEST. All rights reserved. Made with ❤️ in Sri Lanka.</span>
            <span style="color:rgba(212,175,55,0.6);">✦ Your Dream Wedding, Perfectly Planned ✦</span>
        </div>
    </div>
</footer>

<!-- ====================================================
     JAVASCRIPT
     ==================================================== -->
<script>
    // ── Hamburger menu ──────────────────────────────────
    const navToggle = document.getElementById('navToggle');
    const navMenu   = document.getElementById('navbar-nav');
    navToggle.addEventListener('click', () => {
        navMenu.classList.toggle('open');
        const isOpen = navMenu.classList.contains('open');
        navToggle.setAttribute('aria-expanded', isOpen);
    });

    // Close menu when a link is clicked
    navMenu.querySelectorAll('a').forEach(link => {
        link.addEventListener('click', () => navMenu.classList.remove('open'));
    });

    // ── Scroll-spy active nav ────────────────────────────
    const sections   = document.querySelectorAll('section[id]');
    const navLinks   = document.querySelectorAll('.navbar-nav a');
    const observer   = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                navLinks.forEach(l => l.classList.remove('active'));
                const active = document.querySelector(`.navbar-nav a[href="#${entry.target.id}"]`);
                if (active) active.classList.add('active');
            }
        });
    }, { threshold: 0.35 });
    sections.forEach(s => observer.observe(s));

    // ── Scroll reveal ────────────────────────────────────
    const revealEls = document.querySelectorAll('.reveal');
    const revealObs = new IntersectionObserver(entries => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
                revealObs.unobserve(entry.target);
            }
        });
    }, { threshold: 0.12 });
    revealEls.forEach(el => revealObs.observe(el));

    // ── Navbar shadow on scroll ──────────────────────────
    window.addEventListener('scroll', () => {
        const nav = document.getElementById('mainNav');
        if (window.scrollY > 20) {
            nav.style.boxShadow = '0 4px 28px rgba(107,30,46,0.1)';
        } else {
            nav.style.boxShadow = '0 2px 20px rgba(107,30,46,0.06)';
        }
    });

    // ── Couple hover tilt ────────────────────────────────
    const coupleWrap = document.getElementById('coupleWrap');
    if (coupleWrap) {
        coupleWrap.addEventListener('mousemove', e => {
            const rect   = coupleWrap.getBoundingClientRect();
            const cx     = rect.left + rect.width / 2;
            const cy     = rect.top  + rect.height / 2;
            const dx     = (e.clientX - cx) / (rect.width / 2);
            const dy     = (e.clientY - cy) / (rect.height / 2);
            coupleWrap.style.transform = `rotateX(${-dy * 5}deg) rotateY(${dx * 5}deg) scale(1.03)`;
        });
        coupleWrap.addEventListener('mouseleave', () => {
            coupleWrap.style.transform = '';
            coupleWrap.style.transition = 'transform 0.6s ease';
            setTimeout(() => { coupleWrap.style.transition = ''; }, 600);
        });
    }

    // ── Smooth scrolling ─────────────────────────────────
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', e => {
            const target = document.querySelector(anchor.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        });
    });
</script>
</body>
</html>
