package com.khoj.util;

import com.khoj.util.DBConnection;
import java.sql.*;

public class CityCheck {
    public static void main(String[] args) {
        String sql = "SELECT * FROM cities";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            System.out.println("--- CITIES IN DATABASE ---");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("city_id") + " | Name: " + rs.getString("city_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
