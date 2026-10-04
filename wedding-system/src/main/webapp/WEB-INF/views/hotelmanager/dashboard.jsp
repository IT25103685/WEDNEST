<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Hotel Operations Manager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>
<div class="container">
    <div class="page-title">Hotel Operations Manager</div>
    <div class="page-subtitle">Review booking requests and manage venue availability.</div>

    <c:if test="${not empty notifications}">
        <div class="card">
            <c:forEach var="n" items="${notifications}">
                <div style="padding:6px 0;">${n.message}</div>
            </c:forEach>
        </div>
    </c:if>

    <div class="card">
        <h3>Pending Approval</h3>
        <c:choose>
            <c:when test="${empty pending}">
                <div class="empty-state">No pending booking requests.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <tr><th>Couple</th><th>Hall</th><th>Date</th><th>Guests</th><th></th></tr>
                    <c:forEach var="b" items="${pending}">
                        <tr>
                            <td>${b.coupleName}</td>
                            <td>${b.hallName}</td>
                            <td>${b.eventDate}</td>
                            <td>${b.expectedGuestCount}</td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/hotel-manager/bookings/${b.id}/approve" style="display:inline;">
                                    <button type="submit" class="btn btn-sm btn-success">Approve</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/hotel-manager/bookings/${b.id}/reject" style="display:inline;">
                                    <button type="submit" class="btn btn-sm btn-danger">Reject</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="card">
        <h3>Confirmed Bookings</h3>
        <table>
            <tr><th>Couple</th><th>Hall</th><th>Date</th><th>Guests</th></tr>
            <c:forEach var="b" items="${confirmed}">
                <tr><td>${b.coupleName}</td><td>${b.hallName}</td><td>${b.eventDate}</td><td>${b.expectedGuestCount}</td></tr>
            </c:forEach>
        </table>
    </div>

    <div class="card">
        <h3>Wedding Halls</h3>
        <table>
            <tr><th>Name</th><th>Location</th><th>Capacity</th><th>Price</th><th>Active</th></tr>
            <c:forEach var="h" items="${halls}">
                <tr>
                    <td>${h.name}</td><td>${h.location}</td><td>${h.capacityMax}</td>
                    <td>Rs. ${h.pricePerEvent}</td><td>${h.active ? 'Yes' : 'No'}</td>
                </tr>
            </c:forEach>
        </table>
        <p class="page-subtitle" style="margin-top:12px;">Halls are created/removed from the Admin dashboard.</p>
    </div>
</div>
</body>
</html>
