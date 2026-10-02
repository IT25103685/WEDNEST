<%@ page contentType="text/html;charset=UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <meta name="description" content="Sign in to WEDNEST — Sri Lanka's premier wedding reservation platform.">
            <title>Login — WEDNEST</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
        </head>

        <body style="background:var(--maroon-dark);overflow:hidden;">

            <div class="auth-wrapper">
                <!-- Left decorative panel -->
                <div class="auth-left">
                    <!-- Decorative floral pattern -->
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
                    <svg style="position:absolute;bottom:0;right:0;opacity:0.05;pointer-events:none;" width="280"
                        height="280" viewBox="0 0 200 200">
                        <circle cx="100" cy="100" r="80" fill="none" stroke="#D4AF37" stroke-width="0.8" />
                        <circle cx="100" cy="100" r="50" fill="none" stroke="#D4AF37" stroke-width="0.4" />
                    </svg>

                    <div class="auth-left-content">
                        <div style="font-size:52px;margin-bottom:16px;animation:float 4s ease-in-out infinite;">🌸</div>
                        <h2>Welcome Back to<br><em style="color:var(--gold-light);">WEDNEST</em></h2>
                        <p>Continue planning your dream Sri Lankan wedding. Your perfect day awaits.</p>

                        <div style="display:flex;flex-direction:column;gap:14px;margin-top:8px;">
                            <div style="display:flex;align-items:center;gap:12px;">
                                <div
                                    style="width:36px;height:36px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:18px;">
                                    ✦</div>
                                <span style="font-size:14px;color:rgba(255,255,255,0.75);">Access 120+ premium wedding
                                    venues</span>
                            </div>
                            <div style="display:flex;align-items:center;gap:12px;">
                                <div
                                    style="width:36px;height:36px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:18px;">
                                    ✦</div>
                                <span style="font-size:14px;color:rgba(255,255,255,0.75);">Manage bookings & vendor
                                    requests</span>
                            </div>
                            <div style="display:flex;align-items:center;gap:12px;">
                                <div
                                    style="width:36px;height:36px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:18px;">
                                    ✦</div>
                                <span style="font-size:14px;color:rgba(255,255,255,0.75);">Track your wedding
                                    timeline</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right form panel -->
                <div class="auth-right">
                    <div class="auth-form-box">
                        <div class="auth-logo">WED<span>NEST</span></div>
                        <h1 class="auth-title">Sign in</h1>
                        <p class="auth-sub">Welcome back! Enter your credentials to continue.</p>

                        <c:if test="${not empty error}">
                            <div class="alert alert-error">⚠️ ${error}</div>
                        </c:if>
                        <c:if test="${not empty success}">
                            <div class="alert alert-success">✓ ${success}</div>
                        </c:if>

                        <form method="post" action="${pageContext.request.contextPath}/login" id="loginForm">
                            <div class="form-group">
                                <label class="form-label" for="loginUsername">Username</label>
                                <input type="text" name="username" id="loginUsername" class="form-control"
                                    placeholder="Enter your username" required autocomplete="username">
                            </div>
                            <div class="form-group">
                                <label class="form-label" for="loginPassword">Password</label>
                                <input type="password" name="password" id="loginPassword" class="form-control"
                                    placeholder="Enter your password" required autocomplete="current-password">
                            </div>
                            <button type="submit" class="btn btn-primary btn-full"
                                style="margin-top:24px;height:50px;font-size:15px;" id="loginSubmitBtn">
                                Sign In →
                            </button>
                        </form>

                        <div class="gold-rule"></div>

                        <div style="text-align:center;font-size:14px;color:var(--muted);line-height:2;">
                            New couple? <a href="${pageContext.request.contextPath}/register" class="auth-link">Create
                                an account</a><br>
                            Are you a vendor? <a href="${pageContext.request.contextPath}/vendor/signup"
                                class="auth-link">Register as vendor</a><br>
                            Are you a guest? <a href="${pageContext.request.contextPath}/guest/login"
                                class="auth-link">Enter your guest code</a>
                        </div>

                        <div style="margin-top:28px;text-align:center;">
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