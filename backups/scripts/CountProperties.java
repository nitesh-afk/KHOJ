package com.khoj.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class CountProperties {
    public static void main(String[] args) {
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement()) {
            ResultSet rs = s.executeQuery("SELECT is_verified, count(*) FROM properties GROUP BY is_verified");
            while (rs.next()) {
                System.out.println("Verified: " + rs.getBoolean(1) + ", Count: " + rs.getInt(2));
            }
            
            ResultSet rs2 = s.executeQuery("SELECT count(*) FROM properties");
            if (rs2.next()) {
                System.out.println("Total Properties: " + rs2.getInt(1));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
