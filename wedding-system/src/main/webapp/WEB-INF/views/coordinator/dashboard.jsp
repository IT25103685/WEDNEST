<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Coordinator Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>
<div class="container">
    <div class="page-title">Senior Wedding Coordinator</div>
    <div class="page-subtitle">All confirmed weddings. Build and publish each one's day-of timeline.</div>

    <div class="card">
        <c:choose>
            <c:when test="${empty bookings}">
                <div class="empty-state">No confirmed weddings yet.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <tr><th>Couple</th><th>Hall</th><th>Date</th><th>Guests</th><th></th></tr>
                    <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td>${b.coupleName}</td>
                            <td>${b.hallName}</td>
                            <td>${b.eventDate}</td>
                            <td>${b.expectedGuestCount}</td>
                            <td><a class="btn btn-sm" href="${pageContext.request.contextPath}/coordinator/timeline/${b.id}">Build Timeline</a></td>
                        </tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
