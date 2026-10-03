package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.service.BookingService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

/**
 * Major Function 4: Payment & Billing Management (couple side).
 * View invoice, make a deposit/partial payment, or request cancellation
 * (the actual refund calculation/processing is done by the Finance and
 * Billing Manager - see FinanceController).
 */
@Controller
@RequestMapping("/couple")
public class CouplePaymentController {

    private final PaymentService paymentService;
    private final BookingService bookingService;

    public CouplePaymentController(PaymentService paymentService, BookingService bookingService) {
        this.paymentService = paymentService;
        this.bookingService = bookingService;
    }

    @GetMapping("/payment/{bookingId}")
    public String payment(@PathVariable int bookingId, Model model) throws DatabaseException {
        Invoice invoice = paymentService.getByBooking(bookingId);
        model.addAttribute("booking", bookingService.getById(bookingId));
        model.addAttribute("invoice", invoice);
        if (invoice != null) {
            model.addAttribute("payments", paymentService.getPayments(invoice.getId()));
        }
        return "couple/payment";
    }

    @PostMapping("/payment/{bookingId}/pay")
    public String pay(@PathVariable int bookingId, @RequestParam double amount,
                       @RequestParam String method) throws DatabaseException {
        Invoice invoice = paymentService.getByBooking(bookingId);
        paymentService.makePayment(invoice.getId(), amount, method);
        return "redirect:/couple/payment/" + bookingId;
    }

    @PostMapping("/payment/{bookingId}/cancel")
    public String requestCancellation(@PathVariable int bookingId) throws DatabaseException {
        // Booking is cancelled immediately; the Finance & Billing Manager processes
        // the refund (time-based policy) from their own dashboard with a full audit trail.
        bookingService.cancel(bookingId);
        return "redirect:/couple/dashboard";
    }
}
