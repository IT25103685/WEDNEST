<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard — WEDNEST</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        .error-message { color: var(--danger); font-size: 12px; margin-top: 4px; display: none; animation: fadeIn 0.3s ease; }
        .is-invalid { border-color: var(--danger) !important; box-shadow: 0 0 0 3px rgba(156, 46, 66, 0.1) !important; }
        .required::after { content: ' *'; color: var(--danger); }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }
        .section-tab {
            display: inline-flex; align-items: center; gap: 8px;
            padding: 10px 20px; border-radius: var(--radius-sm);
            font-size: 13px; font-weight: 600; cursor: pointer;
            border: 1.5px solid var(--border-color);
            background: white; color: var(--dark-text);
            transition: all 0.2s ease; text-decoration: none;
        }
        .section-tab.active, .section-tab:hover {
            background: var(--maroon); color: white; border-color: var(--maroon);
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>

<div class="container" style="padding-top:40px;padding-bottom:60px;position:relative;z-index:1;">

    <!-- Page Header -->
    <div class="page-header">
        <div style="font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gold);margin-bottom:8px;">Administration</div>
        <h1 class="page-title">Admin Dashboard</h1>
        <p class="page-subtitle">Manage wedding halls, vendors, staff and oversee all bookings across the platform.</p>
    </div>

    <!-- Stats -->
    <div class="grid grid-4 reveal" style="margin-bottom:36px;">
        <div class="stat-box" id="adminStatHalls">
            <div class="stat-icon">🏛️</div>
            <div class="stat-num">${halls.size()}</div>
            <div class="stat-label">Wedding Halls</div>
        </div>
        <div class="stat-box" id="adminStatBookings">
            <div class="stat-icon">📋</div>
            <div class="stat-num">${bookings.size()}</div>
            <div class="stat-label">Total Bookings</div>
        </div>
        <div class="stat-box" id="adminStatRevenue">
            <div class="stat-icon">💰</div>
            <div class="stat-num">${staff.size()}</div>
            <div class="stat-label">Staff Members</div>
        </div>
        <div class="stat-box" id="adminStatVendors">
            <div class="stat-icon">🤝</div>
            <div class="stat-num">—</div>
            <div class="stat-label">Active Vendors</div>
        </div>
    </div>

    <!-- ===================== HALL MANAGEMENT ===================== -->
    <div class="card-panel reveal" style="border-top:3px solid var(--maroon);" id="adminCreateHall">
        <h3>🏛️ Create a New Wedding Hall</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/halls/create" id="createHallForm" novalidate>
            <div class="grid grid-2" style="gap:20px;">
                <div class="form-group" style="margin:0;">
                    <label class="form-label required" for="hallName">Hall Name</label>
                    <input type="text" name="name" id="hallName" class="form-control" placeholder="e.g. Grand Ballroom Colombo" maxlength="150">
                    <div class="error-message" id="errHallName"></div>
                </div>
                <div class="form-group" style="margin:0;">
                    <label class="form-label required" for="hallLocation">Location</label>
                    <input type="text" name="location" id="hallLocation" class="form-control" placeholder="e.g. Colombo 3" maxlength="200">
                    <div class="error-message" id="errHallLocation"></div>
                </div>
                <div class="form-group" style="margin:0;">
                    <label class="form-label required" for="hallCapacity">Maximum Capacity</label>
                    <input type="number" name="capacityMax" id="hallCapacity" class="form-control" placeholder="e.g. 500" min="1">
                    <div class="error-message" id="errHallCapacity"></div>
                </div>
                <div class="form-group" style="margin:0;">
                    <label class="form-label required" for="hallPrice">Price per Event (Rs.)</label>
                    <input type="number" step="0.01" name="pricePerEvent" id="hallPrice" class="form-control" placeholder="e.g. 180000" min="0.01">
                    <div class="error-message" id="errHallPrice"></div>
                </div>
            </div>
            <button type="submit" class="btn btn-primary" style="margin-top:24px;" id="createHallBtn">
                + Create Hall
            </button>
        </form>
    </div>

    <!-- Halls List -->
    <div class="card-panel reveal" id="adminHallsList">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;padding-bottom:16px;border-bottom:1px solid var(--border-color);">
            <h3 style="margin:0;border:none;padding:0;">All Wedding Halls</h3>
            <span class="badge badge-available">${halls.size()} halls</span>
        </div>
        <div style="overflow-x:auto;">
            <table id="adminHallsTable">
                <thead>
                <tr>
                    <th>Hall Name</th>
                    <th>Location</th>
                    <th>Max Capacity</th>
                    <th>Price / Event</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="h" items="${halls}">
                    <tr>
                        <td><div style="font-weight:600;color:var(--maroon);">${h.name}</div></td>
                        <td>📍 ${h.location}</td>
                        <td>👥 ${h.capacityMax}</td>
                        <td>
                            <span style="font-family:'Cormorant Garamond',serif;font-size:16px;font-weight:700;color:var(--maroon);">Rs. ${h.pricePerEvent}</span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${h.active}"><span class="badge badge-available">Active</span></c:when>
                                <c:otherwise><span class="badge badge-cancelled">Inactive</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <c:if test="${h.active}">
                                <form method="post" action="${pageContext.request.contextPath}/admin/halls/${h.id}/delete"
                                      onsubmit="return confirm('Remove hall: ${h.name}? This cannot be undone.');" style="display:inline;">
                                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                </form>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ===================== ALL BOOKINGS ===================== -->
    <div class="card-panel reveal" id="adminBookingsList">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;padding-bottom:16px;border-bottom:1px solid var(--border-color);">
            <h3 style="margin:0;border:none;padding:0;">All Bookings</h3>
            <span class="badge badge-pending">${bookings.size()} total</span>
        </div>
        <div style="overflow-x:auto;">
            <table id="adminBookingsTable">
                <thead>
                <tr>
                    <th>Couple</th>
                    <th>Hall</th>
                    <th>Wedding Date</th>
                    <th>Guests</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="b" items="${bookings}">
                    <tr>
                        <td><div style="font-weight:600;">👤 ${b.coupleName}</div></td>
                        <td>${b.hallName}</td>
                        <td>📅 ${b.eventDate}</td>
                        <td>👥 ${b.expectedGuestCount}</td>
                        <td>
                            <span class="badge badge-${b.status.toLowerCase().replace('_approval','')}">
                                ${b.status}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ===================== STAFF MANAGEMENT ===================== -->
    <div class="card-panel reveal" id="adminStaffManagement" style="border-top:3px solid var(--gold); margin-top:24px;">
        <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;padding-bottom:16px;border-bottom:1px solid var(--border-color);">
            <h3 style="margin:0;border:none;padding:0;">👥 Staff Management</h3>
        </div>

        <div class="grid grid-2" style="gap:32px; align-items:start;">
            <!-- Create Staff Form -->
            <div>
                <h4 style="margin-top:0;margin-bottom:20px;">Add New Staff Member</h4>
                <form method="post" action="${pageContext.request.contextPath}/admin/staff/create" id="createStaffForm" novalidate>
                    <div class="form-group">
                        <label class="form-label required" for="staffFullName">Full Name</label>
                        <input type="text" name="fullName" id="staffFullName" class="form-control" placeholder="e.g. Amal Perera" maxlength="100">
                        <div class="error-message" id="errStaffFullName"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label required" for="staffEmail">Email Address</label>
                        <input type="email" name="email" id="staffEmail" class="form-control" placeholder="staff@wednest.lk">
                        <div class="error-message" id="errStaffEmail"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label required" for="staffPhone">Phone Number</label>
                        <input type="tel" name="phone" id="staffPhone" class="form-control" placeholder="07XXXXXXXX" maxlength="10">
                        <div class="error-message" id="errStaffPhone"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label required" for="staffUsername">Username</label>
                        <input type="text" name="username" id="staffUsername" class="form-control" placeholder="Choose a username" maxlength="50">
                        <div class="error-message" id="errStaffUsername"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label required" for="staffPassword">Password</label>
                        <input type="password" name="password" id="staffPassword" class="form-control" placeholder="Min. 8 characters">
                        <div class="error-message" id="errStaffPassword"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label required" for="staffRole">Role</label>
                        <select name="role" id="staffRole" class="form-control">
                            <option value="">-- Select Role --</option>
                            <option value="HOTEL_MANAGER">Hotel Manager</option>
                            <option value="COORDINATOR">Coordinator</option>
                            <option value="FINANCE_MANAGER">Finance Manager</option>
                            <option value="VENDOR_RELATIONS">Vendor Relations</option>
                        </select>
                        <div class="error-message" id="errStaffRole"></div>
                    </div>
                    <button type="submit" class="btn btn-primary btn-full" style="margin-top:8px;" id="createStaffBtn">
                        + Create Staff Member
                    </button>
                </form>
            </div>

            <!-- Existing Staff -->
            <div>
                <h4 style="margin-top:0;margin-bottom:20px;">Existing Staff</h4>
                <div style="overflow-x:auto;">
                    <table id="adminStaffTable">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Role</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="s" items="${staff}">
                            <tr>
                                <td>
                                    <div style="font-weight:600;">👤 ${s.fullName}</div>
                                    <div style="font-size:12px;color:var(--muted);">${s.username}</div>
                                </td>
                                <td>
                                    <span class="badge badge-confirmed">${s.role}</span>
                                </td>
                                <td>
                                    <c:if test="${s.role != 'ADMIN'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/staff/${s.id}/delete"
                                              onsubmit="return confirm('Remove staff member: ${s.fullName}?');">
                                            <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                                        </form>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.querySelectorAll('.reveal').forEach((el, i) => {
    el.style.transitionDelay = (i * 0.08) + 's';
    const obs = new IntersectionObserver(entries => {
        entries.forEach(e => { if(e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); } });
    }, { threshold: 0.05 });
    obs.observe(el);
});

