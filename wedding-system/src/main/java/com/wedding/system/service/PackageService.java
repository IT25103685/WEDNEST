package com.wedding.system.service;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.WeddingPackage;
import com.wedding.system.repository.WeddingPackageRepository;
import org.springframework.stereotype.Service;

/**
 * Handles the "Wedding Package Customization" module: tier pricing,
 * per-guest pricing, add-on pricing, and the running total.
 */
@Service
public class PackageService {

    // Simple fixed pricing table - easy for students to explain/defend in a viva.
    private static final double TIER_STANDARD = 150000;
    private static final double TIER_PREMIUM = 300000;
    private static final double TIER_LUXURY = 500000;

    private static final double PER_GUEST_PRICE = 3500;

    private static final double ADDON_CATERING = 80000;
    private static final double ADDON_DECORATION = 60000;
    private static final double ADDON_PHOTOGRAPHY = 45000;
    private static final double ADDON_MUSIC = 35000;

    private final WeddingPackageRepository packageRepository;

    public PackageService(WeddingPackageRepository packageRepository) {
        this.packageRepository = packageRepository;
    }

    public double tierPrice(String tier) {
        switch (tier) {
            case "PREMIUM": return TIER_PREMIUM;
            case "LUXURY": return TIER_LUXURY;
            default: return TIER_STANDARD;
        }
    }

    /** Tier + per-guest price + venue fee + selected add-ons = total cost. */
    public double calculateTotal(String tier, int guestCount, double venueFee, WeddingPackage pkg) {
        double total = tierPrice(tier) + (guestCount * PER_GUEST_PRICE) + venueFee;
        if (pkg.isCatering()) total += ADDON_CATERING;
        if (pkg.isDecoration()) total += ADDON_DECORATION;
        if (pkg.isPhotography()) total += ADDON_PHOTOGRAPHY;
        if (pkg.isMusic()) total += ADDON_MUSIC;
        return total;
    }

    public void save(WeddingPackage pkg) throws DatabaseException {
        WeddingPackage existing = packageRepository.readByBookingId(pkg.getBookingId());
        if (existing == null) {
            packageRepository.create(pkg);
        } else {
            pkg.setId(existing.getId());
            packageRepository.update(pkg);
        }
    }

    public WeddingPackage getByBooking(int bookingId) throws DatabaseException {
        return packageRepository.readByBookingId(bookingId);
    }

    public double addonCatering() { return ADDON_CATERING; }
    public double addonDecoration() { return ADDON_DECORATION; }
    public double addonPhotography() { return ADDON_PHOTOGRAPHY; }
    public double addonMusic() { return ADDON_MUSIC; }
    public double perGuestPrice() { return PER_GUEST_PRICE; }
}
