<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking #${booking.id} — WEDNEST</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>

<div class="container" style="padding-top:40px;padding-bottom:60px;position:relative;z-index:1;">

    <!-- Breadcrumb -->
    <div style="font-size:13px;color:var(--muted);margin-bottom:24px;">
        <a href="${pageContext.request.contextPath}/couple/dashboard" style="color:var(--muted);text-decoration:none;">Dashboard</a>
        <span style="margin:0 8px;color:var(--gold);">›</span>
        <span style="color:var(--maroon);">Booking #${booking.id}</span>
    </div>

    <!-- Page Header -->
    <div class="page-header" style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:16px;">
        <div>
            <div style="font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gold);margin-bottom:8px;">Booking Reference</div>
            <h1 class="page-title" style="margin:0 0 8px;">
                ${booking.hallName}
            </h1>
            <div style="display:flex;align-items:center;gap:14px;flex-wrap:wrap;">
                <span style="font-size:14px;color:var(--muted);">📅 ${booking.eventDate}</span>
                <span style="font-size:14px;color:var(--muted);">👥 ${booking.expectedGuestCount} guests</span>
                <span class="badge badge-${booking.status.toLowerCase().replace('_approval','')}" style="font-size:12px;">${booking.status}</span>
            </div>
        </div>
        <div style="text-align:right;">
            <div style="font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:1px;color:var(--muted);margin-bottom:4px;">Booking ID</div>
            <div class="guest-code">#${booking.id}</div>
        </div>
    </div>

    <!-- Progress Steps -->
    <div class="card-panel reveal" style="margin-bottom:32px;">
        <div style="display:flex;align-items:center;justify-content:center;gap:0;overflow-x:auto;padding:8px 0;">
            <div style="display:flex;align-items:center;gap:0;min-width:max-content;">
                <!-- Step 1 -->
                <div style="text-align:center;flex:1;min-width:100px;">
                    <div style="width:36px;height:36px;border-radius:50%;background:var(--maroon);color:white;display:flex;align-items:center;justify-content:center;font-weight:700;margin:0 auto 8px;font-size:14px;">✓</div>
                    <div style="font-size:12px;font-weight:600;color:var(--maroon);">Requested</div>
                </div>
                <div style="width:60px;height:2px;background:linear-gradient(90deg,var(--maroon),var(--gold));flex-shrink:0;"></div>

                <!-- Step 2 -->
                <div style="text-align:center;flex:1;min-width:100px;">
                    <div style="width:36px;height:36px;border-radius:50%;background:${booking.status == 'CONFIRMED' || booking.status == 'PENDING_APPROVAL' ? 'var(--maroon)' : 'var(--silver-light)'};color:${booking.status == 'CONFIRMED' || booking.status == 'PENDING_APPROVAL' ? 'white' : 'var(--muted)'};display:flex;align-items:center;justify-content:center;font-weight:700;margin:0 auto 8px;font-size:14px;">2</div>
                    <div style="font-size:12px;font-weight:600;color:var(--muted);">Under Review</div>
                </div>
                <div style="width:60px;height:2px;background:var(--silver-light);flex-shrink:0;"></div>

                <!-- Step 3 -->
                <div style="text-align:center;flex:1;min-width:100px;">
                    <div style="width:36px;height:36px;border-radius:50%;background:var(--silver-light);color:var(--muted);display:flex;align-items:center;justify-content:center;font-weight:700;margin:0 auto 8px;font-size:14px;">3</div>
                    <div style="font-size:12px;font-weight:600;color:var(--muted);">Confirmed</div>
                </div>
                <div style="width:60px;height:2px;background:var(--silver-light);flex-shrink:0;"></div>

                <!-- Step 4 -->
                <div style="text-align:center;flex:1;min-width:100px;">
                    <div style="width:36px;height:36px;border-radius:50%;background:var(--silver-light);color:var(--muted);display:flex;align-items:center;justify-content:center;font-size:18px;margin:0 auto 8px;">💍</div>
                    <div style="font-size:12px;font-weight:600;color:var(--muted);">Your Day!</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Action Grid -->
    <div class="grid grid-2">

        <!-- Package Card -->
        <div class="card-panel reveal" style="border-top:3px solid var(--maroon);" id="bookingPackage">
            <h3>🎀 Wedding Package</h3>
            <c:choose>
                <c:when test="${empty pkg}">
                    <div class="empty-state" style="padding:32px 0;">
                        <div class="empty-icon" style="font-size:32px;">📦</div>
                        <p style="margin-bottom:16px;">You haven't customized your package yet.</p>
                        <a href="${pageContext.request.contextPath}/couple/package/${booking.id}" class="btn btn-primary btn-sm" id="customizePackageBtn">
                            Customize Package
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display:flex;justify-content:space-between;align-items:center;padding:12px 0;border-bottom:1px solid var(--border-color);">
                        <span style="color:var(--muted);font-size:14px;">Tier</span>
                        <span style="font-weight:700;color:var(--maroon);">${pkg.tier}</span>
                    </div>
                    <div style="display:flex;justify-content:space-between;align-items:center;padding:12px 0;">
                        <span style="color:var(--muted);font-size:14px;">Total Cost</span>
                        <span style="font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:700;color:var(--maroon);">Rs. ${pkg.totalCost}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/couple/package/${booking.id}" class="btn btn-secondary btn-sm" id="editPackageBtn">Edit Package</a>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Payment Card -->
        <div class="card-panel reveal" style="border-top:3px solid var(--gold);" id="bookingPayment">
            <h3>💳 Payment & Billing</h3>
            <c:choose>
                <c:when test="${empty invoice}">
                    <div class="empty-state" style="padding:32px 0;">
                        <div class="empty-icon" style="font-size:32px;">🧾</div>
                        <p>Invoice will appear once your booking is confirmed.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border-color);">
                        <span style="color:var(--muted);font-size:14px;">Total Amount</span>
                        <span style="font-weight:600;">Rs. ${invoice.totalAmount}</span>
                    </div>
                    <div style="display:flex;justify-content:space-between;align-items:center;padding:10px 0;border-bottom:1px solid var(--border-color);">
                        <span style="color:var(--muted);font-size:14px;">Paid</span>
                        <span style="font-weight:600;color:var(--success);">Rs. ${invoice.paidAmount}</span>
                    </div>
                    <div style="display:flex;justify-content:space-between;align-items:center;padding:10px 0;">
                        <span style="color:var(--dark-text);font-weight:700;">Balance Due</span>
                        <span style="font-family:'Cormorant Garamond',serif;font-size:22px;font-weight:700;color:var(--maroon);">Rs. ${invoice.balance}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/couple/payment/${booking.id}" class="btn btn-primary btn-sm" id="viewInvoiceBtn">View Invoice & Pay</a>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Guests Card -->
        <div class="card-panel reveal" id="bookingGuests">
            <h3>👥 Guest List & RSVP</h3>
            <p style="font-size:14px;color:var(--muted);margin-bottom:20px;line-height:1.6;">
                Manage your guest list, send invitations and track live RSVP responses.
            </p>
            <a href="${pageContext.request.contextPath}/couple/guests/${booking.id}" class="btn btn-secondary btn-sm" id="manageGuestsBtn">Manage Guest List</a>
        </div>

        <!-- Timeline Card -->
        <div class="card-panel reveal" id="bookingTimeline">
            <h3>📅 Event Timeline</h3>
            <p style="font-size:14px;color:var(--muted);margin-bottom:20px;line-height:1.6;">
                View your wedding day schedule once your coordinator publishes it.
            </p>
            <a href="${pageContext.request.contextPath}/couple/timeline/${booking.id}" class="btn btn-secondary btn-sm" id="viewTimelineBtn">View Timeline</a>
        </div>
    </div>

    <!-- Requested Vendors Status -->
    <c:if test="${not empty vendorRequests}">
        <div class="card-panel reveal" id="bookingVendors" style="border-top:3px solid var(--gold); margin-top:8px;">
            <h3>🤝 Requested Vendors</h3>
            <div style="overflow-x:auto;">
                <table id="vendorRequestsTable">
                    <thead>
                    <tr>
                        <th>Company</th>
                        <th>Event Date</th>
                        <th>Description</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="vr" items="${vendorRequests}">
                        <tr>
                            <td style="font-weight:600;">${vr.companyName}</td>
                            <td>📅 ${vr.eventDate}</td>
                            <td style="font-size:13px;color:var(--muted);">${vr.eventDescription}</td>
                            <td><span class="badge badge-${vr.status.toLowerCase()}">${vr.status}</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <!-- Cancel Booking -->
    <div class="card-panel reveal" style="border-left:4px solid var(--danger);margin-top:8px;" id="bookingCancel">
        <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:16px;">
            <div>
                <h3 style="margin:0 0 4px;font-size:18px;color:var(--danger);">⚠️ Cancel Booking</h3>
                <p style="font-size:14px;color:var(--muted);margin:0;">This action cannot be undone. A refund, if applicable, will follow our cancellation policy.</p>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/couple/payment/${booking.id}/cancel"
                  onsubmit="return confirm('Are you sure you want to cancel this booking? This action cannot be undone.');">
                <button type="submit" class="btn btn-danger btn-sm" id="cancelBookingBtn">Cancel This Booking</button>
            </form>
        </div>
    </div>
</div>

<script>
    document.querySelectorAll('.reveal').forEach((el, i) => {
        el.style.transitionDelay = (i * 0.08) + 's';
        const obs = new IntersectionObserver(entries => {
            entries.forEach(e => { if(e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); } });
        }, { threshold: 0.1 });
        obs.observe(el);
    });
</script>
</body>
</html>
