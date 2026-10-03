<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment & Billing — WEDNEST</title>
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

    <!-- Breadcrumb -->
    <div style="font-size:13px;color:var(--muted);margin-bottom:24px;">
        <a href="${pageContext.request.contextPath}/couple/dashboard" style="color:var(--muted);text-decoration:none;">Dashboard</a>
        <span style="margin:0 8px;color:var(--gold);">›</span>
        <a href="${pageContext.request.contextPath}/couple/bookings/${booking.id}" style="color:var(--muted);text-decoration:none;">Booking #${booking.id}</a>
        <span style="margin:0 8px;color:var(--gold);">›</span>
        <span style="color:var(--maroon);">Payment</span>
    </div>

    <div class="page-header">
        <div style="font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gold);margin-bottom:8px;">Billing</div>
        <h1 class="page-title">Payment & Billing</h1>
        <p class="page-subtitle">Booking #${booking.id} &middot; ${booking.hallName}</p>
    </div>

    <c:choose>
        <c:when test="${empty invoice}">
            <div class="card-panel reveal" style="text-align:center;padding:60px 40px;">
                <div style="font-size:48px;margin-bottom:16px;opacity:0.4;">🧾</div>
                <h3 style="margin-bottom:8px;">Invoice Not Yet Generated</h3>
                <p style="color:var(--muted);font-size:15px;line-height:1.6;max-width:400px;margin:0 auto;">
                    Your invoice will be generated once the Hotel Manager confirms your booking.
                </p>
                <a href="${pageContext.request.contextPath}/couple/bookings/${booking.id}" class="btn btn-secondary" style="margin-top:24px;" id="backToBookingBtn">
                    ← Back to Booking
                </a>
            </div>
        </c:when>
        <c:otherwise>

            <!-- Payment Stats -->
            <div style="display:grid;grid-template-columns:repeat(auto-fit, minmax(200px, 1fr));gap:24px;margin-bottom:32px;">
                <div class="stat-box reveal" id="payStatTotal">
                    <div class="stat-icon">💳</div>
                    <div class="stat-num" style="font-size:28px;">Rs. ${invoice.totalAmount}</div>
                    <div class="stat-label">Total Amount</div>
                </div>
                <div class="stat-box reveal" id="payStatPaid">
                    <div class="stat-icon">✅</div>
                    <div class="stat-num" style="font-size:28px;color:var(--success);">Rs. ${invoice.paidAmount}</div>
                    <div class="stat-label">Amount Paid</div>
                </div>
                <div class="stat-box reveal" id="payStatBalance">
                    <div class="stat-icon">⏳</div>
                    <div class="stat-num" style="font-size:28px;">Rs. ${invoice.balance}</div>
                    <div class="stat-label">Amount to Pay</div>
                </div>
                <div class="stat-box reveal" id="payStatStatus">
                    <div class="stat-icon">${invoice.status == 'PAID' ? '✅' : '❌'}</div>
                    <div class="stat-num" style="font-size:24px;color:${invoice.status == 'PAID' ? 'var(--success)' : 'var(--danger)'};">
                        ${invoice.status == 'PAID' ? 'Payed' : 'Not Payed'}
                    </div>
                    <div class="stat-label">Status</div>
                </div>
            </div>

            <div class="grid grid-2" style="align-items:start;">

                <!-- Payment Form -->
                <div class="card-panel reveal" style="border-top:3px solid var(--gold);" id="paymentFormCard">
                    <h3>💳 Make a Payment</h3>
                    <c:choose>
                        <c:when test="${invoice.status == 'PAID'}">
                            <div style="text-align:center;padding:32px 0;">
                                <div style="font-size:56px;margin-bottom:12px;">✅</div>
                                <h3 style="color:var(--success);margin-bottom:8px;">Payment Complete!</h3>
                                <p style="color:var(--muted);font-size:15px;">Your invoice has been fully paid.</p>
                            </div>
                        </c:when>
                        <c:when test="${invoice.balance <= 0}">
                            <div style="text-align:center;padding:32px 0;">
                                <div style="font-size:56px;margin-bottom:12px;">✅</div>
                                <h3 style="color:var(--success);margin-bottom:8px;">No Payment Required</h3>
                                <p style="color:var(--muted);font-size:15px;">There is no outstanding balance on this invoice.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            
                            <form id="payForm" method="post" action="${pageContext.request.contextPath}/couple/payment/${booking.id}/pay" novalidate>
                                
                                <div class="form-group">
                                    <label class="form-label required" for="payMethod">Payment Method</label>
                                    <select name="method" id="payMethod" class="form-control">
                                        <option value="">-- Select Payment Method --</option>
                                        <option value="CARD">Credit/Debit Card</option>
                                        <option value="BANK_TRANSFER">Bank Transfer (Offline)</option>
                                    </select>
                                    <div class="error-message" id="errMethod"></div>
                                </div>

                                <div id="cardSection" style="display:none; background:var(--ivory); padding:20px; border-radius:var(--radius-sm); border:1px solid var(--border-color); margin-bottom:24px;">
                                    
                                    <!-- Card Visual -->
                                    <div id="cardVisual" style="background:linear-gradient(135deg,#6b1a28,#c8982a);border-radius:16px;padding:24px 28px;color:white;margin-bottom:24px;position:relative;overflow:hidden;min-height:160px;box-shadow:0 8px 32px rgba(107,26,40,0.35);">
                                        <div style="position:absolute;right:-20px;top:-20px;width:120px;height:120px;background:rgba(255,255,255,0.08);border-radius:50%;"></div>
                                        <div style="position:absolute;right:30px;top:30px;width:80px;height:80px;background:rgba(255,255,255,0.06);border-radius:50%;"></div>
                                        <div style="font-size:11px;letter-spacing:2px;opacity:0.7;text-transform:uppercase;margin-bottom:24px;">WEDNEST Secure Pay</div>
                                        <div id="dispCardNum" style="font-family:monospace;font-size:20px;letter-spacing:3px;margin-bottom:20px;">•••• •••• •••• ••••</div>
                                        <div style="display:flex;justify-content:space-between;align-items:flex-end;">
                                            <div>
                                                <div style="font-size:9px;opacity:0.6;text-transform:uppercase;margin-bottom:2px;">Card Holder</div>
                                                <div id="dispName" style="font-size:14px;font-weight:600;letter-spacing:1px;text-transform:uppercase;">YOUR NAME</div>
                                            </div>
                                            <div>
                                                <div style="font-size:9px;opacity:0.6;text-transform:uppercase;margin-bottom:2px;">Expires</div>
                                                <div id="dispExpiry" style="font-size:14px;font-weight:600;">MM/YY</div>
                                            </div>
                                            <div style="font-size:36px;opacity:0.9;">💳</div>
                                        </div>
                                    </div>
                                    
                                    <div class="form-group">
                                        <label class="form-label required" for="cardHolder">Cardholder Name</label>
                                        <input type="text" id="cardHolder" class="form-control" placeholder="e.g. Amal Perera" oninput="document.getElementById('dispName').innerText = this.value.toUpperCase() || 'YOUR NAME'">
                                        <div class="error-message" id="errCardHolder"></div>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label required" for="cardNum">Card Number</label>
                                        <input type="text" id="cardNum" class="form-control" placeholder="1234 5678 9012 3456" maxlength="19" oninput="formatCardNum(this)">
                                        <div class="error-message" id="errCardNum"></div>
                                    </div>
                                    <div style="display:grid;grid-template-columns:1fr 1fr;gap:16px;">
                                        <div class="form-group">
                                            <label class="form-label required" for="cardExpiry">Expiry Date</label>
                                            <input type="text" id="cardExpiry" class="form-control" placeholder="MM/YY" maxlength="5" oninput="formatExpiry(this)">
                                            <div class="error-message" id="errCardExpiry"></div>
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label required" for="cardCvv">CVV</label>
                                            <input type="password" id="cardCvv" class="form-control" placeholder="•••" maxlength="3">
                                            <div class="error-message" id="errCardCvv"></div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="form-group">
                                    <label class="form-label required" for="visibleAmount">Payment Amount (Rs.)</label>
                                    <input type="number" step="0.01" name="amount" id="visibleAmount" class="form-control" value="${invoice.balance}" oninput="updateBtnAmount()">
                                    <p style="font-size:12px;color:var(--muted);margin-top:4px;">Max outstanding balance: Rs. ${invoice.balance}</p>
                                    <div class="error-message" id="errAmount"></div>
                                </div>
                                <button type="submit" class="btn btn-primary btn-full" style="height:54px;font-size:16px;letter-spacing:1px;" id="payNowBtn">
                                    🔒 Submit Payment (Rs. <span id="payBtnAmount">${invoice.balance}</span>)
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Payment History -->
                <div class="card-panel reveal" id="paymentHistory">
                    <h3>📜 Payment History</h3>
                    <c:choose>
                        <c:when test="${empty payments}">
                            <div class="empty-state" style="padding:32px 0;">
                                <div class="empty-icon" style="font-size:32px;">💳</div>
                                <p>No payments recorded yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="overflow-x:auto;">
                                <table id="paymentHistoryTable">
                                    <thead>
                                    <tr>
                                        <th>Date</th>
                                        <th>Amount</th>
                                        <th>Method</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <c:forEach var="p" items="${payments}">
                                        <tr>
                                            <td style="white-space:nowrap;">📅 ${p.paymentDate}</td>
                                            <td>
                                                <span style="font-family:'Cormorant Garamond',serif;font-size:16px;font-weight:700;color:var(--success);">
                                                    Rs. ${p.amount}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge badge-confirmed">${p.method}</span>
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
        </c:otherwise>
    </c:choose>
