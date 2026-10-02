<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="navbar" id="mainNav">
    <a href="${pageContext.request.contextPath}/" class="navbar-brand" style="text-decoration:none;">
        <div class="brand-icon">🪷</div>
        <span class="brand-text" style="font-family:'Cormorant Garamond',serif;font-size:24px;font-weight:700;color:var(--maroon);letter-spacing:2px;">
            WED<span style="color:var(--gold);">NEST</span>
        </span>
    </a>

    <div class="nav-right" style="display:flex;align-items:center;gap:20px;font-size:14px;">
        <c:choose>
            <c:when test="${sessionScope.role == 'COUPLE'}">
                <a href="${pageContext.request.contextPath}/couple/dashboard" style="color:var(--dark-text);text-decoration:none;padding:8px 14px;border-radius:8px;font-weight:500;transition:all 0.2s;">🏠 Dashboard</a>
                <a href="${pageContext.request.contextPath}/couple/search-venues" style="color:var(--dark-text);text-decoration:none;padding:8px 14px;border-radius:8px;font-weight:500;transition:all 0.2s;">🔍 Find Venues</a>
            </c:when>
            <c:when test="${sessionScope.role == 'VENDOR'}">
                <a href="${pageContext.request.contextPath}/vendor/dashboard" style="color:var(--dark-text);text-decoration:none;padding:8px 14px;border-radius:8px;font-weight:500;transition:all 0.2s;">🏠 Dashboard</a>
                <a href="${pageContext.request.contextPath}/vendor/tasks" style="color:var(--dark-text);text-decoration:none;padding:8px 14px;border-radius:8px;font-weight:500;transition:all 0.2s;">📋 My Tasks</a>
            </c:when>
            <c:when test="${sessionScope.role == 'ADMIN'}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" style="color:var(--dark-text);text-decoration:none;padding:8px 14px;border-radius:8px;font-weight:500;">Admin Panel</a>
            </c:when>
        </c:choose>

        <div style="display:flex;align-items:center;gap:10px;padding:6px 14px;background:rgba(107,30,46,0.05);border-radius:999px;border:1px solid var(--border-color);">
            <span style="font-size:18px;">👤</span>
            <span style="font-weight:600;color:var(--maroon);font-size:14px;">${sessionScope.fullName}</span>
            <span style="font-size:11px;color:var(--muted);background:var(--ivory);padding:2px 8px;border-radius:999px;text-transform:uppercase;letter-spacing:0.5px;font-weight:600;">${sessionScope.role}</span>
        </div>

        <a href="${pageContext.request.contextPath}/logout"
           style="color:var(--maroon);text-decoration:none;font-weight:600;font-size:13px;padding:8px 16px;border-radius:8px;border:1.5px solid rgba(107,30,46,0.25);transition:all 0.2s;"
           onmouseover="this.style.background='var(--maroon)';this.style.color='white';"
           onmouseout="this.style.background='transparent';this.style.color='var(--maroon)';"
           id="logoutBtn">
            Logout →
        </a>
    </div>
</nav>
