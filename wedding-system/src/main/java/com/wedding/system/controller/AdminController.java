package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.WeddingHall;
import com.wedding.system.service.BookingService;
import com.wedding.system.service.HallService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

/**
 * Admin dashboard: create/deactivate wedding halls, and see a high-level
 * summary of bookings/revenue/occupancy across the whole hotel. 
 */

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final HallService hallService;
    private final BookingService bookingService;
    private final com.wedding.system.repository.UserRepository userRepository;

    public AdminController(HallService hallService, BookingService bookingService, com.wedding.system.repository.UserRepository userRepository) {
        this.hallService = hallService;
        this.bookingService = bookingService;
        this.userRepository = userRepository;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) throws DatabaseException {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        model.addAttribute("halls", hallService.getAll());
        model.addAttribute("bookings", bookingService.getAll());
        
        java.util.List<com.wedding.system.model.User> staff = new java.util.ArrayList<>();
        for (com.wedding.system.model.User u : userRepository.readAll()) {
            if (!u.getRole().equals("COUPLE") && !u.getRole().equals("VENDOR")) {
                staff.add(u);
            }
        }
        model.addAttribute("staff", staff);
        
        return "admin/dashboard";
    }

    @PostMapping("/halls/create")
    public String createHall(@RequestParam String name, @RequestParam String location,
                              @RequestParam int capacityMax, @RequestParam double pricePerEvent)
            throws DatabaseException {
        WeddingHall hall = new WeddingHall();
        hall.setName(name);
        hall.setLocation(location);
        hall.setCapacityMax(capacityMax);
        hall.setPricePerEvent(pricePerEvent);
        hall.setActive(true);
        hallService.create(hall);
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/halls/{id}/delete")
    public String deleteHall(@PathVariable int id) throws DatabaseException {
        hallService.deactivate(id);
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/staff/create")
    public String createStaff(@RequestParam String fullName, @RequestParam String email,
                              @RequestParam String phone, @RequestParam String username,
                              @RequestParam String password, @RequestParam String role) throws DatabaseException {
        com.wedding.system.model.User u = new com.wedding.system.model.User();
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPhone(phone);
        u.setUsername(username);
        u.setPassword(password);
        u.setRole(role);
        userRepository.create(u);
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/staff/{id}/delete")
    public String deleteStaff(@PathVariable int id) throws DatabaseException {
        userRepository.delete(id);
        return "redirect:/admin/dashboard";
    }
}
