package com.wedding.system.model;

import java.sql.Timestamp;

public class TimelineEvent {

    private int id;
    private int timelineId;
    private String eventName; // e.g. "Ceremony", "Reception", "Cake Cutting"
    private Timestamp startTime;
    private Timestamp endTime;
    private Integer vendorId; // nullable - which vendor is responsible

    public TimelineEvent() {
    }

    public TimelineEvent(int id, int timelineId, String eventName, Timestamp startTime,
                          Timestamp endTime, Integer vendorId) {
        this.id = id;
        this.timelineId = timelineId;
        this.eventName = eventName;
        this.startTime = startTime;
        this.endTime = endTime;
        this.vendorId = vendorId;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getTimelineId() { return timelineId; }
    public void setTimelineId(int timelineId) { this.timelineId = timelineId; }

    public String getEventName() { return eventName; }
    public void setEventName(String eventName) { this.eventName = eventName; }

    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }

    public Timestamp getEndTime() { return endTime; }
    public void setEndTime(Timestamp endTime) { this.endTime = endTime; }

    public Integer getVendorId() { return vendorId; }
    public void setVendorId(Integer vendorId) { this.vendorId = vendorId; }
}
