<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Timeline Builder — WEDNEST</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        .error-message { color: var(--danger); font-size: 12px; margin-top: 4px; display: none; animation: fadeIn 0.3s ease; }
        .is-invalid { border-color: var(--danger) !important; box-shadow: 0 0 0 3px rgba(156, 46, 66, 0.1) !important; }
        .required::after { content: ' *'; color: var(--danger); }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }
        #overlapWarning {
            display: none;
            background: rgba(212,175,55,0.12);
            border-left: 4px solid var(--gold);
            padding: 12px 16px;
            border-radius: var(--radius-sm);
            font-size: 13px;
            color: #7a5c00;
            margin-top: 12px;
            animation: fadeIn 0.3s ease;
        }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>

<div class="container" style="padding-top:40px;padding-bottom:60px;">

    <!-- Breadcrumb -->
    <div style="font-size:13px;color:var(--muted);margin-bottom:24px;">
        <a href="${pageContext.request.contextPath}/coordinator/dashboard" style="color:var(--muted);text-decoration:none;">Dashboard</a>
        <span style="margin:0 8px;color:var(--gold);">›</span>
        <span style="color:var(--maroon);">Timeline Builder</span>
    </div>

    <!-- Page Header -->
    <div class="page-header">
        <div style="font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gold);margin-bottom:8px;">Event Coordination</div>
        <h1 class="page-title">Timeline — ${booking.coupleName}</h1>
        <p class="page-subtitle">
            ${booking.hallName} &middot; 📅 ${booking.eventDate} &middot;
            <span class="badge badge-${timeline.status.toLowerCase()}">${timeline.status}</span>
        </p>
    </div>

    <!-- Alerts -->
    <c:if test="${not empty conflictWarning}">
        <div class="alert alert-error" style="margin-bottom:24px;">⚠️ ${conflictWarning}</div>
    </c:if>
    <c:if test="${timeline.status == 'CHANGE_REQUESTED'}">
        <div class="alert alert-warning" style="margin-bottom:24px;">
            <div>
                <strong>💬 Couple Requested a Change:</strong><br>
                ${timeline.changeRequestMessage}
            </div>
        </div>
    </c:if>

    <div class="grid" style="grid-template-columns: 1fr 1.5fr; gap: 32px; align-items:start;">

        <!-- Add Event Form -->
        <div class="card-panel reveal" style="border-top:3px solid var(--maroon); position:sticky; top:90px;">
            <h3 style="margin-bottom:20px;">➕ Add Event / Vendor Slot</h3>
            <form method="post" action="${pageContext.request.contextPath}/coordinator/timeline/${timeline.id}/add-event" id="addEventForm" novalidate>
                <input type="hidden" name="bookingId" value="${booking.id}">

                <div class="form-group">
                    <label class="form-label required" for="eventName">Event Name</label>
                    <input type="text" name="eventName" id="eventName" class="form-control"
                           placeholder="e.g. Ceremony / Reception / Cake Cutting" maxlength="100">
                    <div class="error-message" id="errEventName"></div>
                </div>

                <div class="form-group">
                    <label class="form-label required" for="startTime">Start Time</label>
                    <input type="datetime-local" name="startTime" id="startTime" class="form-control">
                    <div class="error-message" id="errStartTime"></div>
                </div>

                <div class="form-group">
                    <label class="form-label required" for="endTime">End Time</label>
                    <input type="datetime-local" name="endTime" id="endTime" class="form-control">
                    <div class="error-message" id="errEndTime"></div>
                </div>

                <div id="overlapWarning">
                    ⚠️ <strong>Possible overlap detected.</strong> Please check the schedule below before adding.
                </div>

                <div class="form-group" style="margin-top:16px;">
                    <label class="form-label" for="vendorId">Responsible Vendor (optional)</label>
                    <select name="vendorId" id="vendorId" class="form-control">
                        <option value="">-- None --</option>
                        <c:forEach var="vr" items="${vendors}">
                            <option value="${vr.id}">${vr.companyName} (${vr.category})</option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary btn-full" style="height:48px;" id="addEventBtn">
                    Add to Timeline
                </button>
            </form>
        </div>

        <!-- Current Schedule + Publish -->
        <div>
            <div class="card-panel reveal" style="border-top:3px solid var(--gold);">
                <h3 style="margin-bottom:20px;">📋 Current Schedule</h3>
                <c:choose>
                    <c:when test="${empty events}">
                        <div class="empty-state" style="padding:32px 0;">
                            <div class="empty-icon">📅</div>
                            <p>No events added yet. Use the form to build the schedule.</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div style="overflow-x:auto;">
                            <table id="eventsTable">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Event Name</th>
                                        <th>Start Time</th>
                                        <th>End Time</th>
                                        <th>Vendor</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="e" items="${events}" varStatus="loop">
                                        <tr>
                                            <td style="font-weight:600;color:var(--muted);">${loop.index + 1}</td>
                                            <td style="font-weight:600;color:var(--maroon);">${e.eventName}</td>
                                            <td style="white-space:nowrap;">${e.startTime}</td>
                                            <td style="white-space:nowrap;">${e.endTime}</td>
                                            <td>${empty e.vendorId ? '—' : e.vendorId}</td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="card-panel reveal" style="border-top:3px solid var(--success);margin-top:0;">
                <h3 style="color:var(--success);">🚀 Publish Timeline</h3>
                <p style="font-size:14px;color:var(--muted);margin-bottom:20px;">
                    Once published, the couple and all selected vendors will be able to view this schedule.
                </p>
                <form method="post" action="${pageContext.request.contextPath}/coordinator/timeline/${timeline.id}/publish" id="publishForm">
                    <input type="hidden" name="bookingId" value="${booking.id}">
                    <button type="submit" class="btn btn-success btn-full" style="height:48px;" id="publishBtn">
                        Publish Timeline to Couple &amp; Vendors
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    document.querySelectorAll('.reveal').forEach((el, i) => {
        el.style.transitionDelay = (i * 0.1) + 's';
        const obs = new IntersectionObserver(entries => {
            entries.forEach(e => { if(e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); } });
        }, { threshold: 0.1 });
        obs.observe(el);
    });

    // ---- Existing events for overlap check ----
    const existingEvents = [
        <c:forEach var="e" items="${events}" varStatus="loop">
            { start: "${e.startTime}", end: "${e.endTime}" }${!loop.last ? ',' : ''}
        </c:forEach>
    ];

    const weddingDate = "${booking.eventDate}"; // yyyy-MM-dd

    function showError(id, msg) {
        const el = document.getElementById(id);
        el.textContent = msg;
        el.style.display = 'block';
    }
    function clearError(id) {
        const el = document.getElementById(id);
        if(el) { el.style.display = 'none'; }
    }
    function markInvalid(el) { if(el) el.classList.add('is-invalid'); }
    function markValid(el)   { if(el) el.classList.remove('is-invalid'); }

    function checkOverlap(newStart, newEnd) {
        if (!newStart || !newEnd) return false;
        const ns = new Date(newStart).getTime();
        const ne = new Date(newEnd).getTime();
        for (const ev of existingEvents) {
            const es = new Date(ev.start).getTime();
            const ee = new Date(ev.end).getTime();
            if (ns < ee && ne > es) return true; // overlap
        }
        return false;
    }

    const startInput = document.getElementById("startTime");
    const endInput = document.getElementById("endTime");
    const overlapWarning = document.getElementById("overlapWarning");

    function liveOverlapCheck() {
        const s = startInput.value;
        const en = endInput.value;
        if (s && en && checkOverlap(s, en)) {
            overlapWarning.style.display = 'block';
        } else {
            overlapWarning.style.display = 'none';
        }
    }

    startInput.addEventListener('change', liveOverlapCheck);
    endInput.addEventListener('change', liveOverlapCheck);

    // ---- Form Validation ----
    const form = document.getElementById("addEventForm");
    const addBtn = document.getElementById("addEventBtn");

    form.addEventListener("submit", function(e) {
        e.preventDefault();
        let isValid = true;

        // Event name
        const nameEl = document.getElementById("eventName");
        const nameVal = nameEl.value.trim();
        nameEl.value = nameVal;
        clearError("errEventName"); markValid(nameEl);
        if (!nameVal) {
            showError("errEventName", "Event Name is required."); markInvalid(nameEl); isValid = false;
        } else if (nameVal.length > 100) {
            showError("errEventName", "Event Name is too long (max 100 chars)."); markInvalid(nameEl); isValid = false;
        }

        // Start time
        const startEl = document.getElementById("startTime");
        clearError("errStartTime"); markValid(startEl);
        if (!startEl.value) {
            showError("errStartTime", "Start Time is required."); markInvalid(startEl); isValid = false;
        } else if (weddingDate && !startEl.value.startsWith(weddingDate)) {
            showError("errStartTime", "Start time should be on the wedding date (" + weddingDate + ").");
            markInvalid(startEl); isValid = false;
        }

        // End time
        const endEl = document.getElementById("endTime");
        clearError("errEndTime"); markValid(endEl);
        if (!endEl.value) {
            showError("errEndTime", "End Time is required."); markInvalid(endEl); isValid = false;
        } else if (startEl.value && new Date(endEl.value) <= new Date(startEl.value)) {
            showError("errEndTime", "End time must be after start time."); markInvalid(endEl); isValid = false;
        }

        if (isValid) {
            addBtn.disabled = true;
            addBtn.innerHTML = 'Adding... <span style="font-size:12px;opacity:0.7;">⏳</span>';
            form.submit();
        }
    });

    // Input clearing
    document.getElementById("eventName").addEventListener('input', () => clearError("errEventName"));
    startInput.addEventListener('change', () => clearError("errStartTime"));
    endInput.addEventListener('change', () => clearError("errEndTime"));

    // Publish button
    const publishForm = document.getElementById("publishForm");
    if (publishForm) {
        publishForm.addEventListener("submit", function() {
            const btn = document.getElementById("publishBtn");
            btn.disabled = true;
            btn.innerHTML = 'Publishing... <span style="font-size:12px;opacity:0.7;">⏳</span>';
        });
    }
});
</script>
</body>
</html>
