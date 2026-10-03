package com.wedding.system.service;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Guest;
import com.wedding.system.model.Notification;
import com.wedding.system.repository.GuestRepository;
import com.wedding.system.repository.NotificationRepository;
import com.wedding.system.util.GuestCodeGenerator;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * "Guest List & RSVP Management" module.
 * Couple adds guests one by one -> each guest automatically gets a random
 * guest code -> guest logs in with that code -> guest RSVPs -> headcount is
 * recalculated live via the fn_GuestHeadcount SQL function.
 */
@Service
public class GuestService {

    private final GuestRepository guestRepository;
    private final NotificationRepository notificationRepository;

    public GuestService(GuestRepository guestRepository, NotificationRepository notificationRepository) {
        this.guestRepository = guestRepository;
        this.notificationRepository = notificationRepository;
    }

    public void addGuest(Guest guest) throws DatabaseException {
        String code;
        do {
            code = GuestCodeGenerator.generate();
        } while (guestRepository.readByGuestCode(code) != null); // guarantee uniqueness
        guest.setGuestCode(code);
        guest.setRsvpStatus("PENDING");
        guestRepository.create(guest);
    }

    public List<Guest> getByBooking(int bookingId) throws DatabaseException {
        return guestRepository.readByBookingId(bookingId);
    }

    public Guest loginByCode(String code) throws DatabaseException {
        return guestRepository.readByGuestCode(code);
    }

    public Guest getGuestById(int guestId) throws DatabaseException {
        return guestRepository.readById(guestId);
    }

    public void updateGuest(Guest guest) throws DatabaseException {
        Guest existing = guestRepository.readById(guest.getId());
        if (existing == null) throw new DatabaseException("Guest not found.");
        existing.setName(guest.getName());
        existing.setContact(guest.getContact());
        existing.setCategory(guest.getCategory());
        existing.setFamilyMembersCount(guest.getFamilyMembersCount());
        guestRepository.update(existing);
    }

    public void removeGuest(int guestId) throws DatabaseException {
        guestRepository.delete(guestId);
    }

    public void submitRsvp(int guestId, String status, String dietary, boolean plusOne) throws DatabaseException {
        Guest g = guestRepository.readById(guestId);
        if (g == null) throw new DatabaseException("Guest not found.");
        g.setRsvpStatus(status);
        g.setDietaryRestrictions(dietary);
        g.setPlusOne(plusOne);
        guestRepository.update(g);

        Notification n = new Notification();
        n.setUserId(null);
        // Couple gets notified indirectly by simply seeing the updated guest list;
        // per requirement, notifications only fire for the logging-in user, so we
        // don't push an external alert here.
    }

    /** Live headcount summary: accepted, declined, pending, and total headcount.
     *  Total Headcount = sum of all guests' familyMembersCount + number of plus-ones. */
    public int[] headcountSummary(int bookingId) throws DatabaseException {
        List<Guest> guests = getByBooking(bookingId);
        int accepted = 0, declined = 0, pending = 0;
        int totalHeadcount = 0;
        for (Guest g : guests) {
            switch (g.getRsvpStatus()) {
                case "ACCEPTED": accepted++; break;
                case "DECLINED": declined++; break;
                default: pending++;
            }
            totalHeadcount += g.getFamilyMembersCount();
            if (g.isPlusOne()) totalHeadcount++;
        }
        return new int[]{accepted, declined, pending, totalHeadcount};
    }
}
