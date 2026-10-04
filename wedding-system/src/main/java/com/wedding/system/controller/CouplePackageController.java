package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Booking;
import com.wedding.system.model.WeddingHall;
import com.wedding.system.model.WeddingPackage;
import com.wedding.system.service.BookingService;
import com.wedding.system.service.HallService;
import com.wedding.system.service.PackageService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * Major Function 2: Wedding Package Customization (couple side).
 * Lets the couple pick a tier + add-ons and saves the calculated total.
 */
@Controller
@RequestMapping("/couple")
public class CouplePackageController {

    private final BookingService bookingService;
    private final HallService hallService;
    private final PackageService packageService;

    public CouplePackageController(BookingService bookingService, HallService hallService,
                                    PackageService packageService) {
        this.bookingService = bookingService;
        this.hallService = hallService;
        this.packageService = packageService;
    }

    @GetMapping("/package/{bookingId}")
    public String packageForm(@PathVariable int bookingId, Model model) throws DatabaseException {
        Booking booking = bookingService.getById(bookingId);
        WeddingPackage pkg = packageService.getByBooking(bookingId);
        if (pkg == null) {
            pkg = new WeddingPackage();
            pkg.setBookingId(bookingId);
            pkg.setTier("STANDARD");
        }
        model.addAttribute("booking", booking);
        model.addAttribute("pkg", pkg);
        return "couple/customize-package";
    }

    @PostMapping("/package/{bookingId}")
    public String savePackage(@PathVariable int bookingId, @RequestParam String tier,
                               @RequestParam(defaultValue = "false") boolean catering,
                               @RequestParam(defaultValue = "false") boolean decoration,
                               @RequestParam(defaultValue = "false") boolean photography,
                               @RequestParam(defaultValue = "false") boolean music) throws DatabaseException {
        Booking booking = bookingService.getById(bookingId);
        WeddingHall hall = hallService.getById(booking.getHallId());

        WeddingPackage pkg = new WeddingPackage();
        pkg.setBookingId(bookingId);
        pkg.setTier(tier);
        pkg.setCatering(catering);
        pkg.setDecoration(decoration);
        pkg.setPhotography(photography);
        pkg.setMusic(music);

        double total = packageService.calculateTotal(tier, booking.getExpectedGuestCount(),
                hall.getPricePerEvent(), pkg);
        pkg.setTotalCost(total);
        packageService.save(pkg);

        return "redirect:/couple/bookings/" + bookingId;
    }
}
