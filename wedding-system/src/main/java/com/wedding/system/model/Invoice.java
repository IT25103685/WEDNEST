package com.wedding.system.model;

public class Invoice {

    private int id;
    private int bookingId;
    private double totalAmount;
    private double paidAmount;
    private String status; // UNPAID, PARTIAL, PAID

    public Invoice() {
    }

    public Invoice(int id, int bookingId, double totalAmount, double paidAmount, String status) {
        this.id = id;
        this.bookingId = bookingId;
        this.totalAmount = totalAmount;
        this.paidAmount = paidAmount;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public double getPaidAmount() { return paidAmount; }
    public void setPaidAmount(double paidAmount) { this.paidAmount = paidAmount; }

    public double getBalance() { return totalAmount - paidAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
