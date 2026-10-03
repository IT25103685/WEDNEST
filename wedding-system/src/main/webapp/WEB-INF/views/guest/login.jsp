<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Access your wedding invitation and RSVP via WEDNEST.">
    <title>Guest Invitation — WEDNEST</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        .error-message {
            color: var(--danger);
            font-size: 12px;
            margin-top: 4px;
            display: none;
            animation: fadeIn 0.3s ease;
        }
        .form-group { position: relative; margin-bottom: 24px; }
        .is-invalid { border-color: var(--danger) !important; box-shadow: 0 0 0 3px rgba(156, 46, 66, 0.1) !important; }
        .required::after { content: ' *'; color: var(--danger); }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes float {
            0%,100% { transform: translateY(0) rotate(0deg); }
            50% { transform: translateY(-10px) rotate(5deg); }
        }
    </style>
</head>
<body style="background:var(--maroon-dark);overflow:hidden;">

<div class="auth-wrapper">
    <!-- Left decorative panel -->
    <div class="auth-left">
        <svg style="position:absolute;top:0;left:0;opacity:0.06;pointer-events:none;" width="300" height="300" viewBox="0 0 200 200">
            <circle cx="100" cy="100" r="80" fill="none" stroke="#D4AF37" stroke-width="0.8"/>
            <circle cx="100" cy="100" r="60" fill="none" stroke="#D4AF37" stroke-width="0.5"/>
            <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3"/>
            <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3" transform="rotate(60,100,100)"/>
            <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3" transform="rotate(120,100,100)"/>
            <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3" transform="rotate(180,100,100)"/>
            <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3" transform="rotate(240,100,100)"/>
            <path d="M100 20 Q120 60 100 100 Q80 60 100 20" fill="#D4AF37" opacity="0.3" transform="rotate(300,100,100)"/>
        </svg>

        <div class="auth-left-content">
            <div style="font-size:52px;margin-bottom:16px;animation:float 4s ease-in-out infinite;">💌</div>
            <h2>You're<br><em style="color:var(--gold-light);">Invited!</em></h2>
            <p>Access your personalized digital invitation and RSVP for the special day.</p>

            <div style="display:flex;flex-direction:column;gap:14px;margin-top:8px;">
                <div style="display:flex;align-items:center;gap:12px;">
                    <div style="width:36px;height:36px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:18px;">✦</div>
                    <span style="font-size:14px;color:rgba(255,255,255,0.75);">View wedding details</span>
                </div>
                <div style="display:flex;align-items:center;gap:12px;">
                    <div style="width:36px;height:36px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:18px;">✦</div>
                    <span style="font-size:14px;color:rgba(255,255,255,0.75);">Submit your RSVP instantly</span>
                </div>
                <div style="display:flex;align-items:center;gap:12px;">
                    <div style="width:36px;height:36px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;font-size:18px;">✦</div>
                    <span style="font-size:14px;color:rgba(255,255,255,0.75);">Add dietary preferences</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right form panel -->
    <div class="auth-right">
        <div class="auth-form-box">
            <div class="auth-logo">WED<span>NEST</span></div>
            <h1 class="auth-title">Enter Guest Code</h1>
            <p class="auth-sub">Please enter the 7-character code found on your invitation.</p>

            <c:if test="${not empty error}">
                <div class="alert alert-error">⚠️ ${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/guest/login" id="guestLoginForm" novalidate>
                <div class="form-group">
                    <label class="form-label required" for="guestCode">Guest Code</label>
                    <input type="text" name="guestCode" id="guestCode" class="form-control" placeholder="e.g. A1B2C3D" style="text-transform:uppercase;letter-spacing:2px;font-weight:600;text-align:center;" maxlength="7" autocomplete="off">
                    <div class="error-message" id="errGuestCode"></div>
                </div>
                <button type="submit" class="btn btn-primary btn-full" style="margin-top:24px;height:50px;font-size:15px;" id="guestLoginSubmitBtn">
                    Open My Invitation →
                </button>
            </form>

            <div class="gold-rule"></div>

            <div style="text-align:center;font-size:14px;color:var(--muted);line-height:2;">
                Not a guest? <a href="${pageContext.request.contextPath}/login" class="auth-link">Staff & Couple Login</a><br>
                Vendor? <a href="${pageContext.request.contextPath}/vendor/signup" class="auth-link">Vendor Registration</a>
            </div>

            <div style="margin-top:28px;text-align:center;">
                <a href="${pageContext.request.contextPath}/" style="font-size:13px;color:var(--silver);text-decoration:none;" class="auth-link">← Back to Home</a>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById("guestLoginForm");
    const submitBtn = document.getElementById("guestLoginSubmitBtn");
    const inputCode = document.getElementById("guestCode");
    const errCode = document.getElementById("errGuestCode");
    
    function showError(message) {
        errCode.textContent = message;
        errCode.style.display = 'block';
        inputCode.classList.add('is-invalid');
    }
    
    function clearError() {
        errCode.style.display = 'none';
        inputCode.classList.remove('is-invalid');
    }

    // Force uppercase on input
    inputCode.addEventListener('input', function() {
        this.value = this.value.toUpperCase();
        clearError();
    });

    form.addEventListener("submit", function(e) {
        e.preventDefault(); 
        
        let val = inputCode.value.trim().toUpperCase();
        inputCode.value = val; // Apply transformed back to input

        if (!val) {
            showError("Guest code is required.");
        } else if (val.length !== 7 || !/^[A-Z0-9]{7}$/.test(val)) {
            showError("Guest code must be exactly 7 alphanumeric characters.");
        } else {
            clearError();
            submitBtn.disabled = true;
            submitBtn.innerHTML = 'Opening Invitation... <span style="font-size:12px;opacity:0.7;">⏳</span>';
            form.submit();
        }
    });
});
</script>
</body>
</html>
