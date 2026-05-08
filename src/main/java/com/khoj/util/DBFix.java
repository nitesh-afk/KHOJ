package com.khoj.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBFix {
    public static void main(String[] args) {
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement()) {
            System.out.println("Starting Database Alignment...");

            // 1. ROLES Table
            System.out.println("Checking roles table...");
            try {
                s.executeQuery("SELECT * FROM roles LIMIT 1");
            } catch (Exception ex) {
                System.out.println("Creating roles table...");
                s.executeUpdate("CREATE TABLE roles (role_id INT PRIMARY KEY, role_name VARCHAR(50))");
                s.executeUpdate("INSERT INTO roles (role_id, role_name) VALUES (1, 'ADMIN'), (2, 'LANDLORD'), (3, 'TENANT')");
            }

            // 2. USERS Table alignment
            System.out.println("Checking users table columns...");
            try {
                // Check for user_id vs id
                try { s.executeQuery("SELECT user_id FROM users LIMIT 1"); } 
                catch (Exception e) { 
                    System.out.println("Renaming users.id to user_id...");
                    s.executeUpdate("ALTER TABLE users CHANGE id user_id INT AUTO_INCREMENT"); 
                }

                // Check for phone_number vs phone
                try { s.executeQuery("SELECT phone_number FROM users LIMIT 1"); }
                catch (Exception e) {
                    System.out.println("Checking if 'phone' exists to rename to 'phone_number'...");
                    try {
                        s.executeQuery("SELECT phone FROM users LIMIT 1");
                        s.executeUpdate("ALTER TABLE users CHANGE phone phone_number VARCHAR(20)");
                    } catch (Exception e2) {
                        System.out.println("Adding phone_number column...");
                        s.executeUpdate("ALTER TABLE users ADD COLUMN phone_number VARCHAR(20)");
                    }
                }

                // Check for role_id vs role
                try { s.executeQuery("SELECT role_id FROM users LIMIT 1"); }
                catch (Exception e) {
                    System.out.println("Adding role_id to users...");
                    s.executeUpdate("ALTER TABLE users ADD COLUMN role_id INT DEFAULT 3");
                    // Try to migrate from 'role' enum if it exists
                    try {
                        s.executeUpdate("UPDATE users SET role_id = 1 WHERE role = 'ADMIN'");
                        s.executeUpdate("UPDATE users SET role_id = 2 WHERE role = 'LANDLORD'");
                        s.executeUpdate("UPDATE users SET role_id = 3 WHERE role = 'TENANT'");
                    } catch (Exception e3) { /* role column might not exist */ }
                }
                
                // Check for approved_status
                try { s.executeQuery("SELECT approved_status FROM users LIMIT 1"); }
                catch (Exception e) {
                    System.out.println("Adding approved_status to users...");
                    s.executeUpdate("ALTER TABLE users ADD COLUMN approved_status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'APPROVED'");
                }

            } catch (Exception ex) {
                System.err.println("Critical error aligning users table: " + ex.getMessage());
            }

            // 3. APPLICATIONS Table
            System.out.println("Checking applications table...");
            try {
                s.executeQuery("SELECT * FROM applications LIMIT 1");
            } catch (Exception ex) {
                System.out.println("Creating applications table...");
                s.executeUpdate("CREATE TABLE applications (" +
                        "app_id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "tenant_id INT, " +
                        "property_id INT, " +
                        "status ENUM('PENDING', 'ACCEPTED', 'REJECTED') DEFAULT 'PENDING', " +
                        "applied_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            }

            // 4. CONTACT MESSAGES Table
            System.out.println("Checking contact_messages table...");
            try {
                s.executeQuery("SELECT * FROM contact_messages LIMIT 1");
            } catch (Exception ex) {
                System.out.println("Creating contact_messages table...");
                s.executeUpdate("CREATE TABLE contact_messages (" +
                        "message_id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "full_name VARCHAR(100), " +
                        "email VARCHAR(100), " +
                        "subject VARCHAR(200), " +
                        "message TEXT, " +
                        "status ENUM('NEW', 'READ', 'ARCHIVED') DEFAULT 'NEW', " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            }

            // 5. WISHLIST Table
            System.out.println("Checking wishlist table...");
            try {
                s.executeQuery("SELECT * FROM wishlist LIMIT 1");
            } catch (Exception ex) {
                System.out.println("Creating wishlist table...");
                s.executeUpdate("CREATE TABLE wishlist (" +
                        "wishlist_id INT AUTO_INCREMENT PRIMARY KEY, " +
                        "user_id INT, " +
                        "property_id INT, " +
                        "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            }

            System.out.println("✅ Database Alignment Complete!");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
