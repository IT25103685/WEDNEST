package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.WeddingTimeline;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class WeddingTimelineRepository implements com.wedding.system.repository.Repository<WeddingTimeline, Integer> {

    private final DBConnectionManager db;

    public WeddingTimelineRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(WeddingTimeline t) throws DatabaseException {
        String sql = "INSERT INTO WeddingTimelines (BookingId, CoordinatorId, Status, ChangeRequestMessage) VALUES (?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bind(ps, t);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) t.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to create timeline: " + e.getMessage(), e);
        }
    }

    @Override
    public WeddingTimeline readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM WeddingTimelines WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read timeline: " + e.getMessage(), e);
        }
    }

    public WeddingTimeline readByBookingId(int bookingId) throws DatabaseException {
        String sql = "SELECT * FROM WeddingTimelines WHERE BookingId = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read timeline by booking: " + e.getMessage(), e);
        }
    }

    @Override
    public List<WeddingTimeline> readAll() throws DatabaseException {
        String sql = "SELECT * FROM WeddingTimelines ORDER BY Id DESC";
        List<WeddingTimeline> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read timelines: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(WeddingTimeline t) throws DatabaseException {
        String sql = "UPDATE WeddingTimelines SET BookingId=?, CoordinatorId=?, Status=?, ChangeRequestMessage=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            bind(ps, t);
            ps.setInt(5, t.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update timeline: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "DELETE FROM WeddingTimelines WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to delete timeline: " + e.getMessage(), e);
        }
    }

    private void bind(PreparedStatement ps, WeddingTimeline t) throws SQLException {
        ps.setInt(1, t.getBookingId());
        ps.setInt(2, t.getCoordinatorId());
        ps.setString(3, t.getStatus());
        ps.setString(4, t.getChangeRequestMessage());
    }

    private WeddingTimeline map(ResultSet rs) throws SQLException {
        return new WeddingTimeline(rs.getInt("Id"), rs.getInt("BookingId"), rs.getInt("CoordinatorId"),
                rs.getString("Status"), rs.getString("ChangeRequestMessage"));
    }
}
