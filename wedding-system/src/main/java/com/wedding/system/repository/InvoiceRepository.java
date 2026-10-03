package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Invoice;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class InvoiceRepository implements com.wedding.system.repository.Repository<Invoice, Integer> {

    private final DBConnectionManager db;

    public InvoiceRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(Invoice inv) throws DatabaseException {
        String sql = "INSERT INTO Invoices (BookingId, TotalAmount, PaidAmount, Status) VALUES (?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, inv.getBookingId());
            ps.setDouble(2, inv.getTotalAmount());
            ps.setDouble(3, inv.getPaidAmount());
            ps.setString(4, inv.getStatus());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) inv.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to create invoice: " + e.getMessage(), e);
        }
    }

    @Override
    public Invoice readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM Invoices WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read invoice: " + e.getMessage(), e);
        }
    }

    public Invoice readByBookingId(int bookingId) throws DatabaseException {
        String sql = "SELECT * FROM Invoices WHERE BookingId = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read invoice by booking: " + e.getMessage(), e);
        }
    }

    public List<Invoice> readOverdue() throws DatabaseException {
        String sql = "SELECT * FROM Invoices WHERE Status <> 'PAID' ORDER BY Id";
        List<Invoice> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read overdue invoices: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Invoice> readAll() throws DatabaseException {
        String sql = "SELECT * FROM Invoices ORDER BY Id DESC";
        List<Invoice> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read invoices: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Invoice inv) throws DatabaseException {
        String sql = "UPDATE Invoices SET BookingId=?, TotalAmount=?, PaidAmount=?, Status=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, inv.getBookingId());
            ps.setDouble(2, inv.getTotalAmount());
            ps.setDouble(3, inv.getPaidAmount());
            ps.setString(4, inv.getStatus());
            ps.setInt(5, inv.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update invoice: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "DELETE FROM Invoices WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to delete invoice: " + e.getMessage(), e);
        }
    }

    private Invoice map(ResultSet rs) throws SQLException {
        return new Invoice(rs.getInt("Id"), rs.getInt("BookingId"), rs.getDouble("TotalAmount"),
                rs.getDouble("PaidAmount"), rs.getString("Status"));
    }
}