</div>

<script>
    document.querySelectorAll('.reveal').forEach((el, i) => {
        el.style.transitionDelay = (i * 0.1) + 's';
        const obs = new IntersectionObserver(entries => {
            entries.forEach(e => { if(e.isIntersecting) { e.target.classList.add('visible'); obs.unobserve(e.target); } });
        }, { threshold: 0.1 });
        obs.observe(el);
    });

    const maxBalance = Number('${invoice.balance}') || 0;

    function formatCardNum(input) {
        let v = input.value.replace(/\D/g, '').substring(0, 16);
        let formatted = v.match(/.{1,4}/g) ? v.match(/.{1,4}/g).join(' ') : v;
        input.value = formatted;
        let disp = v.padEnd(16, '•');
        let groups = disp.match(/.{1,4}/g);
        document.getElementById('dispCardNum').innerText = groups ? groups.join(' ') : '•••• •••• •••• ••••';
        clearError(input, 'errCardNum');
    }

    function formatExpiry(input) {
        let v = input.value.replace(/\D/g, '').substring(0, 4);
        if (v.length >= 3) v = v.substring(0,2) + '/' + v.substring(2);
        input.value = v;
        document.getElementById('dispExpiry').innerText = v || 'MM/YY';
        clearError(input, 'errCardExpiry');
    }

    function updateBtnAmount() {
        const val = document.getElementById('visibleAmount').value;
        document.getElementById('payBtnAmount').innerText = val || '0.00';
        clearError(document.getElementById('visibleAmount'), 'errAmount');
    }

    function clearError(inputElement, errorElementId) {
        if (!document.getElementById(errorElementId)) return;
        document.getElementById(errorElementId).style.display = 'none';
        if(inputElement) inputElement.classList.remove('is-invalid');
    }

    function showError(inputElement, errorElementId, message) {
        const errDiv = document.getElementById(errorElementId);
        errDiv.textContent = message;
        errDiv.style.display = 'block';
        if(inputElement) inputElement.classList.add('is-invalid');
    }

    document.addEventListener("DOMContentLoaded", function() {
        const form = document.getElementById("payForm");
        const methodSelect = document.getElementById("payMethod");
        const cardSection = document.getElementById("cardSection");
        const submitBtn = document.getElementById("payNowBtn");

        if (methodSelect) {
            methodSelect.addEventListener('change', function() {
                if (this.value === 'CARD') {
                    cardSection.style.display = 'block';
                } else {
                    cardSection.style.display = 'none';
                }
                clearError(this, 'errMethod');
            });
        }

        if (form) {
            form.addEventListener("submit", function(e) {
                e.preventDefault();
                let isValid = true;
                
                // Method Check
                if (!methodSelect.value) {
                    showError(methodSelect, 'errMethod', 'Please select a payment method.');
                    isValid = false;
                }

                // Amount check
                const amountInput = document.getElementById('visibleAmount');
                const amtVal = amountInput.value;
                if (!amtVal || isNaN(amtVal)) {
                    showError(amountInput, 'errAmount', 'Please enter a valid amount.');
                    isValid = false;
                } else {
                    const amt = parseFloat(amtVal);
                    if (amt <= 0) {
                        showError(amountInput, 'errAmount', 'Payment amount must be greater than 0.');
                        isValid = false;
                    } else if (amt > maxBalance) {
                        showError(amountInput, 'errAmount', 'Payment amount cannot exceed the outstanding balance (Rs. ' + maxBalance + ').');
                        isValid = false;
                    }
                }

                // Card checks if CARD selected
                if (methodSelect.value === 'CARD') {
                    const cardHolder = document.getElementById('cardHolder');
                    const cardNum = document.getElementById('cardNum');
                    const cardExpiry = document.getElementById('cardExpiry');
                    const cardCvv = document.getElementById('cardCvv');

                    if (!cardHolder.value.trim()) {
                        showError(cardHolder, 'errCardHolder', 'Cardholder name is required.');
                        isValid = false;
                    } else if (/[0-9]/.test(cardHolder.value)) {
                        showError(cardHolder, 'errCardHolder', 'Cardholder name cannot contain numbers.');
                        isValid = false;
                    }

                    const cleanCardNum = cardNum.value.replace(/\s/g, '');
                    if (!cleanCardNum) {
                        showError(cardNum, 'errCardNum', 'Card number is required.');
                        isValid = false;
                    } else if (!/^\d{16}$/.test(cleanCardNum)) {
                        showError(cardNum, 'errCardNum', 'Card number must be exactly 16 digits.');
                        isValid = false;
                    }

                    if (!cardExpiry.value) {
                        showError(cardExpiry, 'errCardExpiry', 'Expiry date is required.');
                        isValid = false;
                    } else if (!/^(0[1-9]|1[0-2])\/\d{2}$/.test(cardExpiry.value)) {
                        showError(cardExpiry, 'errCardExpiry', 'Invalid format (MM/YY).');
                        isValid = false;
                    } else {
                        // check future date
                        const parts = cardExpiry.value.split('/');
                        const expMonth = parseInt(parts[0], 10);
                        const expYear = parseInt('20' + parts[1], 10);
                        
                        const now = new Date();
                        const currentMonth = now.getMonth() + 1;
                        const currentYear = now.getFullYear();

                        if (expYear < currentYear || (expYear === currentYear && expMonth < currentMonth)) {
                            showError(cardExpiry, 'errCardExpiry', 'Card has expired.');
                            isValid = false;
                        }
                    }

                    if (!cardCvv.value) {
                        showError(cardCvv, 'errCardCvv', 'CVV is required.');
                        isValid = false;
                    } else if (!/^\d{3}$/.test(cardCvv.value)) {
                        showError(cardCvv, 'errCardCvv', 'CVV must be exactly 3 digits.');
                        isValid = false;
                    }
                }

                if (isValid) {
                    submitBtn.disabled = true;
                    submitBtn.innerHTML = 'Processing Payment... <span style="font-size:12px;opacity:0.7;">⏳</span>';
                    form.submit();
                }
            });

            // Input clearing
            ['cardHolder', 'cardNum', 'cardExpiry', 'cardCvv'].forEach(id => {
                const el = document.getElementById(id);
                if(el) {
                    el.addEventListener('input', () => {
                        clearError(el, 'err' + id.charAt(0).toUpperCase() + id.slice(1));
                    });
                }
            });
        }
    });
</script>
</body>
</html>
