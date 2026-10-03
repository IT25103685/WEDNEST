<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Guest List & RSVP — WEDNEST</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        .error-message {
            color: var(--danger);
            font-size: 12px;
            margin-top: 4px;
            display: none;
            animation: fadeIn 0.3s ease;
        }
        .is-invalid { border-color: var(--danger) !important; box-shadow: 0 0 0 3px rgba(156, 46, 66, 0.1) !important; }
        .required::after { content: ' *'; color: var(--danger); }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }
        .guest-code {
            font-family: monospace;
            background: rgba(212,175,55,0.15);
            color: var(--gold-dark);
            padding: 4px 8px;
            border-radius: 4px;
            font-weight: 700;
            letter-spacing: 1px;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>

<div class="container" style="padding-top:40px;padding-bottom:60px;">

    <!-- Breadcrumb -->
    <div style="font-size:13px;color:var(--muted);margin-bottom:24px;">
        <a href="${pageContext.request.contextPath}/couple/dashboard" style="color:var(--muted);text-decoration:none;">Dashboard</a>
        <span style="margin:0 8px;color:var(--gold);">›</span>
        <span style="color:var(--maroon);">Guest List</span>
    </div>

    <!-- Page Header -->
    <div class="page-header">
        <div style="font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gold);margin-bottom:8px;">Management</div>
        <h1 class="page-title">Guest List &amp; RSVP</h1>
        <p class="page-subtitle">Add guests one by one &mdash; each one automatically gets a unique guest code to RSVP with.</p>
    </div>

    <!-- Stats -->
    <div class="grid grid-4" style="margin-bottom:32px;">
        <div class="stat-box">
            <div class="stat-icon" style="color:var(--success);">✅</div>
            <div class="stat-num">${summary[0]}</div>
            <div class="stat-label">Accepted</div>
        </div>
        <div class="stat-box">
            <div class="stat-icon" style="color:var(--danger);">❌</div>
            <div class="stat-num">${summary[1]}</div>
            <div class="stat-label">Declined</div>
        </div>
        <div class="stat-box">
            <div class="stat-icon" style="color:var(--warning);">⏳</div>
            <div class="stat-num">${summary[2]}</div>
            <div class="stat-label">Pending</div>
        </div>
        <div class="stat-box" style="border-left:3px solid var(--maroon);">
            <div class="stat-icon" style="color:var(--maroon);">👥</div>
            <div class="stat-num">${summary[3]}</div>
            <div class="stat-label">Total Headcount</div>
        </div>
    </div>

    <div class="grid" style="grid-template-columns: 1fr 2.5fr; gap:32px; align-items:start;">
        
        <!-- Add Guest Form -->
        <div class="card-panel reveal" style="border-top:3px solid var(--gold); position:sticky; top:90px;">
            <h3 id="formTitle">Add a Guest</h3>
            <form id="guestForm" method="post" action="${pageContext.request.contextPath}/couple/guests/${bookingId}/add" novalidate>
                
                <div class="form-group">
                    <label class="form-label required">Guest Name</label>
                    <input type="text" name="name" id="gName" class="form-control" placeholder="Full name">
                    <div class="error-message" id="errName"></div>
                </div>

                <div class="form-group">
                    <label class="form-label required">Contact Phone</label>
                    <input type="tel" name="contact" id="gContact" class="form-control" placeholder="07XXXXXXXX" maxlength="10">
                    <div class="error-message" id="errContact"></div>
                </div>

                <div class="form-group">
                    <label class="form-label required">Category</label>
                    <select name="category" id="gCategory" class="form-control" onchange="toggleFamily()">
                        <option value="">-- Select Category --</option>
                        <option value="Family">Family</option>
                        <option value="Friend">Friend</option>
                        <option value="Colleague">Colleague</option>
                    </select>
                    <div class="error-message" id="errCategory"></div>
                </div>

                <div class="form-group" id="familyCountDiv" style="display:none;">
                    <label class="form-label">Family Members Count</label>
                    <input type="number" name="familyMembersCount" id="gFamily" value="1" min="1" class="form-control">
                </div>

                <div style="margin-top: 24px; display:flex; flex-direction:column; gap:10px;">
                    <button type="submit" class="btn btn-primary btn-full" id="gSubmit">Add Guest</button>
                    <button type="button" class="btn btn-secondary btn-full" id="gCancel" style="display:none;" onclick="cancelEdit()">Cancel Edit</button>
                </div>
            </form>
        </div>

        <!-- Guest List Table -->
        <div class="card-panel reveal">
            <h3 style="margin-bottom:20px;">Guest Roster</h3>
            <c:choose>
                <c:when test="${empty guests}">
                    <div class="empty-state" style="padding:40px 20px;">
                        <div class="empty-icon">👥</div>
                        <h3>No guests yet</h3>
                        <p>Start building your guest list by adding people from the form.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="overflow-x:auto;">
                        <table style="min-width:700px;">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Category</th>
                                    <th>Guest Code</th>
                                    <th>RSVP</th>
                                    <th>Dietary</th>
                                    <th>+1</th>
                                    <th style="text-align:right;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="g" items="${guests}">
                                    <tr>
                                        <td>
                                            <div style="font-weight:600;color:var(--maroon);">${g.name}</div>
                                            <div style="font-size:12px;color:var(--muted);">${g.contact}</div>
                                            <c:if test="${g.category == 'Family'}">
                                                <div style="font-size:11px;color:var(--muted);margin-top:2px;">Count: ${g.familyMembersCount}</div>
                                            </c:if>
                                        </td>
                                        <td><span class="badge" style="background:rgba(0,0,0,0.05);color:var(--dark-text);">${g.category}</span></td>
                                        <td><span class="guest-code">${g.guestCode}</span></td>
                                        <td><span class="badge badge-${g.rsvpStatus.toLowerCase()}">${g.rsvpStatus}</span></td>
                                        <td style="max-width:120px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" title="${g.dietaryRestrictions}">
                                            ${empty g.dietaryRestrictions ? '-' : g.dietaryRestrictions}
                                        </td>
                                        <td>${g.plusOne ? '✅' : '❌'}</td>
                                        <td style="text-align:right;white-space:nowrap;">
                                            <button type="button" class="btn btn-sm btn-secondary" onclick="editGuest(${g.id}, '${g.name}', '${g.contact}', '${g.category}', ${g.familyMembersCount})" style="padding:6px 12px;font-size:12px;">Edit</button>
                                            <form method="post" action="${pageContext.request.contextPath}/couple/guests/${bookingId}/remove/${g.id}" style="display:inline;" onsubmit="return confirm('Remove guest?');">
                                                <button type="submit" class="btn btn-sm btn-danger" style="padding:6px 12px;font-size:12px;margin-left:4px;">Remove</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>
</div>

<script>
function toggleFamily() {
    var cat = document.getElementById("gCategory").value;
    document.getElementById("familyCountDiv").style.display = (cat === 'Family') ? 'block' : 'none';
}

function editGuest(id, name, contact, category, familyCount) {
    document.getElementById("formTitle").innerText = "Edit Guest";
    document.getElementById("guestForm").action = "${pageContext.request.contextPath}/couple/guests/${bookingId}/update/" + id;
    document.getElementById("gName").value = name;
    document.getElementById("gContact").value = contact;
    document.getElementById("gCategory").value = category;
    document.getElementById("gFamily").value = familyCount;
    document.getElementById("gSubmit").innerText = "Update Guest";
    document.getElementById("gCancel").style.display = "block";
    toggleFamily();
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function cancelEdit() {
    document.getElementById("formTitle").innerText = "Add a Guest";
    document.getElementById("guestForm").action = "${pageContext.request.contextPath}/couple/guests/${bookingId}/add";
    document.getElementById("guestForm").reset();
    document.getElementById("gSubmit").innerText = "Add Guest";
    document.getElementById("gCancel").style.display = "none";
    toggleFamily();
}

document.addEventListener("DOMContentLoaded", function() {
    // Reveal animations
    document.querySelectorAll('.reveal').forEach((el, i) => {
        el.style.transitionDelay = (i * 0.1) + 's';
        const obs = new IntersectionObserver(entries => {
            entries.forEach(e => { if(e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); } });
        }, { threshold: 0.1 });
        obs.observe(el);
    });

    const form = document.getElementById("guestForm");
    const submitBtn = document.getElementById("gSubmit");
    
    const fields = {
        name: document.getElementById("gName"),
        contact: document.getElementById("gContact"),
        category: document.getElementById("gCategory")
    };
    
    function showError(inputElement, errorElementId, message) {
        const errorDiv = document.getElementById(errorElementId);
        errorDiv.textContent = message;
        errorDiv.style.display = 'block';
        inputElement.classList.add('is-invalid');
    }
    
    function clearError(inputElement, errorElementId) {
        const errorDiv = document.getElementById(errorElementId);
        errorDiv.style.display = 'none';
        inputElement.classList.remove('is-invalid');
    }

    form.addEventListener("submit", function(e) {
        e.preventDefault(); 
        let isValid = true;
        
        // Trim inputs
        fields.name.value = fields.name.value.trim();
        fields.contact.value = fields.contact.value.trim();

        // Reset errors
        for (const key in fields) {
            clearError(fields[key], "err" + key.charAt(0).toUpperCase() + key.slice(1));
        }

        // Name Validation
        const nameVal = fields.name.value;
        if (!nameVal) {
            showError(fields.name, "errName", "Guest Name is required.");
            isValid = false;
        } else if (nameVal.length > 100) {
            showError(fields.name, "errName", "Name is too long (max 100 chars).");
            isValid = false;
        } else if (!/^[A-Za-z\s]+$/.test(nameVal)) {
            showError(fields.name, "errName", "Name can only contain letters and spaces.");
            isValid = false;
        }

        // Contact Validation
        const contactVal = fields.contact.value;
        if (!contactVal) {
            showError(fields.contact, "errContact", "Contact number is required.");
            isValid = false;
        } else if (!/^\d{10}$/.test(contactVal)) {
            showError(fields.contact, "errContact", "Contact must be exactly 10 digits.");
            isValid = false;
        }

        // Category Validation
        if (!fields.category.value) {
            showError(fields.category, "errCategory", "Please select a category.");
            isValid = false;
        }

        if (isValid) {
            submitBtn.disabled = true;
            submitBtn.innerHTML = 'Saving... <span style="font-size:12px;opacity:0.7;">⏳</span>';
            form.submit();
        }
    });

    // Real-time input clearing
    for (const key in fields) {
        fields[key].addEventListener('input', function() {
            clearError(this, "err" + key.charAt(0).toUpperCase() + key.slice(1));
        });
    }

    // Init family toggle
    toggleFamily();
});
</script>
</body>
</html>
