package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Booking;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class BookingRepository implements com.wedding.system.repository.Repository<Booking, Integer> {

    private final DBConnectionManager db;

    public BookingRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(Booking b) throws DatabaseException {
        String sql = "INSERT INTO Bookings (CoupleId, HallId, EventDate, ExpectedGuestCount, Status) VALUES (?,?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, b.getCoupleId());
            ps.setInt(2, b.getHallId());
            ps.setDate(3, b.getEventDate());
            ps.setInt(4, b.getExpectedGuestCount());
            ps.setString(5, b.getStatus());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) b.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to create booking: " + e.getMessage(), e);
        }
    }

    @Override
    public Booking readById(Integer id) throws DatabaseException {
        String sql = "SELECT b.*, h.Name AS HallName, u.FullName AS CoupleName " +
                "FROM Bookings b JOIN WeddingHalls h ON b.HallId = h.Id " +
                "JOIN Users u ON b.CoupleId = u.Id WHERE b.Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read booking: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Booking> readAll() throws DatabaseException {
        // Uses the vw_BookingSummary view (see db/schema.sql) - demonstrates DB views in practice.
        String sql = "SELECT * FROM vw_BookingSummary ORDER BY Id DESC";
        List<Booking> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapFromView(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read bookings: " + e.getMessage(), e);
        }
    }

    public List<Booking> readByCoupleId(int coupleId) throws DatabaseException {
        String sql = "SELECT b.*, h.Name AS HallName, u.FullName AS CoupleName " +
                "FROM Bookings b JOIN WeddingHalls h ON b.HallId = h.Id " +
                "JOIN Users u ON b.CoupleId = u.Id WHERE b.CoupleId = ? ORDER BY b.Id DESC";
        List<Booking> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, coupleId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read bookings for couple: " + e.getMessage(), e);
        }
    }

    public List<Booking> readByStatus(String status) throws DatabaseException {
        String sql = "SELECT b.*, h.Name AS HallName, u.FullName AS CoupleName " +
                "FROM Bookings b JOIN WeddingHalls h ON b.HallId = h.Id " +
                "JOIN Users u ON b.CoupleId = u.Id WHERE b.Status = ? ORDER BY b.EventDate";
        List<Booking> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read bookings by status: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Booking b) throws DatabaseException {
        String sql = "UPDATE Bookings SET CoupleId=?, HallId=?, EventDate=?, ExpectedGuestCount=?, Status=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, b.getCoupleId());
            ps.setInt(2, b.getHallId());
            ps.setDate(3, b.getEventDate());
            ps.setInt(4, b.getExpectedGuestCount());
            ps.setString(5, b.getStatus());
            ps.setInt(6, b.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update booking: " + e.getMessage(), e);
        }
    }

    /** Calls the sp_UpdateBookingStatus stored procedure (see db/schema.sql). */
    public void updateStatusViaProcedure(int bookingId, String status) throws DatabaseException {
        String call = "{call sp_UpdateBookingStatus(?, ?)}";
        try (Connection con = db.getConnection(); CallableStatement cs = con.prepareCall(call)) {
            cs.setInt(1, bookingId);
            cs.setString(2, status);
            cs.execute();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update booking status: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "UPDATE Bookings SET Status = 'CANCELLED' WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to cancel booking: " + e.getMessage(), e);
        }
    }

    private Booking map(ResultSet rs) throws SQLException {
        Booking b = new Booking(rs.getInt("Id"), rs.getInt("CoupleId"), rs.getInt("HallId"),
                rs.getDate("EventDate"), rs.getInt("ExpectedGuestCount"), rs.getString("Status"));
        b.setHallName(rs.getString("HallName"));
        b.setCoupleName(rs.getString("CoupleName"));
        return b;
    }

    private Booking mapFromView(ResultSet rs) throws SQLException {
        Booking b = new Booking(rs.getInt("Id"), rs.getInt("CoupleId"), rs.getInt("HallId"),
                rs.getDate("EventDate"), rs.getInt("ExpectedGuestCount"), rs.getString("Status"));
        b.setHallName(rs.getString("HallName"));
        b.setCoupleName(rs.getString("CoupleName"));
        return b;
    }
}
