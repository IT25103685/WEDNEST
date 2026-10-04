<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Vendor Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>
<div class="container">
    <div class="page-title">Vendor Dashboard</div>

    <c:choose>
        <c:when test="${empty vendor}">
            <div class="card"><div class="empty-state">No vendor profile found for this account.</div></div>
        </c:when>
        <c:otherwise>
            <div class="card">
                <h3>${vendor.companyName}</h3>
                <p>Category: ${vendor.category} &nbsp;|&nbsp;
                   Status: <span class="badge badge-${vendor.status.toLowerCase()}">${vendor.status}</span>
                   &nbsp;|&nbsp; Rating: &#9733; ${vendor.rating}</p>
                <c:if test="${vendor.status == 'PENDING'}">
                    <p style="color:#c98a2c;">Waiting for Vendor Relations Manager approval before you can receive requests.</p>
                </c:if>
            </div>

            <div class="card">
                <h3>Wedding Requests</h3>
                <c:choose>
                    <c:when test="${empty requests}">
                        <div class="empty-state">No requests yet. Couples will see you in their vendor list once approved.</div>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <tr><th>Event Date</th><th>Description</th><th>Status</th><th></th></tr>
                            <c:forEach var="r" items="${requests}">
                                <tr>
                                    <td>${r.eventDate}</td>
                                    <td>${r.eventDescription}</td>
                                    <td><span class="badge badge-${r.status.toLowerCase()}">${r.status}</span></td>
                                    <td>
                                        <c:if test="${r.status == 'PENDING'}">
                                            <form method="post" action="${pageContext.request.contextPath}/vendor/requests/${r.id}/accept" style="display:inline;">
                                                <button type="submit" class="btn btn-sm btn-success">Accept</button>
                                            </form>
                                            <form method="post" action="${pageContext.request.contextPath}/vendor/requests/${r.id}/decline" style="display:inline;">
                                                <button type="submit" class="btn btn-sm btn-danger">Decline</button>
                                            </form>
                                        </c:if>
                                        <c:if test="${r.status == 'ACCEPTED'}">
                                            <form method="post" action="${pageContext.request.contextPath}/vendor/requests/${r.id}/cancel" style="display:inline;" onsubmit="return confirm('Are you sure you want to cancel this accepted task?');">
                                                <button type="submit" class="btn btn-sm btn-danger">Cancel</button>
                                            </form>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
