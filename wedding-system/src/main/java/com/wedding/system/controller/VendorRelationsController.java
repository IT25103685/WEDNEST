package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.service.VendorService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

/**
 * "Admin Dashboard & Vendor Management" module - Vendor Relations Manager
 * side: approve pending vendor sign-ups and record performance ratings.
 */
@Controller
@RequestMapping("/vendor-relations")
public class VendorRelationsController {

    private final VendorService vendorService;

    public VendorRelationsController(VendorService vendorService) {
        this.vendorService = vendorService;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) throws DatabaseException {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        model.addAttribute("pending", vendorService.getPending());
        model.addAttribute("all", vendorService.getAll());
        return "vendorrelations/dashboard";
    }

    @PostMapping("/vendors/{id}/approve")
    public String approve(@PathVariable int id) throws DatabaseException {
        vendorService.approve(id);
        return "redirect:/vendor-relations/dashboard";
    }

    @PostMapping("/vendors/{id}/rate")
    public String rate(@PathVariable int id, @RequestParam double rating) throws DatabaseException {
        vendorService.rate(id, rating);
        return "redirect:/vendor-relations/dashboard";
    }

    @PostMapping("/vendors/{id}/remove")
    public String remove(@PathVariable int id) throws DatabaseException {
        vendorService.removeVendor(id);
        return "redirect:/vendor-relations/dashboard";
    }
}
