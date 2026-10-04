package com.wedding.system.service;

import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Booking;
import com.wedding.system.model.Notification;
import com.wedding.system.repository.BookingRepository;
import com.wedding.system.repository.NotificationRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookingService {

    private final BookingRepository bookingRepository;
    private final NotificationRepository notificationRepository;

    public BookingService(BookingRepository bookingRepository, NotificationRepository notificationRepository) {
        this.bookingRepository = bookingRepository;
        this.notificationRepository = notificationRepository;
    }

    public void createBooking(Booking booking) throws DatabaseException {
        booking.setStatus("PENDING_APPROVAL");
        bookingRepository.create(booking);

        // Notify the Hotel Operations Manager role is handled at controller/dashboard
        // level (they simply see all PENDING_APPROVAL bookings when they log in).
    }

    public Booking getById(int id) throws DatabaseException {
        return bookingRepository.readById(id);
    }

    public List<Booking> getByCouple(int coupleId) throws DatabaseException {
        return bookingRepository.readByCoupleId(coupleId);
    }

    public List<Booking> getPendingApprovals() throws DatabaseException {
        return bookingRepository.readByStatus("PENDING_APPROVAL");
    }

    public List<Booking> getConfirmed() throws DatabaseException {
        return bookingRepository.readByStatus("CONFIRMED");
    }

    public List<Booking> getAll() throws DatabaseException {
        return bookingRepository.readAll();
    }

    /**
     * Hotel Operations Manager approves or rejects a booking.
     * Uses the sp_UpdateBookingStatus stored procedure - approving also
     * auto-generates the invoice (see db/schema.sql), and the DB trigger
     * automatically creates the couple's "booking confirmed" notification.
     */
    public void decide(int bookingId, boolean approve) throws DatabaseException {
        bookingRepository.updateStatusViaProcedure(bookingId, approve ? "CONFIRMED" : "REJECTED");
    }

    public void cancel(int bookingId) throws DatabaseException {
        bookingRepository.delete(bookingId); // sets status = CANCELLED
    }

    public void notify(int userId, String message) throws DatabaseException {
        Notification n = new Notification();
        n.setUserId(userId);
        n.setMessage(message);
        notificationRepository.create(n);
    }
}
