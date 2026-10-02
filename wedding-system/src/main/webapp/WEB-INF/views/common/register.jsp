<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta name="description"
                content="Create your couple account on WEDNEST and start planning your dream Sri Lankan wedding.">
            <title>Create Account — WEDNEST</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
        </head>

        <body style="background:var(--maroon-dark);">

            <div class="auth-wrapper">
                <!-- Left decorative panel -->
                <div class="auth-left" style="flex:0 0 420px;">
                    <svg style="position:absolute;top:0;left:0;opacity:0.06;pointer-events:none;" width="300"
                        height="300" viewBox="0 0 200 200">
                        <circle cx="100" cy="100" r="80" fill="none" stroke="#D4AF37" stroke-width="0.8" />
                        <circle cx="100" cy="100" r="60" fill="none" stroke="#D4AF37" stroke-width="0.5" />
                        <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3" />
                        <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3"
                            transform="rotate(60,100,100)" />
                        <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3"
                            transform="rotate(120,100,100)" />
                        <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3"
                            transform="rotate(180,100,100)" />
                        <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3"
                            transform="rotate(240,100,100)" />
                        <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3"
                            transform="rotate(300,100,100)" />
                    </svg>
                    <div class="auth-left-content">
                        <div style="font-size:52px;margin-bottom:16px;animation:float 4s ease-in-out infinite;">🪷</div>
                        <h2>Begin Your<br><em style="color:var(--gold-light);">Forever Story</em></h2>
                        <p>Join thousands of couples who have trusted WEDNEST to plan their perfect Sri Lankan wedding.
                        </p>

                        <div style="display:flex;flex-direction:column;gap:14px;margin-top:8px;">
                            <div style="display:flex;align-items:center;gap:12px;">
                                <div
                                    style="width:32px;height:32px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:15px;">
                                    ✦</div>
                                <span style="font-size:14px;color:rgba(255,255,255,0.75);">Free to register &
                                    browse</span>
                            </div>
                            <div style="display:flex;align-items:center;gap:12px;">
                                <div
                                    style="width:32px;height:32px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:15px;">
                                    ✦</div>
                                <span style="font-size:14px;color:rgba(255,255,255,0.75);">Book venues in
                                    real-time</span>
                            </div>
                            <div style="display:flex;align-items:center;gap:12px;">
                                <div
                                    style="width:32px;height:32px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:15px;">
                                    ✦</div>
                                <span style="font-size:14px;color:rgba(255,255,255,0.75);">Manage every detail in one
                                    place</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right form panel -->
                <div class="auth-right" style="padding: 48px 56px; overflow-y:auto;">
                    <div class="auth-form-box" style="max-width:400px;">
                        <div class="auth-logo">WED<span>NEST</span></div>
                        <h1 class="auth-title">Create your account</h1>
                        <p class="auth-sub">Start planning your dream wedding today.</p>

                        <c:if test="${not empty error}">
                            <div class="alert alert-error">⚠️ ${error}</div>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/register" id="registerForm">
                            <div class="form-group">
                                <label class="form-label" for="regFullName">Full Name</label>
                                <input type="text" name="fullName" id="regFullName" class="form-control"
                                    placeholder="Enter your full name" required autocomplete="name">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="regEmail">Email Address</label>
                                <input type="email" name="email" id="regEmail" class="form-control"
                                    placeholder="your@email.com" required autocomplete="email">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="regPhone">Phone Number</label>
                                <input type="tel" name="phone" id="regPhone" class="form-control"
                                    placeholder="+94 XX XXX XXXX" autocomplete="tel">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="regUsername">Username</label>
                                <input type="text" name="username" id="regUsername" class="form-control"
                                    placeholder="Choose a username" required autocomplete="username">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="regPassword">Password</label>
                                <input type="password" name="password" id="regPassword" class="form-control"
                                    placeholder="Create a strong password" required autocomplete="new-password">
                            </div>

                            <button type="submit" class="btn btn-primary btn-full"
                                style="margin-top:24px;height:50px;font-size:15px;" id="registerSubmitBtn">
                                Create Account →
                            </button>
                        </form>

                        <div class="gold-rule"></div>

                        <div style="text-align:center;font-size:14px;color:var(--muted);">
                            Already have an account? <a href="${pageContext.request.contextPath}/login"
                                class="auth-link">Sign in</a>
                        </div>

                        <div style="margin-top:20px;text-align:center;">
                            <a href="${pageContext.request.contextPath}/"
                                style="font-size:13px;color:var(--silver);text-decoration:none;" class="auth-link">←
                                Back to Home</a>
                        </div>
                    </div>
                </div>
            </div>

            <style>
                @keyframes float {

                    0%,
                    100% {
                        transform: translateY(0) rotate(0deg);
                    }

                    50% {
                        transform: translateY(-10px) rotate(5deg);
                    }
                }
            </style>
        </body>

        </html>