package com.wedding.system.model;

/**
 * Represents every "logged in with username/password" actor in the system:
 * Couple, Hotel Operations Manager, Senior Wedding Coordinator,
 * Finance and Billing Manager, Vendor Relations Manager, Vendor, Admin.
 *
 * Guests are NOT users - they use a guest code instead (see Guest.java).
 *
 * OOP CONCEPT: Encapsulation - all fields are private, accessed only through
 * public getters/setters.
 * OOP CONCEPT: Constructor overloading (static polymorphism) - a no-arg
 * constructor and a fully parameterized constructor are both provided.
 */
public class User {

    private int id;
    private String fullName;
    private String email;
    private String phone;
    private String username;
    private String password; // kept as plain text on purpose - "simple methods" for a student project
    private String role;     // COUPLE, HOTEL_MANAGER, COORDINATOR, FINANCE_MANAGER, VENDOR_RELATIONS, VENDOR, ADMIN

    public User() {
    }

    public User(int id, String fullName, String email, String phone,
                String username, String password, String role) {
        this.id = id;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.username = username;
        this.password = password;
        this.role = role;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
}
