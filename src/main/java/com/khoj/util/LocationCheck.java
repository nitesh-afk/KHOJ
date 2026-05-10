package com.khoj.util;

import com.khoj.util.DBConnection;
import java.sql.*;

public class LocationCheck {
    public static void main(String[] args) {
        String sql = "SELECT p.title, n.neighborhood_name, c.city_name " +
                     "FROM properties p " +
                     "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                     "JOIN cities c ON n.city_id = c.city_id";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            System.out.println("--- CURRENT PROPERTY LOCATIONS ---");
            while (rs.next()) {
                System.out.println("Property: " + rs.getString("title"));
                System.out.println("Location: " + rs.getString("neighborhood_name") + ", " + rs.getString("city_name"));
                System.out.println("--------------------------------");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
