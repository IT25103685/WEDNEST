package com.wedding.system.service;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Invoice;
import com.wedding.system.model.Payment;
import com.wedding.system.repository.InvoiceRepository;
import com.wedding.system.repository.PaymentRepository;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

/**
 * "Payment & Billing Management" module: invoices, deposits/partial
 * payments, outstanding balance, and cancellation refunds.
 */
@Service
public class PaymentService {

    private final InvoiceRepository invoiceRepository;
    private final PaymentRepository paymentRepository;

    public PaymentService(InvoiceRepository invoiceRepository, PaymentRepository paymentRepository) {
        this.invoiceRepository = invoiceRepository;
        this.paymentRepository = paymentRepository;
    }

    public Invoice getByBooking(int bookingId) throws DatabaseException {
        Invoice inv = invoiceRepository.readByBookingId(bookingId);
        if (inv == null) {
            inv = new Invoice();
            inv.setBookingId(bookingId);
            inv.setTotalAmount(150000.0);
            inv.setPaidAmount(0.0);
            inv.setStatus("UNPAID");
            invoiceRepository.create(inv);
        }
        return inv;
    }

    public List<Payment> getPayments(int invoiceId) throws DatabaseException {
        return paymentRepository.readByInvoiceId(invoiceId);
    }

    public List<Invoice> getOverdue() throws DatabaseException {
        return invoiceRepository.readOverdue();
    }

    public List<Invoice> getAllInvoices() throws DatabaseException {
        return invoiceRepository.readAll();
    }

    public void makePayment(int invoiceId, double amount, String method) throws DatabaseException {
        Payment p = new Payment();
        p.setInvoiceId(invoiceId);
        p.setAmount(amount);
        p.setMethod(method);
        paymentRepository.create(p);

        Invoice inv = invoiceRepository.readById(invoiceId);
        inv.setPaidAmount(inv.getPaidAmount() + amount);
        inv.setStatus(inv.getBalance() <= 0 ? "PAID" : "PARTIAL");
        invoiceRepository.update(inv);
    }

    /**
     * Simple time-based refund policy:
     *  - 30+ days before the wedding date: 90% refund
     *  - 7-29 days before: 50% refund
     *  - less than 7 days before: 0% refund
     */
    public double calculateRefund(Invoice invoice, Date eventDate) {
        long daysLeft = java.time.temporal.ChronoUnit.DAYS.between(LocalDate.now(), eventDate.toLocalDate());
        double refundRate;
        if (daysLeft >= 30) refundRate = 0.90;
        else if (daysLeft >= 7) refundRate = 0.50;
        else refundRate = 0.0;
        return invoice.getPaidAmount() * refundRate;
    }

    public void processRefund(int invoiceId, double refundAmount) throws DatabaseException {
        Invoice inv = invoiceRepository.readById(invoiceId);
        inv.setPaidAmount(Math.max(0, inv.getPaidAmount() - refundAmount));
        inv.setStatus("UNPAID");
        invoiceRepository.update(inv);

        // Audit trail: record the refund itself as a negative-style payment record.
        Payment refundEntry = new Payment();
        refundEntry.setInvoiceId(invoiceId);
        refundEntry.setAmount(refundAmount);
        refundEntry.setMethod("REFUND");
        paymentRepository.create(refundEntry);
    }
}
