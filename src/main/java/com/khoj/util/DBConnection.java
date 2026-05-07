package com.khoj.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3307/khoj_db";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";
    
    // Static singleton connection instance
    private static Connection connection = null;

    /**
     * Thread-Safe Singleton Connection Provider
     */
    public static synchronized Connection getConnection() throws SQLException, ClassNotFoundException {
        // If connection is null or has been closed by the server, instantiate a new one
        if (connection == null || connection.isClosed()) {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("DEBUG [DBConnection]: New Physical DB Connection Established.");
        }
        return connection;
    }

    /**
     * STANDALONE TEST: Right-click and Run this 'main' method in IntelliJ 
     * to verify your DB connection before starting Tomcat.
     */
    public static void main(String[] args) {
        System.out.println("DEBUG [DBConnection]: Starting Standalone Connection Test...");
        try (Connection conn = getConnection()) {
            if (conn != null && !conn.isClosed()) {
                System.out.println("✅ SUCCESS: Connected to khoj_db successfully!");
            }
        } catch (Exception e) {
            System.err.println("❌ FAILURE: Could not connect to database.");
            System.err.println("Error Message: " + e.getMessage());
            e.printStackTrace();
        }
    }
}