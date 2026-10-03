package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Guest;
import com.wedding.system.service.GuestService;
import com.wedding.system.service.NotificationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

/**
 * Guests never get a username/password - they "log in" with the random
 * guest code the couple's system generated for them, and land on a simple
 * digital invitation where they can RSVP.
 */
@Controller
@RequestMapping("/guest")
public class GuestController {

    private final GuestService guestService;
    private final NotificationService notificationService;

    public GuestController(GuestService guestService, NotificationService notificationService) {
        this.guestService = guestService;
        this.notificationService = notificationService;
    }

    @GetMapping("/login")
    public String loginPage() {
        return "guest/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String guestCode, HttpSession session, Model model) throws DatabaseException {
        Guest g = guestService.loginByCode(guestCode.trim().toUpperCase());
        if (g == null) {
            model.addAttribute("error", "Invalid guest code. Please check your invitation.");
            return "guest/login";
        }
        session.setAttribute("guestId", g.getId());
        return "redirect:/guest/invitation";
    }

    @GetMapping("/invitation")
    public String invitation(HttpSession session, Model model) throws DatabaseException {
        Integer guestId = (Integer) session.getAttribute("guestId");
        if (guestId == null) return "redirect:/guest/login";
        Guest g = guestService.getGuestById(guestId);
        model.addAttribute("guest", g);
        model.addAttribute("notifications", notificationService.getForGuest(guestId));
        return "guest/invitation";
    }

    @PostMapping("/rsvp")
    public String rsvp(@RequestParam String status, @RequestParam(required = false) String dietary,
                        @RequestParam(defaultValue = "false") boolean plusOne, HttpSession session)
            throws DatabaseException {
        Integer guestId = (Integer) session.getAttribute("guestId");
        if (guestId == null) return "redirect:/guest/login";
        guestService.submitRsvp(guestId, status, dietary, plusOne);
        return "redirect:/guest/invitation";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/guest/login";
    }
}
