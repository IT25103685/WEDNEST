package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Notification;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class NotificationRepository implements com.wedding.system.repository.Repository<Notification, Integer> {

    private final DBConnectionManager db;

    public NotificationRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(Notification n) throws DatabaseException {
        String sql = "INSERT INTO Notifications (UserId, GuestId, Message, IsRead, CreatedAt) VALUES (?,?,?,0,SYSDATETIME())";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            if (n.getUserId() != null) ps.setInt(1, n.getUserId()); else ps.setNull(1, Types.INTEGER);
            if (n.getGuestId() != null) ps.setInt(2, n.getGuestId()); else ps.setNull(2, Types.INTEGER);
            ps.setString(3, n.getMessage());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) n.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to create notification: " + e.getMessage(), e);
        }
    }

    @Override
    public Notification readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM Notifications WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read notification: " + e.getMessage(), e);
        }
    }

    /** Notifications for a logged-in User - marked read as soon as they are fetched for viewing. */
    public List<Notification> readAndMarkReadForUser(int userId) throws DatabaseException {
        return fetchAndMark("UserId", userId);
    }

    /** Notifications for a logged-in Guest (via guest code) - same "shown only on login" behaviour. */
    public List<Notification> readAndMarkReadForGuest(int guestId) throws DatabaseException {
        return fetchAndMark("GuestId", guestId);
    }

    private List<Notification> fetchAndMark(String column, int id) throws DatabaseException {
        String selectSql = "SELECT * FROM Notifications WHERE " + column + " = ? ORDER BY CreatedAt DESC";
        String updateSql = "UPDATE Notifications SET IsRead = 1 WHERE " + column + " = ?";
        List<Notification> list = new ArrayList<>();
        try (Connection con = db.getConnection()) {
            try (PreparedStatement ps = con.prepareStatement(selectSql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) list.add(map(rs));
                }
            }
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {
                ps.setInt(1, id);
                ps.executeUpdate();
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read notifications: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Notification> readAll() throws DatabaseException {
        String sql = "SELECT * FROM Notifications ORDER BY Id DESC";
        List<Notification> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read notifications: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Notification n) throws DatabaseException {
        String sql = "UPDATE Notifications SET IsRead = ? WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setBoolean(1, n.isRead());
            ps.setInt(2, n.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update notification: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "DELETE FROM Notifications WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to delete notification: " + e.getMessage(), e);
        }
    }

    private Notification map(ResultSet rs) throws SQLException {
        int userId = rs.getInt("UserId");
        Integer userIdBoxed = rs.wasNull() ? null : userId;
        int guestId = rs.getInt("GuestId");
        Integer guestIdBoxed = rs.wasNull() ? null : guestId;
        return new Notification(rs.getInt("Id"), userIdBoxed, guestIdBoxed, rs.getString("Message"),
                rs.getBoolean("IsRead"), rs.getTimestamp("CreatedAt"));
    }
}
