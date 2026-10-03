package com.wedding.system.model;

import java.sql.Timestamp;

public class Payment {

    private int id;
    private int invoiceId;
    private double amount;
    private String method; // CARD, BANK_TRANSFER, CASH
    private Timestamp paymentDate;

    public Payment() {
    }

    public Payment(int id, int invoiceId, double amount, String method, Timestamp paymentDate) {
        this.id = id;
        this.invoiceId = invoiceId;
        this.amount = amount;
        this.method = method;
        this.paymentDate = paymentDate;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getInvoiceId() { return invoiceId; }
    public void setInvoiceId(int invoiceId) { this.invoiceId = invoiceId; }

    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }

    public String getMethod() { return method; }
    public void setMethod(String method) { this.method = method; }

    public Timestamp getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Timestamp paymentDate) { this.paymentDate = paymentDate; }
}
