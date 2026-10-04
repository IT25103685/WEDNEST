package com.wedding.system.model;

public class Vendor {

    private int id;
    private int userId;          // FK -> User.id (role = VENDOR)
    private String companyName;
    private String category;     // CATERER, PHOTOGRAPHER, DECORATOR, DJ, MAKEUP_ARTIST, CAKE, TRANSPORT
    private String status;       // PENDING, APPROVED, REJECTED
    private String contractTerms;
    private double rating;       // average performance rating

    public Vendor() {
    }

    public Vendor(int id, int userId, String companyName, String category,
                   String status, String contractTerms, double rating) {
        this.id = id;
        this.userId = userId;
        this.companyName = companyName;
        this.category = category;
        this.status = status;
        this.contractTerms = contractTerms;
        this.rating = rating;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getContractTerms() { return contractTerms; }
    public void setContractTerms(String contractTerms) { this.contractTerms = contractTerms; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }
}
