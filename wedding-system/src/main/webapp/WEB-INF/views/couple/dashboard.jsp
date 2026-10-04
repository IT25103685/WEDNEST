<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Dashboard — WEDNEST</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>

<div class="container" style="padding-top: 40px; padding-bottom: 60px; position:relative;z-index:1;">

    <!-- Page Header -->
    <div class="page-header" style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:16px;">
        <div>
            <div style="font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gold);margin-bottom:8px;">Welcome back</div>
            <h1 class="page-title" style="margin:0 0 6px;">Your Wedding Plans</h1>
            <p class="page-subtitle" style="margin:0;">Track your bookings, explore venues and manage every detail of your special day.</p>
        </div>
        <a href="${pageContext.request.contextPath}/couple/search-venues" class="btn btn-primary" style="flex-shrink:0;" id="dashboardSearchBtn">
            + Book a New Venue
        </a>
    </div>

    <!-- Notifications -->
    <c:if test="${not empty notifications}">
        <div class="card-panel reveal" style="border-left:4px solid var(--gold);">
            <h3 style="border:none;padding:0;margin-bottom:16px;font-size:18px;">🔔 Notifications</h3>
            <c:forEach var="n" items="${notifications}">
                <div style="padding:10px 0;border-bottom:1px solid rgba(212,175,55,0.1);font-size:14px;color:var(--dark-text);">
                    <span style="color:var(--gold);margin-right:8px;">✦</span> ${n.message}
                </div>
            </c:forEach>
        </div>
    </c:if>

    <!-- Stats Row -->
    <div class="grid grid-4 reveal" style="margin-bottom:36px;">
        <div class="stat-box" id="statBookings">
            <div class="stat-icon">📋</div>
            <div class="stat-num">
                <c:choose>
                    <c:when test="${not empty bookings}">${bookings.size()}</c:when>
                    <c:otherwise>0</c:otherwise>
                </c:choose>
            </div>
            <div class="stat-label">Total Bookings</div>
        </div>
        <div class="stat-box" id="statConfirmed">
            <div class="stat-icon">✅</div>
            <div class="stat-num">0</div>
            <div class="stat-label">Confirmed</div>
        </div>
        <div class="stat-box" id="statPending">
            <div class="stat-icon">⏳</div>
            <div class="stat-num">0</div>
            <div class="stat-label">Pending Review</div>
        </div>
        <div class="stat-box" id="statDaysLeft">
            <div class="stat-icon">💍</div>
            <div class="stat-num">—</div>
            <div class="stat-label">Days to Wedding</div>
        </div>
    </div>

    <!-- Bookings Table -->
    <div class="card-panel reveal" id="dashboardBookings">
        <div style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;margin-bottom:20px;padding-bottom:16px;border-bottom:1px solid var(--border-color);">
            <h3 style="margin:0;border:none;padding:0;">My Bookings</h3>
            <a href="${pageContext.request.contextPath}/couple/search-venues" class="btn btn-secondary btn-sm" id="dashNewBookingBtn">+ New Booking</a>
        </div>

        <c:choose>
            <c:when test="${empty bookings}">
                <div class="empty-state">
                    <div class="empty-icon">🏛️</div>
                    <h3>No bookings yet</h3>
                    <p>Start by searching for your perfect wedding venue.</p>
                    <a href="${pageContext.request.contextPath}/couple/search-venues" class="btn btn-primary" style="margin-top:20px;" id="dashEmptySearchBtn">Find a Venue</a>
                </div>
            </c:when>
            <c:otherwise>
                <div style="overflow-x:auto;">
                    <table id="dashboardTable">
                        <thead>
                        <tr>
                            <th>Venue</th>
                            <th>Wedding Date</th>
                            <th>Guests</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td>
                                    <div style="font-weight:600;color:var(--maroon);">${b.hallName}</div>
                                </td>
                                <td>
                                    <div style="display:flex;align-items:center;gap:6px;">
                                        <span style="color:var(--gold);">📅</span>
                                        ${b.eventDate}
                                    </div>
                                </td>
                                <td>
                                    <div style="display:flex;align-items:center;gap:6px;">
                                        <span>👥</span> ${b.expectedGuestCount}
                                    </div>
                                </td>
                                <td>
                                    <span class="badge badge-${b.status.toLowerCase().replace('_approval','')}">
                                        ${b.status}
                                    </span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/couple/bookings/${b.id}" class="btn btn-primary btn-sm">Manage</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Quick Links -->
    <div class="grid grid-3 reveal" style="margin-top:8px;">
        <a href="${pageContext.request.contextPath}/couple/search-venues" class="card" style="text-decoration:none;display:block;text-align:center;padding:28px 20px;" id="quickLinkVenues">
            <div style="font-size:36px;margin-bottom:12px;">🔍</div>
            <h4 style="color:var(--maroon);margin-bottom:6px;">Search Venues</h4>
            <p style="font-size:13px;color:var(--muted);margin:0;">Find available halls for your date</p>
        </a>
        <a href="${pageContext.request.contextPath}/couple/bookings" class="card" style="text-decoration:none;display:block;text-align:center;padding:28px 20px;" id="quickLinkTimeline">
            <div style="font-size:36px;margin-bottom:12px;">📋</div>
            <h4 style="color:var(--maroon);margin-bottom:6px;">My Bookings</h4>
            <p style="font-size:13px;color:var(--muted);margin:0;">View and manage your reservations</p>
        </a>
        <a href="${pageContext.request.contextPath}/couple/timeline" class="card" style="text-decoration:none;display:block;text-align:center;padding:28px 20px;" id="quickLinkGuests">
            <div style="font-size:36px;margin-bottom:12px;">💍</div>
            <h4 style="color:var(--maroon);margin-bottom:6px;">Wedding Timeline</h4>
            <p style="font-size:13px;color:var(--muted);margin:0;">Track your planning milestones</p>
        </a>
    </div>
</div>

<script>
    // Scroll reveal
    document.querySelectorAll('.reveal').forEach((el, i) => {
        el.style.transitionDelay = (i * 0.06) + 's';
        const obs = new IntersectionObserver(entries => {
            entries.forEach(e => { if(e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); } });
        }, { threshold: 0.1 });
        obs.observe(el);
    });
</script>
</body>
</html>
