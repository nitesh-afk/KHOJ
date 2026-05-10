package com.khoj.util;

import com.khoj.util.DBConnection;
import java.sql.*;

public class NeighCheck {
    public static void main(String[] args) {
        String sql = "SELECT * FROM neighborhoods WHERE city_id = 3";
        
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("neighborhood_id") + " | Name: [" + rs.getString("neighborhood_name") + "]");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
