package com.khoj.util;

import java.sql.Connection;
import java.sql.Statement;

public class VerifyAllProperties {
    public static void main(String[] args) {
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement()) {
            int rows = s.executeUpdate("UPDATE properties SET is_verified = TRUE");
            System.out.println("Verified " + rows + " properties.");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
