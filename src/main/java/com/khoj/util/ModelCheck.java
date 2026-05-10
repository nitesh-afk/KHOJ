package com.khoj.util;

import com.khoj.util.DBConnection;
import java.sql.*;

public class ModelCheck {
    public static void main(String[] args) {
        String sql = "SELECT p.title, p.price_model, c.city_name " +
                     "FROM properties p " +
                     "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                     "JOIN cities c ON n.city_id = c.city_id " +
                     "WHERE c.city_name = 'Lumbini'";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            System.out.println("--- LUMBINI PROPERTIES PRICE MODEL ---");
            while (rs.next()) {
                System.out.println("Property: " + rs.getString("title"));
                System.out.println("Model: " + rs.getString("price_model"));
                System.out.println("--------------------------------");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
