package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.TimelineEvent;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class TimelineEventRepository implements com.wedding.system.repository.Repository<TimelineEvent, Integer> {

    private final DBConnectionManager db;

    public TimelineEventRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(TimelineEvent e) throws DatabaseException {
        String sql = "INSERT INTO TimelineEvents (TimelineId, EventName, StartTime, EndTime, VendorId) VALUES (?,?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bind(ps, e);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) e.setId(keys.getInt(1));
            }
        } catch (SQLException ex) {
            throw new DatabaseException("Failed to create timeline event: " + ex.getMessage(), ex);
        }
    }

    @Override
    public TimelineEvent readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM TimelineEvents WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException ex) {
            throw new DatabaseException("Failed to read timeline event: " + ex.getMessage(), ex);
        }
    }

    public List<TimelineEvent> readByTimelineId(int timelineId) throws DatabaseException {
        String sql = "SELECT * FROM TimelineEvents WHERE TimelineId = ? ORDER BY StartTime";
        List<TimelineEvent> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, timelineId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            return list;
        } catch (SQLException ex) {
            throw new DatabaseException("Failed to read events for timeline: " + ex.getMessage(), ex);
        }
    }

    /** Detects overlapping time slots within the same timeline (simple conflict check). */
    public boolean hasOverlap(int timelineId, Timestamp start, Timestamp end, Integer excludeEventId) throws DatabaseException {
        String sql = "SELECT COUNT(*) AS c FROM TimelineEvents " +
                "WHERE TimelineId = ? AND Id <> ? AND StartTime < ? AND EndTime > ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, timelineId);
            ps.setInt(2, excludeEventId == null ? -1 : excludeEventId);
            ps.setTimestamp(3, end);
            ps.setTimestamp(4, start);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt("c") > 0;
            }
        } catch (SQLException ex) {
            throw new DatabaseException("Failed to check overlap: " + ex.getMessage(), ex);
        }
    }

    @Override
    public List<TimelineEvent> readAll() throws DatabaseException {
        String sql = "SELECT * FROM TimelineEvents ORDER BY Id";
        List<TimelineEvent> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException ex) {
            throw new DatabaseException("Failed to read timeline events: " + ex.getMessage(), ex);
        }
    }

    @Override
    public void update(TimelineEvent e) throws DatabaseException {
        String sql = "UPDATE TimelineEvents SET TimelineId=?, EventName=?, StartTime=?, EndTime=?, VendorId=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            bind(ps, e);
            ps.setInt(6, e.getId());
            ps.executeUpdate();
        } catch (SQLException ex) {
            throw new DatabaseException("Failed to update timeline event: " + ex.getMessage(), ex);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "DELETE FROM TimelineEvents WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException ex) {
            throw new DatabaseException("Failed to delete timeline event: " + ex.getMessage(), ex);
        }
    }

    private void bind(PreparedStatement ps, TimelineEvent e) throws SQLException {
        ps.setInt(1, e.getTimelineId());
        ps.setString(2, e.getEventName());
        ps.setTimestamp(3, e.getStartTime());
        ps.setTimestamp(4, e.getEndTime());
        if (e.getVendorId() != null) ps.setInt(5, e.getVendorId()); else ps.setNull(5, Types.INTEGER);
    }

    private TimelineEvent map(ResultSet rs) throws SQLException {
        int vendorId = rs.getInt("VendorId");
        Integer vendorIdBoxed = rs.wasNull() ? null : vendorId;
        return new TimelineEvent(rs.getInt("Id"), rs.getInt("TimelineId"), rs.getString("EventName"),
                rs.getTimestamp("StartTime"), rs.getTimestamp("EndTime"), vendorIdBoxed);
    }
}
