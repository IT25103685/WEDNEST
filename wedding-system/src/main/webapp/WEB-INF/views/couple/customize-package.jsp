<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customize Package — WEDNEST</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/style.css">
    <style>
        .error-message {
            color: var(--danger);
            font-size: 12px;
            margin-top: 4px;
            display: none;
            animation: fadeIn 0.3s ease;
        }
        .is-invalid { border-color: var(--danger) !important; box-shadow: 0 0 0 3px rgba(156, 46, 66, 0.1) !important; }
        .required::after { content: ' *'; color: var(--danger); }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-5px); } to { opacity: 1; transform: translateY(0); } }
        .tier-box {
            border: 2px solid var(--border-color);
            border-radius: var(--radius-sm);
            padding: 20px;
            cursor: pointer;
            transition: all 0.2s ease;
            text-align: center;
        }
        .tier-box:hover { border-color: var(--gold); background: rgba(212,175,55,0.02); }
        .tier-box.selected { border-color: var(--maroon); background: rgba(107,30,46,0.05); box-shadow: 0 4px 12px rgba(107,30,46,0.1); }
    </style>
</head>
<body>
<jsp:include page="/WEB-INF/views/common/navbar.jsp"/>

<div class="container" style="padding-top:40px;padding-bottom:60px;">

    <!-- Breadcrumb -->
    <div style="font-size:13px;color:var(--muted);margin-bottom:24px;">
        <a href="${pageContext.request.contextPath}/couple/dashboard" style="color:var(--muted);text-decoration:none;">Dashboard</a>
        <span style="margin:0 8px;color:var(--gold);">›</span>
        <span style="color:var(--maroon);">Customize Package</span>
    </div>

    <!-- Page Header -->
    <div class="page-header">
        <div style="font-size:12px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--gold);margin-bottom:8px;">Planning</div>
        <h1 class="page-title">Customize Your Package</h1>
        <p class="page-subtitle">Booking #${booking.id} &middot; 👥 ${booking.expectedGuestCount} guests</p>
    </div>

    <div class="grid grid-2" style="align-items:start;">
        
        <!-- Main Form -->
        <div>
            <div class="card-panel" style="border-top:3px solid var(--maroon);">
                <form method="post" action="${pageContext.request.contextPath}/couple/package/${booking.id}" id="packageForm" novalidate>
                    
                    <div style="margin-bottom:32px;">
                        <label class="form-label required" style="font-size:16px;">Select Package Tier</label>
                        <p style="font-size:13px;color:var(--muted);margin-bottom:16px;">Choose a base package for your event.</p>
                        
                        <div class="error-message" id="errTier" style="margin-bottom:12px;"></div>

                        <select name="tier" id="tierSelect" class="form-control" style="display:none;">
                            <option value="">-- Select a Tier --</option>
                            <option value="STANDARD" ${pkg.tier == 'STANDARD' ? 'selected' : ''}>STANDARD</option>
                            <option value="PREMIUM" ${pkg.tier == 'PREMIUM' ? 'selected' : ''}>PREMIUM</option>
                            <option value="LUXURY" ${pkg.tier == 'LUXURY' ? 'selected' : ''}>LUXURY</option>
                        </select>

                        <div class="grid grid-3" style="gap:16px;">
                            <div class="tier-box ${pkg.tier == 'STANDARD' ? 'selected' : ''}" data-value="STANDARD" data-price="150000">
                                <div style="font-weight:700;color:var(--maroon);margin-bottom:8px;">STANDARD</div>
                                <div style="font-size:18px;font-weight:600;">Rs. 150,000</div>
                            </div>
                            <div class="tier-box ${pkg.tier == 'PREMIUM' ? 'selected' : ''}" data-value="PREMIUM" data-price="300000">
                                <div style="font-weight:700;color:var(--maroon);margin-bottom:8px;">PREMIUM</div>
                                <div style="font-size:18px;font-weight:600;">Rs. 300,000</div>
                            </div>
                            <div class="tier-box ${pkg.tier == 'LUXURY' ? 'selected' : ''}" data-value="LUXURY" data-price="500000">
                                <div style="font-weight:700;color:var(--maroon);margin-bottom:8px;">LUXURY</div>
                                <div style="font-size:18px;font-weight:600;">Rs. 500,000</div>
                            </div>
                        </div>
                    </div>

                    <div style="margin-bottom:32px;">
                        <label class="form-label" style="font-size:16px;">Add-ons</label>
                        <p style="font-size:13px;color:var(--muted);margin-bottom:16px;">Enhance your wedding with these optional services.</p>
                        
                        <div style="display:flex;flex-direction:column;gap:12px;">
                            <label for="catering" style="display:flex;align-items:center;justify-content:space-between;padding:16px;border:1px solid var(--border-color);border-radius:var(--radius-sm);cursor:pointer;background:var(--ivory);">
                                <div style="display:flex;align-items:center;gap:12px;">
                                    <input type="checkbox" name="catering" value="true" id="catering" ${pkg.catering ? 'checked' : ''} class="addon-checkbox" data-price="80000" style="width:20px;height:20px;accent-color:var(--maroon);">
                                    <div>
                                        <div style="font-weight:600;font-size:15px;">🍽️ Catering</div>
                                        <div style="font-size:12px;color:var(--muted);">Premium buffet for all guests</div>
                                    </div>
                                </div>
                                <div style="font-weight:600;color:var(--maroon);">Rs. 80,000</div>
                            </label>

                            <label for="decoration" style="display:flex;align-items:center;justify-content:space-between;padding:16px;border:1px solid var(--border-color);border-radius:var(--radius-sm);cursor:pointer;background:var(--ivory);">
                                <div style="display:flex;align-items:center;gap:12px;">
                                    <input type="checkbox" name="decoration" value="true" id="decoration" ${pkg.decoration ? 'checked' : ''} class="addon-checkbox" data-price="60000" style="width:20px;height:20px;accent-color:var(--maroon);">
                                    <div>
                                        <div style="font-weight:600;font-size:15px;">🌸 Decoration</div>
                                        <div style="font-size:12px;color:var(--muted);">Floral arrangements & stage design</div>
                                    </div>
                                </div>
                                <div style="font-weight:600;color:var(--maroon);">Rs. 60,000</div>
                            </label>

                            <label for="photography" style="display:flex;align-items:center;justify-content:space-between;padding:16px;border:1px solid var(--border-color);border-radius:var(--radius-sm);cursor:pointer;background:var(--ivory);">
                                <div style="display:flex;align-items:center;gap:12px;">
                                    <input type="checkbox" name="photography" value="true" id="photography" ${pkg.photography ? 'checked' : ''} class="addon-checkbox" data-price="45000" style="width:20px;height:20px;accent-color:var(--maroon);">
                                    <div>
                                        <div style="font-weight:600;font-size:15px;">📸 Photography</div>
                                        <div style="font-size:12px;color:var(--muted);">Full day coverage + album</div>
                                    </div>
                                </div>
                                <div style="font-weight:600;color:var(--maroon);">Rs. 45,000</div>
                            </label>

                            <label for="music" style="display:flex;align-items:center;justify-content:space-between;padding:16px;border:1px solid var(--border-color);border-radius:var(--radius-sm);cursor:pointer;background:var(--ivory);">
                                <div style="display:flex;align-items:center;gap:12px;">
                                    <input type="checkbox" name="music" value="true" id="music" ${pkg.music ? 'checked' : ''} class="addon-checkbox" data-price="35000" style="width:20px;height:20px;accent-color:var(--maroon);">
                                    <div>
                                        <div style="font-weight:600;font-size:15px;">🎵 Music / Entertainment</div>
                                        <div style="font-size:12px;color:var(--muted);">Live band or professional DJ</div>
                                    </div>
                                </div>
                                <div style="font-weight:600;color:var(--maroon);">Rs. 35,000</div>
                            </label>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary btn-full" style="height:52px;font-size:16px;" id="savePackageBtn">
                        Save Package Selection
                    </button>
                </form>
            </div>
        </div>

        <!-- Sidebar Summary -->
        <div>
            <div class="card-panel" style="border-top:3px solid var(--gold);position:sticky;top:90px;">
                <h3 style="margin-bottom:20px;">💳 Live Estimate</h3>
                
                <div style="display:flex;justify-content:space-between;margin-bottom:12px;font-size:14px;">
                    <span style="color:var(--muted);">Base Tier</span>
                    <span id="estTierPrice">Rs. 0</span>
                </div>
                <div style="display:flex;justify-content:space-between;margin-bottom:12px;font-size:14px;">
                    <span style="color:var(--muted);">Per Guest (${booking.expectedGuestCount} × Rs. 3,500)</span>
                    <span id="estGuestPrice">Rs. 0</span>
                </div>
                <div style="display:flex;justify-content:space-between;margin-bottom:12px;font-size:14px;">
                    <span style="color:var(--muted);">Add-ons</span>
                    <span id="estAddonPrice">Rs. 0</span>
                </div>
                
                <div style="border-top:1px solid var(--border-color);margin:16px 0;padding-top:16px;display:flex;justify-content:space-between;align-items:center;">
                    <span style="font-weight:700;font-size:16px;">Estimated Total</span>
                    <span id="estTotalPrice" style="font-family:'Cormorant Garamond',serif;font-size:26px;font-weight:700;color:var(--maroon);">Rs. 0</span>
                </div>

                <p style="font-size:11px;color:var(--muted);line-height:1.5;margin-top:16px;">
                    * The total above is a live estimate including the per-guest food/beverage cost. Final invoice might vary based on final guest count and venue specifics.
                </p>
                
                <c:if test="${pkg.totalCost > 0}">
                    <div style="margin-top:20px;padding:12px;background:rgba(42,106,78,0.1);border-radius:var(--radius-sm);color:var(--success);font-size:13px;font-weight:600;text-align:center;">
                        ✓ Previously Saved Total: Rs. ${pkg.totalCost}
                    </div>
                </c:if>
            </div>
        </div>
        
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function() {
    const guestCount = parseInt("${booking.expectedGuestCount}") || 0;
    const guestCostPerPerson = 3500;
    const guestTotal = guestCount * guestCostPerPerson;

    const tierSelect = document.getElementById("tierSelect");
    const tierBoxes = document.querySelectorAll(".tier-box");
    const addonCheckboxes = document.querySelectorAll(".addon-checkbox");
    const errTier = document.getElementById("errTier");

    const elEstTierPrice = document.getElementById("estTierPrice");
    const elEstGuestPrice = document.getElementById("estGuestPrice");
    const elEstAddonPrice = document.getElementById("estAddonPrice");
    const elEstTotalPrice = document.getElementById("estTotalPrice");

    let currentTierPrice = 0;
    
    // Initialize if a tier was already selected (e.g. page load with existing pkg)
    if (tierSelect.value) {
        const activeBox = document.querySelector(`.tier-box[data-value="${tierSelect.value}"]`);
        if (activeBox) {
            currentTierPrice = parseInt(activeBox.getAttribute("data-price"));
        }
    }

    function formatCurrency(num) {
        return "Rs. " + num.toLocaleString('en-US');
    }

    function calculateTotal() {
        elEstGuestPrice.textContent = formatCurrency(guestTotal);
        
        let addonTotal = 0;
        addonCheckboxes.forEach(cb => {
            if (cb.checked) {
                addonTotal += parseInt(cb.getAttribute("data-price"));
            }
        });

        elEstTierPrice.textContent = formatCurrency(currentTierPrice);
        elEstAddonPrice.textContent = formatCurrency(addonTotal);

        const total = currentTierPrice + guestTotal + addonTotal;
        elEstTotalPrice.textContent = formatCurrency(total);
    }

    // Tier selection logic
    tierBoxes.forEach(box => {
        box.addEventListener("click", function() {
            tierBoxes.forEach(b => b.classList.remove("selected"));
            this.classList.add("selected");
            const val = this.getAttribute("data-value");
            tierSelect.value = val;
            currentTierPrice = parseInt(this.getAttribute("data-price"));
            errTier.style.display = 'none';
            calculateTotal();
        });
    });

    // Addon toggle logic
    addonCheckboxes.forEach(cb => {
        cb.addEventListener("change", calculateTotal);
    });

    // Initial calculation
    calculateTotal();

    // Form submission validation
    const form = document.getElementById("packageForm");
    const submitBtn = document.getElementById("savePackageBtn");

    form.addEventListener("submit", function(e) {
        e.preventDefault();
        
        if (!tierSelect.value) {
            errTier.textContent = "Please select a package tier to proceed.";
            errTier.style.display = 'block';
            
            // Scroll to the error
            document.querySelector('.page-header').scrollIntoView({ behavior: 'smooth' });
            return;
        }

        submitBtn.disabled = true;
        submitBtn.innerHTML = 'Saving Package... <span style="font-size:12px;opacity:0.7;">⏳</span>';
        form.submit();
    });
});
</script>
</body>
</html>
