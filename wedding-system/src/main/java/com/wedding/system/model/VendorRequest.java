package com.wedding.system.model;

import java.sql.Date;

public class VendorRequest {

    private int id;
    private int bookingId;
    private int vendorId;
    private String eventDescription;
    private Date eventDate;
    private String status; // PENDING, ACCEPTED, DECLINED
    private String companyName;    // enriched (not stored in DB)
    private String hallName;       // enriched from Bookings -> WeddingHalls
    private String hallLocation;   // enriched from Bookings -> WeddingHalls
    private String coupleName;     // enriched from Bookings -> Users

    public VendorRequest() {
    }

    public VendorRequest(int id, int bookingId, int vendorId, String eventDescription,
                          Date eventDate, String status) {
        this.id = id;
        this.bookingId = bookingId;
        this.vendorId = vendorId;
        this.eventDescription = eventDescription;
        this.eventDate = eventDate;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getVendorId() { return vendorId; }
    public void setVendorId(int vendorId) { this.vendorId = vendorId; }

    public String getEventDescription() { return eventDescription; }
    public void setEventDescription(String eventDescription) { this.eventDescription = eventDescription; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getHallName() { return hallName; }
    public void setHallName(String hallName) { this.hallName = hallName; }

    public String getHallLocation() { return hallLocation; }
    public void setHallLocation(String hallLocation) { this.hallLocation = hallLocation; }

    public String getCoupleName() { return coupleName; }
    public void setCoupleName(String coupleName) { this.coupleName = coupleName; }
}
