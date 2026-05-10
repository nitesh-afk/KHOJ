package com.khoj.util;

import com.khoj.util.DBConnection;
import java.sql.*;

public class SpaceCheck {
    public static void main(String[] args) {
        String sql = "SELECT city_name, LENGTH(city_name) as len FROM cities";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                System.out.println("City: [" + rs.getString("city_name") + "] | Length: " + rs.getInt("len"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
