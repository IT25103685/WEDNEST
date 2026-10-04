package com.wedding.system.model;

public class WeddingPackage {

    private int id;
    private int bookingId;
    private String tier;          // STANDARD, PREMIUM, LUXURY
    private boolean catering;
    private boolean decoration;
    private boolean photography;
    private boolean music;
    private double totalCost;

    public WeddingPackage() {
    }

    public WeddingPackage(int id, int bookingId, String tier, boolean catering,
                           boolean decoration, boolean photography, boolean music, double totalCost) {
        this.id = id;
        this.bookingId = bookingId;
        this.tier = tier;
        this.catering = catering;
        this.decoration = decoration;
        this.photography = photography;
        this.music = music;
        this.totalCost = totalCost;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public String getTier() { return tier; }
    public void setTier(String tier) { this.tier = tier; }

    public boolean isCatering() { return catering; }
    public void setCatering(boolean catering) { this.catering = catering; }

    public boolean isDecoration() { return decoration; }
    public void setDecoration(boolean decoration) { this.decoration = decoration; }

    public boolean isPhotography() { return photography; }
    public void setPhotography(boolean photography) { this.photography = photography; }

    public boolean isMusic() { return music; }
    public void setMusic(boolean music) { this.music = music; }

    public double getTotalCost() { return totalCost; }
    public void setTotalCost(double totalCost) { this.totalCost = totalCost; }
}
