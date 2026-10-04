<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book ${hall.name} — WEDNEST</title>
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
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>

<div class="container" style="padding-top:40px;padding-bottom:60px;position:relative;z-index:1;">

    <!-- Breadcrumb -->
    <div style="font-size:13px;color:var(--muted);margin-bottom:24px;">
        <a href="${pageContext.request.contextPath}/couple/dashboard" style="color:var(--muted);text-decoration:none;">Dashboard</a>
        <span style="margin:0 8px;color:var(--gold);">›</span>
        <a href="${pageContext.request.contextPath}/couple/search-venues" style="color:var(--muted);text-decoration:none;">Search Venues</a>
        <span style="margin:0 8px;color:var(--gold);">›</span>
        <span style="color:var(--maroon);">Book Venue</span>
    </div>

    <!-- Page Header -->
    <div class="page-header">
        <div style="font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gold);margin-bottom:8px;">Reservation</div>
        <h1 class="page-title">Book ${hall.name}</h1>
        <p class="page-subtitle">
            📍 ${hall.location} &middot; 👥 Up to ${hall.capacityMax} guests &middot; Rs. ${hall.pricePerEvent} venue fee
        </p>
    </div>

    <div class="grid grid-2" style="align-items:start;">

        <!-- Main Form -->
        <div>
            <div class="card-panel reveal" style="border-top:3px solid var(--maroon);" id="bookingForm">
                <h3>Booking Summary</h3>
                <div id="bookingGlobalError" class="alert alert-error" style="display:none;"></div>

                <!-- Booking Info -->
                <div style="background:var(--ivory);border-radius:var(--radius-sm);padding:20px;margin-bottom:24px;border:1px solid var(--border-color);">
                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;">
                        <div>
                            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:4px;">Venue</div>
                            <div style="font-weight:600;color:var(--maroon);">${hall.name}</div>
                        </div>
                        <div>
                            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:4px;">Location</div>
                            <div style="font-weight:500;">${hall.location}</div>
                        </div>
                        <div>
                            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:4px;">Wedding Date</div>
                            <div style="font-weight:600;color:var(--maroon);">📅 ${eventDate}</div>
                        </div>
                        <div>
                            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:4px;">Guest Count</div>
                            <div style="font-weight:600;">👥 ${guestCount} guests</div>
                        </div>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/couple/book" id="bookingMainForm" novalidate>
                    <input type="hidden" name="hallId"    value="${hall.id}">
                    <input type="hidden" name="eventDate" id="hiddenEventDate" value="${eventDate}">
                    <input type="hidden" name="guestCount" id="hiddenGuestCount" value="${guestCount}">

                    <!-- Vendors Section -->
                    <c:if test="${not empty vendors}">
                        <div style="margin-bottom:24px;">
                            <div style="font-size:13px;font-weight:700;color:var(--maroon);margin-bottom:8px;text-transform:uppercase;letter-spacing:1px;">
                                ✦ Select Vendors (Optional)
                            </div>
                            <p style="font-size:13px;color:var(--muted);margin-bottom:16px;line-height:1.5;">
                                Selected vendors will receive your wedding details and must accept before the day.
                            </p>
                            <div style="display:flex;flex-direction:column;gap:10px;">
                                <c:forEach var="v" items="${vendors}">
                                    <label for="v${v.id}"
                                           style="display:flex;align-items:center;gap:12px;padding:14px 16px;border:1.5px solid var(--border-color);border-radius:var(--radius-sm);cursor:pointer;transition:all 0.2s;background:rgba(255,255,255,0.7);"
                                           onmouseover="this.style.borderColor='var(--gold)';this.style.background='rgba(212,175,55,0.04)';"
                                           onmouseout="this.style.borderColor='var(--border-color)';this.style.background='rgba(255,255,255,0.7)';">
                                        <input type="checkbox" name="vendorIds" value="${v.id}" id="v${v.id}" style="width:auto;accent-color:var(--maroon);transform:scale(1.2);">
                                        <div>
                                            <div style="font-weight:600;font-size:14px;">${v.companyName}</div>
                                            <div style="font-size:12px;color:var(--muted);">${v.category} · ⭐ ${v.rating}</div>
                                        </div>
                                    </label>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>

                    <!-- Description -->
                    <div class="form-group">
                        <label class="form-label" for="weddingDesc">Wedding Description</label>
                        <p style="font-size:12px;color:var(--muted);margin-bottom:8px;">Shared with selected vendors to help them prepare for your special day.</p>
                        <textarea name="weddingDescription" id="weddingDesc" class="form-control"
                                  placeholder="e.g. Outdoor evening ceremony, traditional Kandyan theme, 200 guests, white and gold colour palette..."
                                  rows="4" maxlength="1000"></textarea>
                        <div class="error-message" id="errWeddingDesc"></div>
                    </div>

                    <div style="margin-top:24px;">
                        <button type="submit" class="btn btn-primary btn-full" style="height:52px;font-size:16px;" id="confirmBookingBtn">
                            🌸 Confirm Booking Request
                        </button>
                        <p style="font-size:12px;color:var(--muted);text-align:center;margin-top:12px;">
                            This submits a booking request. You'll be notified once confirmed.
                        </p>
                    </div>
                </form>
            </div>
        </div>

        <!-- Sidebar Info -->
        <div>
            <div class="card-panel reveal" style="border-top:3px solid var(--gold);">
                <h3>📋 What Happens Next?</h3>
                <div style="display:flex;flex-direction:column;gap:16px;">
                    <div style="display:flex;gap:14px;">
                        <div style="width:32px;height:32px;border-radius:50%;background:var(--maroon);color:white;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;flex-shrink:0;">1</div>
                        <div>
                            <div style="font-weight:600;font-size:14px;margin-bottom:3px;">Request Submitted</div>
                            <div style="font-size:13px;color:var(--muted);">Your booking request is sent to the venue manager.</div>
                        </div>
                    </div>
                    <div style="display:flex;gap:14px;">
                        <div style="width:32px;height:32px;border-radius:50%;background:var(--maroon);color:white;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;flex-shrink:0;">2</div>
                        <div>
                            <div style="font-weight:600;font-size:14px;margin-bottom:3px;">Manager Review</div>
                            <div style="font-size:13px;color:var(--muted);">The venue manager reviews and confirms your booking.</div>
                        </div>
                    </div>
                    <div style="display:flex;gap:14px;">
                        <div style="width:32px;height:32px;border-radius:50%;background:var(--maroon);color:white;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;flex-shrink:0;">3</div>
                        <div>
                            <div style="font-weight:600;font-size:14px;margin-bottom:3px;">Vendor Confirmation</div>
                            <div style="font-size:13px;color:var(--muted);">Selected vendors accept or decline your request.</div>
                        </div>
                    </div>
                    <div style="display:flex;gap:14px;">
                        <div style="width:32px;height:32px;border-radius:50%;background:var(--gold);color:white;display:flex;align-items:center;justify-content:center;font-size:13px;font-weight:700;flex-shrink:0;">✦</div>
                        <div>
                            <div style="font-weight:600;font-size:14px;margin-bottom:3px;">Plan Your Day!</div>
                            <div style="font-size:13px;color:var(--muted);">Access your full booking dashboard to plan every detail.</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Price Summary -->
            <div class="card-panel reveal" style="margin-top:0;border-left:4px solid var(--gold);">
                <h3>💳 Estimated Cost</h3>
                <div style="display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border-color);">
                    <span style="font-size:14px;color:var(--muted);">Venue Fee</span>
                    <span style="font-weight:600;">Rs. ${hall.pricePerEvent}</span>
                </div>
                <div style="display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border-color);">
                    <span style="font-size:14px;color:var(--muted);">Package (TBD)</span>
                    <span style="font-size:13px;color:var(--muted);">Select after booking</span>
                </div>
                <div style="display:flex;justify-content:space-between;align-items:center;padding:14px 0 0;margin-top:4px;">
                    <span style="font-weight:700;font-size:15px;">Venue Total</span>
                    <span style="font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:700;color:var(--maroon);">Rs. ${hall.pricePerEvent}</span>
                </div>
            </div>
        </div>
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

    const form = document.getElementById("bookingMainForm");
    const submitBtn = document.getElementById("confirmBookingBtn");
    const errorAlert = document.getElementById("bookingGlobalError");
    
    form.addEventListener("submit", function(e) {
        e.preventDefault(); 
        let isValid = true;
        let errorMessages = [];

        // Validate hidden date and guest count from URL/session
        const dateVal = document.getElementById("hiddenEventDate").value;
        const guestsVal = document.getElementById("hiddenGuestCount").value;

        if (!dateVal) {
            isValid = false;
            errorMessages.push("Event date is missing. Please go back and search again.");
        } else {
            const selectedDate = new Date(dateVal);
            selectedDate.setHours(0,0,0,0);
            const today = new Date();
            today.setHours(0,0,0,0);
            const maxDate = new Date(today);
            maxDate.setFullYear(maxDate.getFullYear() + 2);

            if (selectedDate < today) {
                isValid = false;
                errorMessages.push("Event date cannot be in the past. Please select a valid date.");
            } else if (selectedDate > maxDate) {
                isValid = false;
                errorMessages.push("Event date cannot be more than 2 years in the future.");
            }
        }

        if (!guestsVal) {
            isValid = false;
            errorMessages.push("Guest count is missing. Please go back and search again.");
        } else {
            const guestCountNum = Number(guestsVal);
            if (!Number.isInteger(guestCountNum) || guestCountNum <= 0) {
                isValid = false;
                errorMessages.push("Guest count must be a positive whole number.");
            } else if (guestCountNum > 100000) {
                isValid = false;
                errorMessages.push("Guest count is too large. Please go back and revise.");
            }
        }

        // Trim description
        const descField = document.getElementById("weddingDesc");
        if (descField) {
            descField.value = descField.value.trim();
        }

        if (isValid) {
            errorAlert.style.display = 'none';
            submitBtn.disabled = true;
            submitBtn.innerHTML = 'Confirming Booking... <span style="font-size:12px;opacity:0.7;">⏳</span>';
            form.submit();
        } else {
            errorAlert.innerHTML = errorMessages.join("<br>");
            errorAlert.style.display = 'block';
        }
    });
});
</script>
</body>
</html>
