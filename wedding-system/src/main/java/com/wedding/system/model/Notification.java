package com.wedding.system.model;

import java.sql.Timestamp;

/**
 * Notifications are stored in the DB and only shown to the user the moment
 * they log in and view their dashboard (no email/SMS integration, per the
 * "don't want to send notification other external ways" requirement).
 * Either userId or guestId is set, never both.
 */
public class Notification {

    private int id;
    private Integer userId;
    private Integer guestId;
    private String message;
    private boolean isRead;
    private Timestamp createdAt;

    public Notification() {
    }

    public Notification(int id, Integer userId, Integer guestId, String message,
                         boolean isRead, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.guestId = guestId;
        this.message = message;
        this.isRead = isRead;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public Integer getGuestId() { return guestId; }
    public void setGuestId(Integer guestId) { this.guestId = guestId; }

    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }

    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
