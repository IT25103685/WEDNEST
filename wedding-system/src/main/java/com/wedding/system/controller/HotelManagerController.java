package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.service.BookingService;
import com.wedding.system.service.HallService;
import com.wedding.system.service.NotificationService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

/**
 * "Venue / Hall Booking & Availability" (approval side) +
 * "Admin Dashboard" summary for the Hotel Operations Manager.
 */
@Controller
@RequestMapping("/hotel-manager")
public class HotelManagerController {

    private final BookingService bookingService;
    private final HallService hallService;
    private final NotificationService notificationService;

    public HotelManagerController(BookingService bookingService, HallService hallService,
                                   NotificationService notificationService) {
        this.bookingService = bookingService;
        this.hallService = hallService;
        this.notificationService = notificationService;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) throws DatabaseException {
        Integer userId = (Integer) session.getAttribute("userId");
        if (userId == null) return "redirect:/login";
        model.addAttribute("pending", bookingService.getPendingApprovals());
        model.addAttribute("confirmed", bookingService.getConfirmed());
        model.addAttribute("halls", hallService.getAll());
        model.addAttribute("notifications", notificationService.getForUser(userId));
        return "hotelmanager/dashboard";
    }

    @PostMapping("/bookings/{id}/approve")
    public String approve(@PathVariable int id) throws DatabaseException {
        bookingService.decide(id, true);
        return "redirect:/hotel-manager/dashboard";
    }

    @PostMapping("/bookings/{id}/reject")
    public String reject(@PathVariable int id) throws DatabaseException {
        bookingService.decide(id, false);
        return "redirect:/hotel-manager/dashboard";
    }
}
