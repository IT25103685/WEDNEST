package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Guest;
import com.wedding.system.service.GuestService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * Major Function 3: Guest List & RSVP Management (couple side).
 * The couple adds guests one by one; each guest automatically gets a
 * random guest code (see GuestService / GuestCodeGenerator).
 */
@Controller
@RequestMapping("/couple")
public class CoupleGuestController {

    private final GuestService guestService;

    public CoupleGuestController(GuestService guestService) {
        this.guestService = guestService;
    }

    @GetMapping("/guests/{bookingId}")
    public String guestList(@PathVariable int bookingId, Model model) throws DatabaseException {
        model.addAttribute("bookingId", bookingId);
        model.addAttribute("guests", guestService.getByBooking(bookingId));
        model.addAttribute("summary", guestService.headcountSummary(bookingId));
        return "couple/guest-list";
    }

    @PostMapping("/guests/{bookingId}/add")
    public String addGuest(@PathVariable int bookingId, @RequestParam String name,
                            @RequestParam(required = false) String contact,
                            @RequestParam(required = false) String category,
                            @RequestParam(required = false) Integer familyMembersCount) throws DatabaseException {
        Guest g = new Guest();
        g.setBookingId(bookingId);
        g.setName(name);
        g.setContact(contact);
        g.setCategory(category);
        if (familyMembersCount != null) {
            g.setFamilyMembersCount(familyMembersCount);
        }
        guestService.addGuest(g);
        return "redirect:/couple/guests/" + bookingId;
    }

    @PostMapping("/guests/{bookingId}/update/{guestId}")
    public String updateGuest(@PathVariable int bookingId, @PathVariable int guestId, 
                              @RequestParam String name,
                              @RequestParam(required = false) String contact,
                              @RequestParam(required = false) String category,
                              @RequestParam(required = false) Integer familyMembersCount) throws DatabaseException {
        Guest g = new Guest();
        g.setId(guestId);
        g.setName(name);
        g.setContact(contact);
        g.setCategory(category);
        if (familyMembersCount != null) {
            g.setFamilyMembersCount(familyMembersCount);
        }
        guestService.updateGuest(g);
        return "redirect:/couple/guests/" + bookingId;
    }

    @PostMapping("/guests/{bookingId}/remove/{guestId}")
    public String removeGuest(@PathVariable int bookingId, @PathVariable int guestId) throws DatabaseException {
        guestService.removeGuest(guestId);
        return "redirect:/couple/guests/" + bookingId;
    }
}
