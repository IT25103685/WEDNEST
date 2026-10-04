package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.WeddingHall;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class WeddingHallRepository implements com.wedding.system.repository.Repository<WeddingHall, Integer> {

    private final DBConnectionManager db;

    public WeddingHallRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(WeddingHall h) throws DatabaseException {
        String sql = "INSERT INTO WeddingHalls (Name, Location, CapacityMax, PricePerEvent, IsActive) VALUES (?,?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, h.getName());
            ps.setString(2, h.getLocation());
            ps.setInt(3, h.getCapacityMax());
            ps.setDouble(4, h.getPricePerEvent());
            ps.setBoolean(5, h.isActive());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) h.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to create wedding hall: " + e.getMessage(), e);
        }
    }

    @Override
    public WeddingHall readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM WeddingHalls WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read wedding hall: " + e.getMessage(), e);
        }
    }

    @Override
    public List<WeddingHall> readAll() throws DatabaseException {
        String sql = "SELECT * FROM WeddingHalls ORDER BY Id";
        List<WeddingHall> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read wedding halls: " + e.getMessage(), e);
        }
    }

    /** Halls that are active AND have enough capacity AND are free on the given date. */
    public List<WeddingHall> searchAvailable(Date eventDate, int guestCount) throws DatabaseException {
        String sql = "SELECT h.* FROM WeddingHalls h " +
                "WHERE h.IsActive = 1 AND h.CapacityMax >= ? " +
                "AND h.Id NOT IN (" +
                "   SELECT b.HallId FROM Bookings b " +
                "   WHERE b.EventDate = ? AND b.Status IN ('PENDING_APPROVAL','CONFIRMED')" +
                ") ORDER BY h.PricePerEvent";
        List<WeddingHall> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, guestCount);
            ps.setDate(2, eventDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to search available halls: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(WeddingHall h) throws DatabaseException {
        String sql = "UPDATE WeddingHalls SET Name=?, Location=?, CapacityMax=?, PricePerEvent=?, IsActive=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, h.getName());
            ps.setString(2, h.getLocation());
            ps.setInt(3, h.getCapacityMax());
            ps.setDouble(4, h.getPricePerEvent());
            ps.setBoolean(5, h.isActive());
            ps.setInt(6, h.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update wedding hall: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        // "delete" = deactivate, so past bookings keep a valid hall reference
        String sql = "UPDATE WeddingHalls SET IsActive = 0 WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to delete wedding hall: " + e.getMessage(), e);
        }
    }

    private WeddingHall map(ResultSet rs) throws SQLException {
        return new WeddingHall(rs.getInt("Id"), rs.getString("Name"), rs.getString("Location"),
                rs.getInt("CapacityMax"), rs.getDouble("PricePerEvent"), rs.getBoolean("IsActive"));
    }
}
