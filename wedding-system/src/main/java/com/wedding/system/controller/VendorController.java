package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.User;
import com.wedding.system.model.Vendor;
import com.wedding.system.model.VendorRequest;
import com.wedding.system.service.VendorService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Vendor self-service: sign up, log in, then wait for wedding requests
 * (description + date + venue) sent by couples during booking. Accepting/declining
 * is a one-click action.
 */
@Controller
@RequestMapping("/vendor")
public class VendorController {

    private final VendorService vendorService;

    public VendorController(VendorService vendorService) {
        this.vendorService = vendorService;
    }

    @GetMapping("/signup")
    public String signupForm(Model model) {
        model.addAttribute("account", new User());
        model.addAttribute("vendor", new Vendor());
        return "vendor/signup";
    }

    @PostMapping("/signup")
    public String signup(@ModelAttribute("account") User account,
                          @RequestParam String companyName, @RequestParam String category,
                          Model model) throws DatabaseException {
        Vendor vendor = new Vendor();
        vendor.setCompanyName(companyName);
        vendor.setCategory(category);
        try {
            vendorService.registerVendor(account, vendor);
        } catch (DatabaseException e) {
            model.addAttribute("error", e.getMessage());
            return "vendor/signup";
        }
        model.addAttribute("success", "Registered! Please wait for Vendor Relations Manager approval, then log in.");
        return "common/login";
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) throws DatabaseException {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        Vendor vendor = vendorService.getByUserId(userId);
        model.addAttribute("vendor", vendor);
        if (vendor != null) {
            List<VendorRequest> requests = vendorService.getRequestsForVendor(vendor.getId());
            model.addAttribute("requests", requests);
            long pendingCount  = requests.stream().filter(r -> "PENDING".equals(r.getStatus())).count();
            long acceptedCount = requests.stream().filter(r -> "ACCEPTED".equals(r.getStatus())).count();
            model.addAttribute("pendingCount",  pendingCount);
            model.addAttribute("acceptedCount", acceptedCount);
        }
        return "vendor/dashboard";
    }

    /** Dedicated task-schedule view: all assignments sorted by event date. */
    @GetMapping("/tasks")
    public String tasks(HttpSession session, Model model) throws DatabaseException {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        Vendor vendor = vendorService.getByUserId(userId);
        if (vendor == null) return "redirect:/vendor/dashboard";
        model.addAttribute("vendor", vendor);
        List<VendorRequest> requests = vendorService.getRequestsForVendor(vendor.getId());
        // Group: pending first, then accepted, then declined — each group ordered by date
        List<VendorRequest> pending  = requests.stream().filter(r -> "PENDING".equals(r.getStatus())).collect(Collectors.toList());
        List<VendorRequest> accepted = requests.stream().filter(r -> "ACCEPTED".equals(r.getStatus())).collect(Collectors.toList());
        List<VendorRequest> declined = requests.stream().filter(r -> "DECLINED".equals(r.getStatus())).collect(Collectors.toList());
        model.addAttribute("pendingRequests",  pending);
        model.addAttribute("acceptedRequests", accepted);
        model.addAttribute("declinedRequests", declined);
        model.addAttribute("totalPending",  pending.size());
        model.addAttribute("totalAccepted", accepted.size());
        return "vendor/tasks";
    }

    @PostMapping("/requests/{id}/accept")
    public String accept(@PathVariable int id, @RequestHeader(value="Referer", required=false) String referer) throws DatabaseException {
        vendorService.respondToRequest(id, true);
        return referer != null && referer.contains("/tasks") ? "redirect:/vendor/tasks" : "redirect:/vendor/dashboard";
    }

    @PostMapping("/requests/{id}/decline")
    public String decline(@PathVariable int id, @RequestHeader(value="Referer", required=false) String referer) throws DatabaseException {
        vendorService.respondToRequest(id, false);
        return referer != null && referer.contains("/tasks") ? "redirect:/vendor/tasks" : "redirect:/vendor/dashboard";
    }

    @PostMapping("/requests/{id}/cancel")
    public String cancel(@PathVariable int id, @RequestHeader(value="Referer", required=false) String referer) throws DatabaseException {
        vendorService.respondToRequest(id, false);
        return referer != null && referer.contains("/tasks") ? "redirect:/vendor/tasks" : "redirect:/vendor/dashboard";
    }
}
