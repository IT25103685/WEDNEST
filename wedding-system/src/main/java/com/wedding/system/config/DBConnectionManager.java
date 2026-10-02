package com.wedding.system.config;

import com.wedding.system.exception.DatabaseException;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Simple, single-purpose class that opens a JDBC Connection to MS SQL Server.
 * Kept deliberately plain (no connection pooling library) so it matches the
 * "Database Connectivity" module: driver loading, DriverManager, and
 * try/catch -> custom exception handling.
 *
 * Every Repository asks this class for a fresh Connection, uses it inside a
 * try-with-resources block, and lets the connection close automatically.
 */
@Component
public class DBConnectionManager {

    @Value("${db.url}")
    private String url;

    @Value("${db.username}")
    private String username;

    @Value("${db.password}")
    private String password;

    @Value("${db.driver}")
    private String driverClassName;

    public Connection getConnection() throws DatabaseException {
        try {
            Class.forName(driverClassName);
            return DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException e) {
            throw new DatabaseException("SQL Server JDBC driver not found on classpath.", e);
        } catch (SQLException e) {
            throw new DatabaseException("Could not connect to the database: " + e.getMessage(), e);
        }
    }
}
