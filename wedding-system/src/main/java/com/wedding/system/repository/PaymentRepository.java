package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Payment;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class PaymentRepository implements com.wedding.system.repository.Repository<Payment, Integer> {

    private final DBConnectionManager db;

    public PaymentRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(Payment p) throws DatabaseException {
        String sql = "INSERT INTO Payments (InvoiceId, Amount, Method, PaymentDate) VALUES (?,?,?,SYSDATETIME())";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getInvoiceId());
            ps.setDouble(2, p.getAmount());
            ps.setString(3, p.getMethod());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) p.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to record payment: " + e.getMessage(), e);
        }
    }

    @Override
    public Payment readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM Payments WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read payment: " + e.getMessage(), e);
        }
    }

    public List<Payment> readByInvoiceId(int invoiceId) throws DatabaseException {
        String sql = "SELECT * FROM Payments WHERE InvoiceId = ? ORDER BY PaymentDate";
        List<Payment> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read payments for invoice: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Payment> readAll() throws DatabaseException {
        String sql = "SELECT * FROM Payments ORDER BY Id DESC";
        List<Payment> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read payments: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Payment p) throws DatabaseException {
        String sql = "UPDATE Payments SET InvoiceId=?, Amount=?, Method=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, p.getInvoiceId());
            ps.setDouble(2, p.getAmount());
            ps.setString(3, p.getMethod());
            ps.setInt(4, p.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update payment: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "DELETE FROM Payments WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to delete payment: " + e.getMessage(), e);
        }
    }

    private Payment map(ResultSet rs) throws SQLException {
        return new Payment(rs.getInt("Id"), rs.getInt("InvoiceId"), rs.getDouble("Amount"),
                rs.getString("Method"), rs.getTimestamp("PaymentDate"));
    }
}
