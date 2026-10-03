<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Finance Dashboard — WEDNEST</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>
<div class="container" style="padding-top:40px;padding-bottom:60px;position:relative;z-index:1;">
    <div class="page-header">
        <div style="font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gold);margin-bottom:8px;">Finance</div>
        <h1 class="page-title">Finance &amp; Billing Manager</h1>
        <p class="page-subtitle">Monitor all invoices and process cancellation refunds.</p>
    </div>

    <!-- Outstanding Invoices -->
    <div class="card-panel reveal" style="border-top:3px solid var(--danger); margin-bottom:24px;">
        <h3>⚠️ Unpaid / Partial Invoices</h3>
        <c:choose>
            <c:when test="${empty overdue}">
                <div class="empty-state">Everything is settled &mdash; no outstanding balances.</div>
            </c:when>
            <c:otherwise>
                <div style="overflow-x:auto;">
                    <table id="overdueTable">
                        <thead><tr><th>Invoice</th><th>Booking</th><th>Total</th><th>Paid</th><th>Balance</th><th>Status</th><th>Actions</th></tr></thead>
                        <tbody>
                        <c:forEach var="inv" items="${overdue}">
                            <tr>
                                <td>#${inv.id}</td>
                                <td>#${inv.bookingId}</td>
                                <td>Rs. ${inv.totalAmount}</td>
                                <td style="color:var(--success);font-weight:600;">Rs. ${inv.paidAmount}</td>
                                <td style="color:var(--danger);font-weight:600;">Rs. ${inv.balance}</td>
                                <td><span class="badge badge-${inv.status.toLowerCase()}">${inv.status}</span></td>
                                <td><a class="btn btn-sm btn-secondary" href="${pageContext.request.contextPath}/finance/refund/${inv.bookingId}">Refund</a></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- All Invoices (including PAID) -->
    <div class="card-panel reveal" style="border-top:3px solid var(--gold);">
        <h3>📋 All Invoices</h3>
        <c:choose>
            <c:when test="${empty allInvoices}">
                <div class="empty-state">No invoices yet.</div>
            </c:when>
            <c:otherwise>
                <div style="overflow-x:auto;">
                    <table id="allInvoicesTable">
                        <thead><tr><th>Invoice</th><th>Booking</th><th>Total</th><th>Paid</th><th>Balance</th><th>Status</th><th>Actions</th></tr></thead>
                        <tbody>
                        <c:forEach var="inv" items="${allInvoices}">
                            <tr>
                                <td>#${inv.id}</td>
                                <td>#${inv.bookingId}</td>
                                <td>Rs. ${inv.totalAmount}</td>
                                <td style="color:var(--success);font-weight:600;">Rs. ${inv.paidAmount}</td>
                                <td>Rs. ${inv.balance}</td>
                                <td><span class="badge badge-${inv.status.toLowerCase()}">${inv.status}</span></td>
                                <td>
                                    <a class="btn btn-sm btn-secondary" href="${pageContext.request.contextPath}/finance/invoice/${inv.id}">View Payments</a>
                                    <c:if test="${inv.paidAmount > 0}">
                                        <a class="btn btn-sm btn-danger" href="${pageContext.request.contextPath}/finance/refund/${inv.bookingId}" style="margin-left:6px;">Refund</a>
                                    </c:if>
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
</body>
</html>
