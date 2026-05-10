package com.khoj.util;

import com.khoj.util.DBConnection;
import java.sql.*;

public class VerifyCheck {
    public static void main(String[] args) {
        String sql = "SELECT p.title, p.is_verified, c.city_name " +
                     "FROM properties p " +
                     "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                     "JOIN cities c ON n.city_id = c.city_id " +
                     "WHERE c.city_name = 'Lumbini'";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            System.out.println("--- LUMBINI PROPERTIES VERIFICATION ---");
            while (rs.next()) {
                System.out.println("Property: " + rs.getString("title"));
                System.out.println("Verified: " + rs.getBoolean("is_verified"));
                System.out.println("--------------------------------");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
