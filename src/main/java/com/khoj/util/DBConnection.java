package com.khoj.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/khoj_db";
    private static final String USER = "root";
    private static final String PASSWORD = "12345678";

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load MySQL Driver explicitly
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
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