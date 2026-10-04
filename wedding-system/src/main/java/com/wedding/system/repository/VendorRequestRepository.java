package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.VendorRequest;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class VendorRequestRepository implements com.wedding.system.repository.Repository<VendorRequest, Integer> {

    private final DBConnectionManager db;

    public VendorRequestRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(VendorRequest r) throws DatabaseException {
        String sql = "INSERT INTO VendorRequests (BookingId, VendorId, EventDescription, EventDate, Status) VALUES (?,?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bind(ps, r);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) r.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to create vendor request: " + e.getMessage(), e);
        }
    }

    @Override
    public VendorRequest readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM VendorRequests WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read vendor request: " + e.getMessage(), e);
        }
    }

    public List<VendorRequest> readByVendorId(int vendorId) throws DatabaseException {
        String sql = "SELECT vr.*, h.Name AS HallName, h.Location AS HallLocation, u.FullName AS CoupleName " +
                     "FROM VendorRequests vr " +
                     "JOIN Bookings b ON vr.BookingId = b.Id " +
                     "JOIN WeddingHalls h ON b.HallId = h.Id " +
                     "JOIN Users u ON b.CoupleId = u.Id " +
                     "WHERE vr.VendorId = ? ORDER BY vr.EventDate ASC";
        List<VendorRequest> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, vendorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VendorRequest vr = map(rs);
                    vr.setHallName(rs.getString("HallName"));
                    vr.setHallLocation(rs.getString("HallLocation"));
                    vr.setCoupleName(rs.getString("CoupleName"));
                    list.add(vr);
                }
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read vendor requests: " + e.getMessage(), e);
        }
    }

    public List<VendorRequest> readByBookingId(int bookingId) throws DatabaseException {
        String sql = "SELECT vr.*, v.CompanyName FROM VendorRequests vr " +
                     "JOIN Vendors v ON vr.VendorId = v.Id WHERE vr.BookingId = ? ORDER BY vr.Id";
        List<VendorRequest> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    VendorRequest vr = map(rs);
                    vr.setCompanyName(rs.getString("CompanyName"));
                    list.add(vr);
                }
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read vendor requests for booking: " + e.getMessage(), e);
        }
    }

    @Override
    public List<VendorRequest> readAll() throws DatabaseException {
        String sql = "SELECT * FROM VendorRequests ORDER BY Id DESC";
        List<VendorRequest> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read vendor requests: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(VendorRequest r) throws DatabaseException {
        String sql = "UPDATE VendorRequests SET BookingId=?, VendorId=?, EventDescription=?, EventDate=?, Status=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            bind(ps, r);
            ps.setInt(6, r.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update vendor request: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "DELETE FROM VendorRequests WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to delete vendor request: " + e.getMessage(), e);
        }
    }

    private void bind(PreparedStatement ps, VendorRequest r) throws SQLException {
        ps.setInt(1, r.getBookingId());
        ps.setInt(2, r.getVendorId());
        ps.setString(3, r.getEventDescription());
        ps.setDate(4, r.getEventDate());
        ps.setString(5, r.getStatus());
    }

    private VendorRequest map(ResultSet rs) throws SQLException {
        return new VendorRequest(rs.getInt("Id"), rs.getInt("BookingId"), rs.getInt("VendorId"),
                rs.getString("EventDescription"), rs.getDate("EventDate"), rs.getString("Status"));
    }
}
