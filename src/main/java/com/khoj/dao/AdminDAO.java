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
     */
    public Map<String, Integer> getSystemSummary() {
        Map<String, Integer> stats = new HashMap<>();
        
        String usersQuery = "SELECT COUNT(*) FROM users";
        String roomsQuery = "SELECT COUNT(*) FROM rooms";
        String pendingQuery = "SELECT COUNT(*) FROM applications WHERE status = 'PENDING'";

        try (Connection conn = DBConnection.getConnection()) {
            stats.put("totalUsers", fetchCount(conn, usersQuery));
            stats.put("totalRooms", fetchCount(conn, roomsQuery));
            stats.put("pendingApps", fetchCount(conn, pendingQuery));
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

    public boolean updateRoomStatus(int roomId, boolean approved) {
        String query = "UPDATE rooms SET is_approved = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setBoolean(1, approved);
            pst.setInt(2, roomId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
