<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Register your business as a vendor on WEDNEST — Sri Lanka's premier wedding platform.">
    <title>Vendor Registration — WEDNEST</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        .error-message { color: var(--danger); font-size: 12px; margin-top: 4px; display: none; animation: fadeIn 0.3s ease; }
        .form-group { position: relative; margin-bottom: 24px; }
        .is-invalid { border-color: var(--danger) !important; box-shadow: 0 0 0 3px rgba(156, 46, 66, 0.1) !important; }
        .required::after { content: ' *'; color: var(--danger); }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }
        @keyframes float { 0%,100% { transform: translateY(0); } 50% { transform: translateY(-10px); } }
    </style>
</head>
<body style="background:var(--maroon-dark);">

<div class="auth-wrapper">
    <!-- Left Panel -->
    <div class="auth-left" style="flex:0 0 420px;">
        <svg style="position:absolute;top:0;left:0;opacity:0.06;pointer-events:none;" width="300" height="300" viewBox="0 0 200 200">
            <circle cx="100" cy="100" r="80" fill="none" stroke="#D4AF37" stroke-width="0.8"/>
            <circle cx="100" cy="100" r="60" fill="none" stroke="#D4AF37" stroke-width="0.5"/>
        </svg>
        <div class="auth-left-content">
            <div style="font-size:52px;margin-bottom:16px;animation:float 4s ease-in-out infinite;">🤝</div>
            <h2>Join as a<br><em style="color:var(--gold-light);">Wedding Vendor</em></h2>
            <p>Partner with WEDNEST and connect with hundreds of couples planning their perfect wedding.</p>
            <div style="display:flex;flex-direction:column;gap:14px;margin-top:16px;">
                <div style="display:flex;align-items:center;gap:12px;">
                    <div style="width:32px;height:32px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;">✦</div>
                    <span style="font-size:14px;color:rgba(255,255,255,0.75);">Reach verified couples</span>
                </div>
                <div style="display:flex;align-items:center;gap:12px;">
                    <div style="width:32px;height:32px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;">✦</div>
                    <span style="font-size:14px;color:rgba(255,255,255,0.75);">Manage bookings digitally</span>
                </div>
                <div style="display:flex;align-items:center;gap:12px;">
                    <div style="width:32px;height:32px;border-radius:50%;background:rgba(212,175,55,0.15);display:flex;align-items:center;justify-content:center;flex-shrink:0;">✦</div>
                    <span style="font-size:14px;color:rgba(255,255,255,0.75);">Build your rating & reputation</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Form Panel -->
    <div class="auth-right" style="padding:40px 56px;overflow-y:auto;">
        <div class="auth-form-box" style="max-width:420px;">
            <div class="auth-logo">WED<span>NEST</span></div>
            <h1 class="auth-title">Vendor Registration</h1>
            <p class="auth-sub">Caterer, Photographer, Decorator, DJ, Makeup Artist, Cake or Transport</p>

            <c:if test="${not empty error}">
                <div class="alert alert-error">⚠️ ${error}</div>
            </c:if>

            <form method="post" action="${pageContext.request.contextPath}/vendor/signup" id="vendorSignupForm" novalidate>
                <div class="form-group">
                    <label class="form-label required" for="vFullName">Contact Full Name</label>
                    <input type="text" name="fullName" id="vFullName" class="form-control" placeholder="e.g. Amal Perera" maxlength="100">
                    <div class="error-message" id="errVFullName"></div>
                </div>
                <div class="form-group">
                    <label class="form-label required" for="vEmail">Email Address</label>
                    <input type="email" name="email" id="vEmail" class="form-control" placeholder="your@business.com">
                    <div class="error-message" id="errVEmail"></div>
                </div>
                <div class="form-group">
                    <label class="form-label required" for="vPhone">Contact Phone</label>
                    <input type="tel" name="phone" id="vPhone" class="form-control" placeholder="07XXXXXXXX" maxlength="10">
                    <div class="error-message" id="errVPhone"></div>
                </div>
                <div class="form-group">
                    <label class="form-label required" for="vCompany">Company / Business Name</label>
                    <input type="text" name="companyName" id="vCompany" class="form-control" placeholder="e.g. Amal Photography Studio" maxlength="150">
                    <div class="error-message" id="errVCompany"></div>
                </div>
                <div class="form-group">
                    <label class="form-label required" for="vCategory">Service Category</label>
                    <select name="category" id="vCategory" class="form-control">
                        <option value="">-- Select Category --</option>
                        <option value="CATERER">Caterer</option>
                        <option value="PHOTOGRAPHER">Photographer</option>
                        <option value="DECORATOR">Decorator</option>
                        <option value="DJ">DJ / Music Vendor</option>
                        <option value="MAKEUP_ARTIST">Makeup Artist</option>
                        <option value="CAKE">Cake Vendor</option>
                        <option value="TRANSPORT">Transport Vendor</option>
                    </select>
                    <div class="error-message" id="errVCategory"></div>
                </div>
                <div class="form-group">
                    <label class="form-label required" for="vUsername">Username</label>
                    <input type="text" name="username" id="vUsername" class="form-control" placeholder="Choose a login username" maxlength="50">
                    <div class="error-message" id="errVUsername"></div>
                </div>
                <div class="form-group">
                    <label class="form-label required" for="vPassword">Password</label>
                    <input type="password" name="password" id="vPassword" class="form-control" placeholder="Min. 8 characters">
                    <div class="error-message" id="errVPassword"></div>
                </div>
                <div class="form-group">
                    <label class="form-label required" for="vConfirmPassword">Confirm Password</label>
                    <input type="password" id="vConfirmPassword" class="form-control" placeholder="Repeat your password">
                    <div class="error-message" id="errVConfirmPassword"></div>
                </div>

                <button type="submit" class="btn btn-primary btn-full" style="margin-top:8px;height:50px;font-size:15px;" id="vendorSignupBtn">
                    Register as Vendor →
                </button>
            </form>

            <div class="gold-rule"></div>
            <div style="text-align:center;font-size:14px;color:var(--muted);">
                Already have an account? <a href="${pageContext.request.contextPath}/login" class="auth-link">Sign in</a>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById("vendorSignupForm");
    const submitBtn = document.getElementById("vendorSignupBtn");

    function showError(id, msg) {
        const el = document.getElementById(id);
        el.textContent = msg;
        el.style.display = 'block';
    }
    function clearError(id) { document.getElementById(id).style.display = 'none'; }
    function markInvalid(el) { el.classList.add('is-invalid'); }
    function markValid(el)   { el.classList.remove('is-invalid'); }

    form.addEventListener("submit", function(e) {
        e.preventDefault();
        let isValid = true;

        const fields = ['vFullName','vEmail','vPhone','vCompany','vCategory','vUsername','vPassword','vConfirmPassword'];

        // Trim text inputs
        ['vFullName','vEmail','vPhone','vCompany','vUsername'].forEach(id => {
            document.getElementById(id).value = document.getElementById(id).value.trim();
        });

        // Full Name
        const fnEl = document.getElementById("vFullName");
        clearError("errVFullName"); markValid(fnEl);
        if (!fnEl.value) { showError("errVFullName","Full Name is required."); markInvalid(fnEl); isValid=false; }
        else if (!/^[A-Za-z\s]+$/.test(fnEl.value)) { showError("errVFullName","Name cannot contain numbers or symbols."); markInvalid(fnEl); isValid=false; }

        // Email
        const emEl = document.getElementById("vEmail");
        clearError("errVEmail"); markValid(emEl);
        if (!emEl.value) { showError("errVEmail","Email is required."); markInvalid(emEl); isValid=false; }
        else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emEl.value)) { showError("errVEmail","Invalid email address."); markInvalid(emEl); isValid=false; }

        // Phone
        const phEl = document.getElementById("vPhone");
        clearError("errVPhone"); markValid(phEl);
        if (!phEl.value) { showError("errVPhone","Phone is required."); markInvalid(phEl); isValid=false; }
        else if (!/^\d{10}$/.test(phEl.value)) { showError("errVPhone","Phone must be exactly 10 digits."); markInvalid(phEl); isValid=false; }

        // Company Name
        const coEl = document.getElementById("vCompany");
        clearError("errVCompany"); markValid(coEl);
        if (!coEl.value) { showError("errVCompany","Company Name is required."); markInvalid(coEl); isValid=false; }

        // Category
        const catEl = document.getElementById("vCategory");
        clearError("errVCategory"); markValid(catEl);
        if (!catEl.value) { showError("errVCategory","Please select a service category."); markInvalid(catEl); isValid=false; }

        // Username
        const unEl = document.getElementById("vUsername");
        clearError("errVUsername"); markValid(unEl);
        if (!unEl.value) { showError("errVUsername","Username is required."); markInvalid(unEl); isValid=false; }

        // Password
        const pwEl = document.getElementById("vPassword");
        clearError("errVPassword"); markValid(pwEl);
        if (!pwEl.value) { showError("errVPassword","Password is required."); markInvalid(pwEl); isValid=false; }
        else if (pwEl.value.length < 8) { showError("errVPassword","Password must be at least 8 characters."); markInvalid(pwEl); isValid=false; }
        else if (!/(?=.*[A-Za-z])(?=.*\d)/.test(pwEl.value)) { showError("errVPassword","Password must contain at least one letter and one number."); markInvalid(pwEl); isValid=false; }

        // Confirm Password
        const cpEl = document.getElementById("vConfirmPassword");
        clearError("errVConfirmPassword"); markValid(cpEl);
        if (pwEl.value !== cpEl.value) { showError("errVConfirmPassword","Passwords do not match."); markInvalid(cpEl); isValid=false; }

        if (isValid) {
            submitBtn.disabled = true;
            submitBtn.innerHTML = 'Registering... <span style="font-size:12px;opacity:0.7;">⏳</span>';
            form.submit();
        }
    });

    // Real-time clear
    ['vFullName','vEmail','vPhone','vCompany','vCategory','vUsername','vPassword','vConfirmPassword'].forEach(id => {
        document.getElementById(id).addEventListener('input', function() {
            clearError("err" + id.charAt(0).toUpperCase() + id.slice(1));
            this.classList.remove('is-invalid');
        });
    });
});
</script>
</body>
</html>
