<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Invoice Detail</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>
<div class="container">
    <div class="page-title">Payment History</div>
    <div class="card">
        <c:choose>
            <c:when test="${empty payments}">
                <div class="empty-state">No payments recorded.</div>
            </c:when>
            <c:otherwise>
                <table>
                    <tr><th>Date</th><th>Amount</th><th>Method</th></tr>
                    <c:forEach var="p" items="${payments}">
                        <tr><td>${p.paymentDate}</td><td>Rs. ${p.amount}</td><td>${p.method}</td></tr>
                    </c:forEach>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
    <a href="${pageContext.request.contextPath}/finance/dashboard" class="btn btn-secondary">Back</a>
</div>
</body>
</html>
