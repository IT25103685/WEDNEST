package com.wedding.system.model;

public class WeddingHall {

    private int id;
    private String name;
    private String location;
    private int capacityMax;
    private double pricePerEvent;
    private boolean active; // admin can "delete" (deactivate) a hall

    public WeddingHall() {
    }

    public WeddingHall(int id, String name, String location, int capacityMax,
                        double pricePerEvent, boolean active) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.capacityMax = capacityMax;
        this.pricePerEvent = pricePerEvent;
        this.active = active;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public int getCapacityMax() { return capacityMax; }
    public void setCapacityMax(int capacityMax) { this.capacityMax = capacityMax; }

    public double getPricePerEvent() { return pricePerEvent; }
    public void setPricePerEvent(double pricePerEvent) { this.pricePerEvent = pricePerEvent; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }
}
