package com.wedding.system.repository;

import com.wedding.system.config.DBConnectionManager;
import com.wedding.system.exception.DatabaseException;
import com.wedding.system.model.WeddingPackage;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

@Repository
public class WeddingPackageRepository implements com.wedding.system.repository.Repository<WeddingPackage, Integer> {

    private final DBConnectionManager db;

    public WeddingPackageRepository(DBConnectionManager db) {
        this.db = db;
    }

    @Override
    public void create(WeddingPackage p) throws DatabaseException {
        String sql = "INSERT INTO WeddingPackages (BookingId, Tier, Catering, Decoration, Photography, Music, TotalCost) VALUES (?,?,?,?,?,?,?)";
        try (Connection con = db.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            bind(ps, p);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) p.setId(keys.getInt(1));
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to create wedding package: " + e.getMessage(), e);
        }
    }

    @Override
    public WeddingPackage readById(Integer id) throws DatabaseException {
        String sql = "SELECT * FROM WeddingPackages WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read wedding package: " + e.getMessage(), e);
        }
    }

    public WeddingPackage readByBookingId(int bookingId) throws DatabaseException {
        String sql = "SELECT * FROM WeddingPackages WHERE BookingId = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read wedding package by booking: " + e.getMessage(), e);
        }
    }

    @Override
    public List<WeddingPackage> readAll() throws DatabaseException {
        String sql = "SELECT * FROM WeddingPackages ORDER BY Id";
        List<WeddingPackage> list = new ArrayList<>();
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
            return list;
        } catch (SQLException e) {
            throw new DatabaseException("Failed to read wedding packages: " + e.getMessage(), e);
        }
    }

    @Override
    public void update(WeddingPackage p) throws DatabaseException {
        String sql = "UPDATE WeddingPackages SET BookingId=?, Tier=?, Catering=?, Decoration=?, Photography=?, Music=?, TotalCost=? WHERE Id=?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            bind(ps, p);
            ps.setInt(8, p.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to update wedding package: " + e.getMessage(), e);
        }
    }

    @Override
    public void delete(Integer id) throws DatabaseException {
        String sql = "DELETE FROM WeddingPackages WHERE Id = ?";
        try (Connection con = db.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new DatabaseException("Failed to delete wedding package: " + e.getMessage(), e);
        }
    }

    private void bind(PreparedStatement ps, WeddingPackage p) throws SQLException {
        ps.setInt(1, p.getBookingId());
        ps.setString(2, p.getTier());
        ps.setBoolean(3, p.isCatering());
        ps.setBoolean(4, p.isDecoration());
        ps.setBoolean(5, p.isPhotography());
        ps.setBoolean(6, p.isMusic());
        ps.setDouble(7, p.getTotalCost());
    }

    private WeddingPackage map(ResultSet rs) throws SQLException {
        return new WeddingPackage(rs.getInt("Id"), rs.getInt("BookingId"), rs.getString("Tier"),
                rs.getBoolean("Catering"), rs.getBoolean("Decoration"), rs.getBoolean("Photography"),
                rs.getBoolean("Music"), rs.getDouble("TotalCost"));
    }
}
