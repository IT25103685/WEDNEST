package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Guest;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class GuestRepository implements com.wedding.system.repository.Repository<Guest, Integer> {

    private final DBConnectionManager db;

    public GuestRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(Guest g) throws DatabaseException {
        String sql = "INSERT INTO Guests (BookingId, Name, Contact, Category, GuestCode, RsvpStatus, DietaryRestrictions, PlusOne, FamilyMembersCount) VALUES (?,?,?,?,?,?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bind(ps, g);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) g.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to create guest: " + e.getMessage(), e);
        }
    }

    @Override
    public Guest readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM Guests WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read guest: " + e.getMessage(), e);
        }
    }

    public Guest readByGuestCode(String code) throws DatabaseException {
        String sql = "SELECT * FROM Guests WHERE GuestCode = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read guest by code: " + e.getMessage(), e);
        }
    }

    public List<Guest> readByBookingId(int bookingId) throws DatabaseException {
        String sql = "SELECT * FROM Guests WHERE BookingId = ? ORDER BY Id";
        List<Guest> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read guests for booking: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Guest> readAll() throws DatabaseException {
        String sql = "SELECT * FROM Guests ORDER BY Id";
        List<Guest> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read guests: " + e.getMessage(), e);
        }
    }

    /** Uses fn_GuestHeadcount scalar function (see db/schema.sql) to total accepted guests + plus-ones. */
    public int countAcceptedHeadcount(int bookingId) throws DatabaseException {
        String sql = "SELECT dbo.fn_GuestHeadcount(?) AS Headcount";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt("Headcount") : 0;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to count headcount: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Guest g) throws DatabaseException {
        String sql = "UPDATE Guests SET BookingId=?, Name=?, Contact=?, Category=?, GuestCode=?, RsvpStatus=?, DietaryRestrictions=?, PlusOne=?, FamilyMembersCount=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            bind(ps, g);
            ps.setInt(10, g.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update guest: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "DELETE FROM Guests WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to delete guest: " + e.getMessage(), e);
        }
    }

    private void bind(PreparedStatement ps, Guest g) throws SQLException {
        ps.setInt(1, g.getBookingId());
        ps.setString(2, g.getName());
        ps.setString(3, g.getContact());
        ps.setString(4, g.getCategory());
        ps.setString(5, g.getGuestCode());
        ps.setString(6, g.getRsvpStatus());
        ps.setString(7, g.getDietaryRestrictions());
        ps.setBoolean(8, g.isPlusOne());
        ps.setInt(9, g.getFamilyMembersCount());
    }

    private Guest map(ResultSet rs) throws SQLException {
        return new Guest(rs.getInt("Id"), rs.getInt("BookingId"), rs.getString("Name"),
                rs.getString("Contact"), rs.getString("Category"), rs.getString("GuestCode"),
                rs.getString("RsvpStatus"), rs.getString("DietaryRestrictions"), rs.getBoolean("PlusOne"),
                rs.getInt("FamilyMembersCount"));
    }
}
