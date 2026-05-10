package com.khoj.util;

import java.sql.Connection;
import java.sql.Statement;

public class ProfileMigration {
    public static void main(String[] args) {
        String sql = "ALTER TABLE users ADD COLUMN profile_img VARCHAR(255) DEFAULT NULL AFTER status";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
            System.out.println("SUCCESS: profile_img column added to users table.");
        } catch (Exception e) {
            if (e.getMessage().contains("Duplicate column name")) {
                System.out.println("NOTE: profile_img column already exists.");
            } else {
                e.printStackTrace();
            }
        }
    }
}
