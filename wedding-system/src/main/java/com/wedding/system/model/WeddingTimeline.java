package com.wedding.system.model;

public class WeddingTimeline {

    private int id;
    private int bookingId;
    private int coordinatorId;
    private String status;              // DRAFT, PUBLISHED, CHANGE_REQUESTED
    private String changeRequestMessage; // message from the couple when they ask for a change

    public WeddingTimeline() {
    }

    public WeddingTimeline(int id, int bookingId, int coordinatorId, String status, String changeRequestMessage) {
        this.id = id;
        this.bookingId = bookingId;
        this.coordinatorId = coordinatorId;
        this.status = status;
        this.changeRequestMessage = changeRequestMessage;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getCoordinatorId() { return coordinatorId; }
    public void setCoordinatorId(int coordinatorId) { this.coordinatorId = coordinatorId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getChangeRequestMessage() { return changeRequestMessage; }
    public void setChangeRequestMessage(String changeRequestMessage) { this.changeRequestMessage = changeRequestMessage; }
}