// ============ HELPERS ============
function showError(id, msg) {
    const el = document.getElementById(id);
    if (!el) return;
    el.textContent = msg;
    el.style.display = 'block';
}
function clearError(id) {
    const el = document.getElementById(id);
    if(el) el.style.display = 'none';
}
function markInvalid(el) { if(el) el.classList.add('is-invalid'); }
function markValid(el)   { if(el) el.classList.remove('is-invalid'); }

// ============ HALL FORM ============
document.getElementById("createHallForm").addEventListener("submit", function(e) {
    e.preventDefault();
    let isValid = true;

    const nameEl = document.getElementById("hallName");
    const locEl  = document.getElementById("hallLocation");
    const capEl  = document.getElementById("hallCapacity");
    const priceEl = document.getElementById("hallPrice");

    [nameEl, locEl, capEl, priceEl].forEach(el => { el.value = el.value.trim(); });

    // Hall Name
    clearError("errHallName"); markValid(nameEl);
    if (!nameEl.value) { showError("errHallName","Hall Name is required."); markInvalid(nameEl); isValid=false; }

    // Location
    clearError("errHallLocation"); markValid(locEl);
    if (!locEl.value) { showError("errHallLocation","Location is required."); markInvalid(locEl); isValid=false; }

    // Capacity — must be positive integer, no leading zeros
    clearError("errHallCapacity"); markValid(capEl);
    const capVal = capEl.value;
    if (!capVal) { showError("errHallCapacity","Capacity is required."); markInvalid(capEl); isValid=false; }
    else if (capVal.startsWith('0')) { showError("errHallCapacity","Capacity cannot have leading zeros."); markInvalid(capEl); isValid=false; }
    else if (!Number.isInteger(Number(capVal)) || Number(capVal) < 1) { showError("errHallCapacity","Capacity must be a positive whole number."); markInvalid(capEl); isValid=false; }

    // Price — must be positive number
    clearError("errHallPrice"); markValid(priceEl);
    const priceVal = priceEl.value;
    if (!priceVal) { showError("errHallPrice","Price is required."); markInvalid(priceEl); isValid=false; }
    else if (Number(priceVal) <= 0) { showError("errHallPrice","Price must be greater than 0."); markInvalid(priceEl); isValid=false; }

    if (isValid) {
        const btn = document.getElementById("createHallBtn");
        btn.disabled = true;
        btn.innerHTML = 'Creating... <span style="font-size:12px;opacity:0.7;">⏳</span>';
        this.submit();
    }
});

