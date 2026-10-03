package com.wedding.system.controller;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Booking;
import com.wedding.system.model.Invoice;
import com.wedding.system.service.BookingService;
import com.wedding.system.service.PaymentService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

/**
 * "Payment & Billing Management" module - Finance and Billing Manager side.
 * Monitors overdue accounts, and processes cancellation refunds with an
 * audit trail (every refund is itself stored as a Payment row of method
 * "REFUND", so nothing is silently deleted).
 */
@Controller
@RequestMapping("/finance")
public class FinanceController {

    private final PaymentService paymentService;
    private final BookingService bookingService;

    public FinanceController(PaymentService paymentService, BookingService bookingService) {
        this.paymentService = paymentService;
        this.bookingService = bookingService;
    }

    @GetMapping("/dashboard")
    public String dashboard(HttpSession session, Model model) throws DatabaseException {
        if (session.getAttribute("userId") == null) return "redirect:/login";
        model.addAttribute("overdue", paymentService.getOverdue());
        model.addAttribute("allInvoices", paymentService.getAllInvoices());
        return "finance/dashboard";
    }

    @GetMapping("/invoice/{invoiceId}")
    public String invoiceDetail(@PathVariable int invoiceId, Model model) throws DatabaseException {
        // simple reverse lookup: overdue list already carries BookingId, so the JSP
        // links here with both ids when needed. For direct access we accept invoiceId only.
        model.addAttribute("payments", paymentService.getPayments(invoiceId));
        return "finance/invoice-detail";
    }

    @GetMapping("/refund/{bookingId}")
    public String refundForm(@PathVariable int bookingId, Model model) throws DatabaseException {
        Booking booking = bookingService.getById(bookingId);
        Invoice invoice = paymentService.getByBooking(bookingId);
        double suggested = paymentService.calculateRefund(invoice, booking.getEventDate());
        model.addAttribute("booking", booking);
        model.addAttribute("invoice", invoice);
        model.addAttribute("suggestedRefund", suggested);
        return "finance/refund";
    }

    @PostMapping("/refund/{invoiceId}/process")
    public String processRefund(@PathVariable int invoiceId, @RequestParam double amount,
                                 @RequestParam int bookingId) throws DatabaseException {
        paymentService.processRefund(invoiceId, amount);
        return "redirect:/finance/dashboard";
    }
}
