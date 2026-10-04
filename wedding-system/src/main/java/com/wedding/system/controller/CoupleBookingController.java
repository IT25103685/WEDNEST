package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Booking;
import com.wedding.system.model.VendorRequest;
import com.wedding.system.model.WeddingHall;
import com.wedding.system.service.*;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.sql.Date;
import java.util.List;

/**
 * Major Function 1: Venue / Hall Booking & Availability Management (couple side).
 * Handles the couple's dashboard, venue search, and booking creation
 * (including sending the initial vendor requests chosen at booking time).
 */
@Controller
@RequestMapping("/couple")
public class CoupleBookingController {

    private final HallService hallService;
    private final BookingService bookingService;
    private final PackageService packageService;
    private final PaymentService paymentService;
    private final VendorService vendorService;
    private final NotificationService notificationService;

    public CoupleBookingController(HallService hallService, BookingService bookingService,
                                    PackageService packageService, PaymentService paymentService,
                                    VendorService vendorService, NotificationService notificationService) {
        this.hallService = hallService;
        this.bookingService = bookingService;
        this.packageService = packageService;
        this.paymentService = paymentService;
        this.vendorService = vendorService;
        this.notificationService = notificationService;
    }

    private Integer requireCouple(HttpSession session) {
        Object id = session.getAttribute("userId");
        return id == null ? null : (Integer) id;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) throws DatabaseException {
        Integer coupleId = requireCouple(session);
        if (coupleId == null) return "redirect:/login";
        model.addAttribute("bookings", bookingService.getByCouple(coupleId));
        model.addAttribute("notifications", notificationService.getForUser(coupleId));
        return "couple/dashboard";
    }

    @GetMapping("/search-venues")
    public String searchForm() {
        return "couple/search-venues";
    }

    @PostMapping("/search-venues")
    public String search(@RequestParam String eventDate, @RequestParam int guestCount, Model model)
            throws DatabaseException {
        List<WeddingHall> halls = hallService.searchAvailable(Date.valueOf(eventDate), guestCount);
        model.addAttribute("halls", halls);
        model.addAttribute("eventDate", eventDate);
        model.addAttribute("guestCount", guestCount);
        return "couple/search-venues";
    }

    @GetMapping("/book/{hallId}")
    public String bookForm(@PathVariable int hallId, @RequestParam String eventDate,
                            @RequestParam int guestCount, Model model) throws DatabaseException {
        model.addAttribute("hall", hallService.getById(hallId));
        model.addAttribute("eventDate", eventDate);
        model.addAttribute("guestCount", guestCount);
        model.addAttribute("vendors", vendorService.getApproved());
        return "couple/book";
    }

    @PostMapping("/book")
    public String book(@RequestParam int hallId, @RequestParam String eventDate, @RequestParam int guestCount,
                        @RequestParam(required = false) List<Integer> vendorIds,
                        @RequestParam(required = false) String weddingDescription,
                        HttpSession session, Model model) throws DatabaseException {
        Integer coupleId = requireCouple(session);
        if (coupleId == null) return "redirect:/login";

        Booking booking = new Booking();
        booking.setCoupleId(coupleId);
        booking.setHallId(hallId);
        booking.setEventDate(Date.valueOf(eventDate));
        booking.setExpectedGuestCount(guestCount);
        bookingService.createBooking(booking);

        if (vendorIds != null) {
            for (Integer vendorId : vendorIds) {
                VendorRequest req = new VendorRequest();
                req.setBookingId(booking.getId());
                req.setVendorId(vendorId);
                req.setEventDate(Date.valueOf(eventDate));
                req.setEventDescription(weddingDescription == null || weddingDescription.isBlank()
                        ? "Wedding booking #" + booking.getId() : weddingDescription);
                vendorService.sendRequestToVendor(req);
            }
        }
        return "redirect:/couple/bookings/" + booking.getId();
    }

    @GetMapping("/bookings/{id}")
    public String bookingDetail(@PathVariable int id, Model model) throws DatabaseException {
        model.addAttribute("booking", bookingService.getById(id));
        model.addAttribute("pkg", packageService.getByBooking(id));
        model.addAttribute("invoice", paymentService.getByBooking(id));
        model.addAttribute("vendorRequests", vendorService.getRequestsForBooking(id));
        return "couple/booking-detail";
    }
}
