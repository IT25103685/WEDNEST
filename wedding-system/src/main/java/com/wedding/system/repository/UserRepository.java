package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.User;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * OOP CONCEPT: Polymorphism (method overriding) - this class overrides every
 * method declared in the generic Repository<T, ID> interface with logic
 * specific to the Users table.
 */
@Repository
public class UserRepository implements com.wedding.system.repository.Repository<User, Integer> {

    private final DBConnectionManager db;

    public UserRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(User u) throws DatabaseException {
        String sql = "INSERT INTO Users (FullName, Email, Phone, Username, Password, Role) VALUES (?,?,?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPhone());
            ps.setString(4, u.getUsername());
            ps.setString(5, u.getPassword());
            ps.setString(6, u.getRole());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) u.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to create user: " + e.getMessage(), e);
        }
    }

    @Override
    public User readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM Users WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read user: " + e.getMessage(), e);
        }
    }

    @Override
    public List<User> readAll() throws DatabaseException {
        String sql = "SELECT * FROM Users ORDER BY Id";
        List<User> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read users: " + e.getMessage(), e);
        }
    }

    public List<User> readAllByRole(String role) throws DatabaseException {
        String sql = "SELECT * FROM Users WHERE Role = ? ORDER BY Id";
        List<User> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, role);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read users by role: " + e.getMessage(), e);
        }
    }

    public User findByUsername(String username) throws DatabaseException {
        String sql = "SELECT * FROM Users WHERE Username = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to find user by username: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(User u) throws DatabaseException {
        String sql = "UPDATE Users SET FullName=?, Email=?, Phone=?, Username=?, Password=?, Role=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPhone());
            ps.setString(4, u.getUsername());
            ps.setString(5, u.getPassword());
            ps.setString(6, u.getRole());
            ps.setInt(7, u.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update user: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "DELETE FROM Users WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to delete user: " + e.getMessage(), e);
        }
    }

    private User map(ResultSet rs) throws SQLException {
        return new User(
                rs.getInt("Id"), rs.getString("FullName"), rs.getString("Email"),
                rs.getString("Phone"), rs.getString("Username"), rs.getString("Password"),
                rs.getString("Role"));
    }
}
