package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.Vendor;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class VendorRepository implements com.wedding.system.repository.Repository<Vendor, Integer> {

    private final DBConnectionManager db;

    public VendorRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(Vendor v) throws DatabaseException {
        String sql = "INSERT INTO Vendors (UserId, CompanyName, Category, Status, ContractTerms, Rating) VALUES (?,?,?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bind(ps, v);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) v.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to create vendor: " + e.getMessage(), e);
        }
    }

    @Override
    public Vendor readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM Vendors WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read vendor: " + e.getMessage(), e);
        }
    }

    public Vendor readByUserId(int userId) throws DatabaseException {
        String sql = "SELECT * FROM Vendors WHERE UserId = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read vendor by user: " + e.getMessage(), e);
        }
    }

    public List<Vendor> readByStatus(String status) throws DatabaseException {
        String sql = "SELECT * FROM Vendors WHERE Status = ? ORDER BY Id";
        List<Vendor> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read vendors by status: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Vendor> readAll() throws DatabaseException {
        String sql = "SELECT * FROM Vendors ORDER BY Id";
        List<Vendor> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read vendors: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(Vendor v) throws DatabaseException {
        String sql = "UPDATE Vendors SET UserId=?, CompanyName=?, Category=?, Status=?, ContractTerms=?, Rating=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            bind(ps, v);
            ps.setInt(7, v.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update vendor: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "DELETE FROM Vendors WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to delete vendor: " + e.getMessage(), e);
        }
    }

    private void bind(PreparedStatement ps, Vendor v) throws SQLException {
        ps.setInt(1, v.getUserId());
        ps.setString(2, v.getCompanyName());
        ps.setString(3, v.getCategory());
        ps.setString(4, v.getStatus());
        ps.setString(5, v.getContractTerms());
        ps.setDouble(6, v.getRating());
    }

    private Vendor map(ResultSet rs) throws SQLException {
        return new Vendor(rs.getInt("Id"), rs.getInt("UserId"), rs.getString("CompanyName"),
                rs.getString("Category"), rs.getString("Status"), rs.getString("ContractTerms"),
                rs.getDouble("Rating"));
    }
}
