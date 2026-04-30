package com.khoj.dao;

import com.khoj.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class AdminDAO {

    /**
     * ADVANCED STATS: Fetches global system summary using aggregate functions.
     * Updated for 3NF Schema.
     */
    public Map<String, Integer> getSystemSummary() {
        Map<String, Integer> stats = new HashMap<>();
        
        String usersQuery = "SELECT COUNT(*) FROM users";
        String propertiesQuery = "SELECT COUNT(*) FROM properties";
        String pendingAppsQuery = "SELECT COUNT(*) FROM applications WHERE status = 'PENDING'";

        try (Connection conn = DBConnection.getConnection()) {
            stats.put("totalUsers", fetchCount(conn, usersQuery));
            stats.put("totalProperties", fetchCount(conn, propertiesQuery));
            stats.put("pendingApps", fetchCount(conn, pendingAppsQuery));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return stats;
    }

    private int fetchCount(Connection conn, String query) throws Exception {
        try (PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        }
        return 0;
    }

    /**
     * Updates property verification status.
     */
    public boolean verifyProperty(int propertyId, boolean verified) {
        String query = "UPDATE properties SET is_verified = ? WHERE property_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setBoolean(1, verified);
            pst.setInt(2, propertyId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