// ============ STAFF FORM ============
document.getElementById("createStaffForm").addEventListener("submit", function(e) {
    e.preventDefault();
    let isValid = true;

    const fnEl   = document.getElementById("staffFullName");
    const emEl   = document.getElementById("staffEmail");
    const phEl   = document.getElementById("staffPhone");
    const unEl   = document.getElementById("staffUsername");
    const pwEl   = document.getElementById("staffPassword");
    const rlEl   = document.getElementById("staffRole");

    [fnEl, emEl, phEl, unEl].forEach(el => { el.value = el.value.trim(); });

    // Full Name
    clearError("errStaffFullName"); markValid(fnEl);
    if (!fnEl.value) { showError("errStaffFullName","Full Name is required."); markInvalid(fnEl); isValid=false; }
    else if (!/^[A-Za-z\s]+$/.test(fnEl.value)) { showError("errStaffFullName","Name cannot contain numbers or symbols."); markInvalid(fnEl); isValid=false; }

    // Email
    clearError("errStaffEmail"); markValid(emEl);
    if (!emEl.value) { showError("errStaffEmail","Email is required."); markInvalid(emEl); isValid=false; }
    else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emEl.value)) { showError("errStaffEmail","Invalid email address."); markInvalid(emEl); isValid=false; }

    // Phone
    clearError("errStaffPhone"); markValid(phEl);
    if (!phEl.value) { showError("errStaffPhone","Phone is required."); markInvalid(phEl); isValid=false; }
    else if (!/^\d{10}$/.test(phEl.value)) { showError("errStaffPhone","Phone must be exactly 10 digits."); markInvalid(phEl); isValid=false; }

    // Username
    clearError("errStaffUsername"); markValid(unEl);
    if (!unEl.value) { showError("errStaffUsername","Username is required."); markInvalid(unEl); isValid=false; }

    // Password
    clearError("errStaffPassword"); markValid(pwEl);
    if (!pwEl.value) { showError("errStaffPassword","Password is required."); markInvalid(pwEl); isValid=false; }
    else if (pwEl.value.length < 8) { showError("errStaffPassword","Password must be at least 8 characters."); markInvalid(pwEl); isValid=false; }
    else if (!/(?=.*[A-Za-z])(?=.*\d)/.test(pwEl.value)) { showError("errStaffPassword","Password must contain at least one letter and one number."); markInvalid(pwEl); isValid=false; }

    // Role
    clearError("errStaffRole"); markValid(rlEl);
    if (!rlEl.value) { showError("errStaffRole","Please select a role."); markInvalid(rlEl); isValid=false; }

    if (isValid) {
        const btn = document.getElementById("createStaffBtn");
        btn.disabled = true;
        btn.innerHTML = 'Creating... <span style="font-size:12px;opacity:0.7;">⏳</span>';
        this.submit();
    }
});

// Real-time error clearing
["hallName","hallLocation","hallCapacity","hallPrice"].forEach(id => {
    const el = document.getElementById(id);
    if(el) el.addEventListener('input', () => { clearError("err" + id.charAt(0).toUpperCase() + id.slice(1)); markValid(el); });
});
["staffFullName","staffEmail","staffPhone","staffUsername","staffPassword","staffRole"].forEach(id => {
    const el = document.getElementById(id);
    if(el) el.addEventListener('input', () => { clearError("err" + id.charAt(0).toUpperCase() + id.slice(1)); markValid(el); });
});
</script>
</body>
</html>
