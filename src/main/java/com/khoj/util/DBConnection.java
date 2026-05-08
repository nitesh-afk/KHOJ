package com.khoj.util;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

/**
 * Enterprise-Grade Database Connection Provider using HikariCP.
 * Optimized for high-concurrency and production stability.
 */
public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3307/khoj_db"; 
    private static final String USER = "root";
    private static final String PASSWORD = "1234"; 
    
    private static final HikariDataSource dataSource;

    static {
        // Configure HikariCP Connection Pool
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(URL);
        config.setUsername(USER);
        config.setPassword(PASSWORD);
        config.setDriverClassName("com.mysql.cj.jdbc.Driver");

        // Pool Optimization Settings
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.setMaximumPoolSize(10); // Adjust based on your server resources
        config.setMinimumIdle(2);
        config.setIdleTimeout(30000);
        config.setConnectionTimeout(20000);

        dataSource = new HikariDataSource(config);
    }

    /**
     * Returns a healthy connection from the pool.
     * Note: Calling conn.close() on this object returns it to the pool, doesn't kill it.
     */
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }

    /**
     * STANDALONE TEST: Verifies the Hikari Pool is active.
     */
    public static void main(String[] args) {
        System.out.println("DEBUG [DBConnection]: Testing HikariCP Pool...");
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ POOL ACTIVE: Hikari successfully connected to khoj_db!");
            }
        } catch (Exception e) {
            System.err.println("❌ POOL FAILURE: Could not establish connection.");
            e.printStackTrace();
        }
    }
}