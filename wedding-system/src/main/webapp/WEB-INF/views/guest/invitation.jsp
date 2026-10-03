<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Invitation — WEDNEST</title>
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
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
<div class="navbar">
    <div class="navbar-brand">
        <div class="brand-text">WED<span class="brand-nest">NEST</span></div>
    </div>
    <div class="navbar-actions">
        <a href="${pageContext.request.contextPath}/guest/logout" class="btn btn-secondary btn-sm">Logout</a>
    </div>
</div>

<div class="container" style="max-width:700px; padding-top:40px; padding-bottom:60px;">

    <c:if test="${not empty notifications}">
        <div style="margin-bottom:24px;">
            <c:forEach var="n" items="${notifications}">
                <div class="alert alert-warning">${n.message}</div>
            </c:forEach>
        </div>
    </c:if>

    <div class="card-panel reveal" style="text-align:center; padding:48px 32px; border-top:4px solid var(--maroon);">
        <div style="font-size:48px; margin-bottom:16px;">💌</div>
        <h1 style="font-family:'Cormorant Garamond', serif; font-size:42px; color:var(--maroon); margin-bottom:16px;">Dear ${guest.name},</h1>
        <p style="font-size:18px; color:var(--dark-text); margin-bottom:24px;">You have been invited to celebrate a beautiful wedding! 🎉</p>
        
        <div style="display:inline-flex; align-items:center; gap:10px; background:var(--ivory); padding:10px 20px; border-radius:999px; border:1px solid var(--border-color);">
            <span style="font-size:14px; color:var(--muted); font-weight:600; text-transform:uppercase; letter-spacing:1px;">Current RSVP:</span>
            <span class="badge badge-${guest.rsvpStatus.toLowerCase()}">${guest.rsvpStatus}</span>
        </div>
    </div>

    <div class="card-panel reveal" style="margin-top:24px; border-top:3px solid var(--gold);">
        <h3 style="margin-bottom:24px;">📝 Submit your RSVP</h3>
        <form method="post" action="${pageContext.request.contextPath}/guest/rsvp" id="rsvpForm">
            <div class="form-group">
                <label class="form-label" style="font-size:16px;">Will you attend?</label>
                <select name="status" id="rsvpStatus" class="form-control" style="font-size:16px; height:50px;">
                    <option value="ACCEPTED" ${guest.rsvpStatus == 'ACCEPTED' ? 'selected' : ''}>Accept with pleasure</option>
                    <option value="DECLINED" ${guest.rsvpStatus == 'DECLINED' ? 'selected' : ''}>Decline with regret</option>
                </select>
            </div>

            <div id="additionalOptions">
                <div class="form-group" style="background:var(--ivory); padding:16px; border-radius:var(--radius-sm); border:1px solid var(--border-color);">
                    <label for="plusOne" style="display:flex; align-items:center; gap:12px; cursor:pointer; margin:0;">
                        <input type="checkbox" name="plusOne" value="true" id="plusOne" ${guest.plusOne ? 'checked' : ''} style="width:20px; height:20px; accent-color:var(--maroon);">
                        <span style="font-weight:600; font-size:15px;">I'm bringing a plus-one 👩‍❤️‍👨</span>
                    </label>
                </div>

                <div class="form-group">
                    <label class="form-label" for="dietaryInput">Dietary Restrictions (optional)</label>
                    <textarea name="dietary" id="dietaryInput" class="form-control" placeholder="e.g. Vegetarian, nut allergy..." rows="3" maxlength="255">${guest.dietaryRestrictions}</textarea>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-full" style="height:52px; font-size:16px; margin-top:12px;" id="rsvpSubmitBtn">
                Send RSVP →
            </button>
        </form>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    // Reveal animations
    document.querySelectorAll('.reveal').forEach((el, i) => {
        el.style.transitionDelay = (i * 0.1) + 's';
        const obs = new IntersectionObserver(entries => {
            entries.forEach(e => { if(e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); } });
        }, { threshold: 0.1 });
        obs.observe(el);
    });

    const statusSelect = document.getElementById("rsvpStatus");
    const additionalOptions = document.getElementById("additionalOptions");
    const plusOneCheck = document.getElementById("plusOne");
    const dietaryInput = document.getElementById("dietaryInput");
    
    function toggleOptions() {
        if (statusSelect.value === 'DECLINED') {
            additionalOptions.style.opacity = '0.5';
            additionalOptions.style.pointerEvents = 'none';
            plusOneCheck.checked = false;
            dietaryInput.value = '';
        } else {
            additionalOptions.style.opacity = '1';
            additionalOptions.style.pointerEvents = 'auto';
        }
    }

    statusSelect.addEventListener('change', toggleOptions);
    toggleOptions(); // run on load

    const form = document.getElementById("rsvpForm");
    const submitBtn = document.getElementById("rsvpSubmitBtn");

    form.addEventListener("submit", function(e) {
        // Just general trim before submit
        if (dietaryInput.value) {
            dietaryInput.value = dietaryInput.value.trim();
        }
        
        submitBtn.disabled = true;
        submitBtn.innerHTML = 'Sending... <span style="font-size:12px;opacity:0.7;">⏳</span>';
    });
});
</script>
</body>
</html>
