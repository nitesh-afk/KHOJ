package com.khoj.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class CheckWishlistTable {
    public static void main(String[] args) {
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement()) {
            s.executeQuery("SELECT * FROM wishlist LIMIT 1");
            System.out.println("✅ wishlist table exists.");
        } catch (Exception e) {
            System.err.println("❌ wishlist table error: " + e.getMessage());
        }
    }
}
