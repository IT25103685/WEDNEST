package com.wedding.system.model;

import java.sql.Date;

public class Booking {

    private int id;
    private int coupleId;      // FK -> User.id (role = COUPLE)
    private int hallId;        // FK -> WeddingHall.id
    private Date eventDate;
    private int expectedGuestCount;
    private String status;     // PENDING_APPROVAL, CONFIRMED, REJECTED, CANCELLED

    public Booking() {
    }

    public Booking(int id, int coupleId, int hallId, Date eventDate,
                    int expectedGuestCount, String status) {
        this.id = id;
        this.coupleId = coupleId;
        this.hallId = hallId;
        this.eventDate = eventDate;
        this.expectedGuestCount = expectedGuestCount;
        this.status = status;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCoupleId() { return coupleId; }
    public void setCoupleId(int coupleId) { this.coupleId = coupleId; }

    public int getHallId() { return hallId; }
    public void setHallId(int hallId) { this.hallId = hallId; }

    public Date getEventDate() { return eventDate; }
    public void setEventDate(Date eventDate) { this.eventDate = eventDate; }

    public int getExpectedGuestCount() { return expectedGuestCount; }
    public void setExpectedGuestCount(int expectedGuestCount) { this.expectedGuestCount = expectedGuestCount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    // convenience fields filled in by services for the UI (not DB columns)
    private String hallName;
    private String coupleName;
    public String getHallName() { return hallName; }
    public void setHallName(String hallName) { this.hallName = hallName; }
    public String getCoupleName() { return coupleName; }
    public void setCoupleName(String coupleName) { this.coupleName = coupleName; }
}
