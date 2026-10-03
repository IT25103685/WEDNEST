<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Process Refund</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>
<div class="container">
    <div class="page-title">Cancellation &amp; Refund &mdash; Booking #${booking.id}</div>
    <div class="page-subtitle">Wedding date: ${booking.eventDate} &middot; Status: ${booking.status}</div>

    <div class="card">
        <p>Amount already paid: <strong>Rs. ${invoice.paidAmount}</strong></p>
        <p>Refund policy: 90% if cancelled 30+ days before the date, 50% if 7&ndash;29 days before, 0% if under 7 days.</p>
        <p>Suggested refund based on policy: <strong>Rs. ${suggestedRefund}</strong></p>

        <form method="post" action="${pageContext.request.contextPath}/finance/refund/${invoice.id}/process">
            <input type="hidden" name="bookingId" value="${booking.id}">
            <label>Refund Amount to Process (Rs.)</label>
            <input type="number" step="0.01" name="amount" value="${suggestedRefund}" required>
            <button type="submit" class="btn btn-danger">Process Refund</button>
        </form>
        <p class="page-subtitle" style="margin-top:10px;">This action is recorded as an audit entry (Payment method = REFUND) against the invoice.</p>
    </div>
</div>
</body>
</html>
