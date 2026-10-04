<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Venues — WEDNEST</title>
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
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>

<div class="container" style="padding-top:40px;padding-bottom:60px;position:relative;z-index:1;">

    <!-- Page Header -->
    <div class="page-header">
        <div style="font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gold);margin-bottom:8px;">Venue Discovery</div>
        <h1 class="page-title">Search Wedding Venues</h1>
        <p class="page-subtitle">Check real-time availability by date and expected guest count across Sri Lanka.</p>
    </div>

    <!-- Search Card -->
    <div class="card-panel reveal" style="border-top:3px solid var(--gold);" id="venueSearchFormCard">
        <h3 style="margin-bottom:20px;">🔍 Find Available Venues</h3>
        <form method="post" action="${pageContext.request.contextPath}/couple/search-venues" id="searchVenuesForm" novalidate>
            <div class="grid grid-2" style="gap:20px;">
                <div class="form-group" style="margin:0;">
                    <label class="form-label required" for="searchDate">💍 Wedding Date</label>
                    <input type="date" name="eventDate" id="searchDate" class="form-control" value="${eventDate}">
                    <div class="error-message" id="errSearchDate"></div>
                </div>
                <div class="form-group" style="margin:0;">
                    <label class="form-label required" for="searchGuests">👥 Expected Guest Count</label>
                    <input type="number" name="guestCount" id="searchGuests" value="${guestCount}" placeholder="e.g. 250" class="form-control">
                    <div class="error-message" id="errSearchGuests"></div>
                </div>
            </div>
            <div style="margin-top:24px;display:flex;gap:14px;align-items:center;">
                <button type="submit" class="btn btn-primary" style="height:48px;padding:0 36px;" id="searchAvailBtn">
                    Search Availability
                </button>
                <span style="font-size:13px;color:var(--muted);">Results update in real-time</span>
            </div>
        </form>
    </div>

    <!-- Results -->
    <c:if test="${not empty halls}">
        <div style="margin-top:36px;">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;" class="reveal">
                <div>
                    <h2 style="font-size:26px;margin-bottom:4px;">Available Venues</h2>
                    <p style="font-size:14px;color:var(--muted);margin:0;">
                        <c:choose>
                            <c:when test="${not empty eventDate}">Showing results for <strong style="color:var(--maroon);">${eventDate}</strong></c:when>
                            <c:otherwise>All available venues</c:otherwise>
                        </c:choose>
                        <c:if test="${not empty guestCount}"> · <strong style="color:var(--maroon);">${guestCount} guests</strong></c:if>
                    </p>
                </div>
                <span class="badge badge-available" style="font-size:13px;padding:8px 16px;">
                    <c:out value="${halls.size()}"/> venues found
                </span>
            </div>

            <div class="grid grid-3">
                <c:forEach var="h" items="${halls}" varStatus="loop">
                    <div class="venue-card reveal delay-${loop.index % 3 + 1}" id="venueResult${loop.index}">
                        <div class="venue-img">
                            <!-- Placeholder image cycling through a few Unsplash wedding venue images -->
                            <c:choose>
                                <c:when test="${loop.index % 4 == 0}">
                                    <img src="https://images.unsplash.com/photo-1519741497674-611481863552?w=600&auto=format&fit=crop&q=80" alt="${h.name}" loading="lazy">
                                </c:when>
                                <c:when test="${loop.index % 4 == 1}">
                                    <img src="https://images.unsplash.com/photo-1464366400600-7168b8af9bc3?w=600&auto=format&fit=crop&q=80" alt="${h.name}" loading="lazy">
                                </c:when>
                                <c:when test="${loop.index % 4 == 2}">
                                    <img src="https://images.unsplash.com/photo-1515934751635-c81c6bc9a2d8?w=600&auto=format&fit=crop&q=80" alt="${h.name}" loading="lazy">
                                </c:when>
                                <c:otherwise>
                                    <img src="https://images.unsplash.com/photo-1478146896981-b80fe463b330?w=600&auto=format&fit=crop&q=80" alt="${h.name}" loading="lazy">
                                </c:otherwise>
                            </c:choose>
                            <span class="badge badge-available" style="position:absolute;top:14px;right:14px;">✓ Available</span>
                        </div>
                        <div class="venue-info">
                            <h3 class="venue-name">${h.name}</h3>
                            <div class="venue-meta">
                                <span class="venue-meta-item">
                                    <span class="icon">📍</span>
                                    <c:out value="${h.location}"/>
                                </span>
                                <span class="venue-meta-item">
                                    <span class="icon">👥</span>
                                    Up to <c:out value="${h.capacityMax}"/> guests
                                </span>
                            </div>
                            <div class="venue-price">
                                Rs. <c:out value="${h.pricePerEvent}"/>
                                <span>/ event</span>
                            </div>
                            <div style="margin-top:16px;">
                                <a class="btn btn-primary book-btn"
                                   style="width:100%;justify-content:center;"
                                   href="${pageContext.request.contextPath}/couple/book/${h.id}?eventDate=${eventDate}&guestCount=${guestCount}"
                                   id="bookVenue${loop.index}Btn">
                                    Book This Venue
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- No results / initial state -->
    <c:if test="${empty halls and not empty eventDate}">
        <div class="empty-state reveal" style="margin-top:40px;">
            <div class="empty-icon">🏛️</div>
            <h3>No venues available</h3>
            <p>No halls available for that date and guest count.<br>Try a different date or adjust your guest count.</p>
        </div>
    </c:if>

    <c:if test="${empty eventDate}">
        <div class="reveal" style="margin-top:40px;text-align:center;padding:48px 0;">
            <div style="font-size:48px;margin-bottom:16px;opacity:0.4;">🔍</div>
            <p style="font-size:16px;color:var(--muted);">Enter your wedding date and guest count above to see available venues.</p>
        </div>
    </c:if>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const form = document.getElementById("searchVenuesForm");
    const submitBtn = document.getElementById("searchAvailBtn");
    
    const fields = {
        date: document.getElementById("searchDate"),
        guests: document.getElementById("searchGuests")
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

    if (form) {
        form.addEventListener("submit", function(e) {
            e.preventDefault(); 
            let isValid = true;

            clearError(fields.date, "errSearchDate");
            clearError(fields.guests, "errSearchGuests");

            const dateVal = fields.date.value;
            if (!dateVal) {
                showError(fields.date, "errSearchDate", "Wedding Date is required.");
                isValid = false;
            } else {
                const selectedDate = new Date(dateVal);
                // Set time to midnight to avoid timezone issues when comparing to today
                selectedDate.setHours(0,0,0,0);
                const today = new Date();
                today.setHours(0,0,0,0);
                
                const maxDate = new Date(today);
                maxDate.setFullYear(maxDate.getFullYear() + 2);

                if (selectedDate < today) {
                    showError(fields.date, "errSearchDate", "Event date cannot be in the past.");
                    isValid = false;
                } else if (selectedDate > maxDate) {
                    showError(fields.date, "errSearchDate", "Event date cannot be more than 2 years in the future.");
                    isValid = false;
                }
            }

            const guestsVal = fields.guests.value;
            if (!guestsVal) {
                showError(fields.guests, "errSearchGuests", "Guest Count is required.");
                isValid = false;
            } else {
                const guestCountNum = Number(guestsVal);
                if (!Number.isInteger(guestCountNum) || guestCountNum <= 0) {
                    showError(fields.guests, "errSearchGuests", "Guest count must be a positive whole number.");
                    isValid = false;
                } else if (guestCountNum > 100000) {
                    showError(fields.guests, "errSearchGuests", "Guest count cannot exceed 100,000.");
                    isValid = false;
                } else if (guestsVal.startsWith('0')) {
                     showError(fields.guests, "errSearchGuests", "Guest count cannot have leading zeros.");
                     isValid = false;
                }
            }

            if (isValid) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = 'Searching... <span style="font-size:12px;opacity:0.7;">⏳</span>';
                form.submit();
            }
        });

        fields.date.addEventListener('input', () => clearError(fields.date, "errSearchDate"));
        fields.guests.addEventListener('input', () => clearError(fields.guests, "errSearchGuests"));
    }

    // Prevent double clicking on "Book This Venue" buttons
    const bookBtns = document.querySelectorAll('.book-btn');
    bookBtns.forEach(btn => {
        btn.addEventListener('click', function(e) {
            if (this.classList.contains('disabled')) {
                e.preventDefault();
                return;
            }
            this.classList.add('disabled');
            this.style.pointerEvents = 'none';
            this.style.opacity = '0.7';
            this.innerHTML = 'Processing...';
        });
    });

    // Reveal animations
    document.querySelectorAll('.reveal').forEach((el, i) => {
        el.style.transitionDelay = (i * 0.06) + 's';
        const obs = new IntersectionObserver(entries => {
            entries.forEach(e => { if(e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); } });
        }, { threshold: 0.1 });
        obs.observe(el);
    });
});
</script>
</body>
</html>
