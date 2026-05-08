package com.khoj.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import com.khoj.model.User;
import com.khoj.util.DBConnection;

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

    /**
     * Admin: Fetches all contact messages.
     */
    public java.util.List<com.khoj.model.Message> getAllMessages() {
        java.util.List<com.khoj.model.Message> messages = new java.util.ArrayList<>();
        String query = "SELECT * FROM contact_messages ORDER BY message_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                com.khoj.model.Message msg = new com.khoj.model.Message();
                msg.setId(rs.getInt("message_id"));
                msg.setFullName(rs.getString("full_name"));
                msg.setEmail(rs.getString("email"));
                msg.setSubject(rs.getString("subject"));
                msg.setMessageBody(rs.getString("message"));
                msg.setStatus(rs.getString("status"));
                msg.setCreatedAt(rs.getString("created_at"));
                messages.add(msg);
            }
        } catch (Exception e) {
            System.err.println("ERROR AdminDAO: contact_messages table might not exist yet.");
            e.printStackTrace();
        }
        return messages;
    }

    /**
     * Admin: Update message status (e.g. ARCHIVED)
     */
    public boolean updateMessageStatus(int messageId, String status) {
        String query = "UPDATE contact_messages SET status = ? WHERE message_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, status);
            pst.setInt(2, messageId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Admin: Fetches a single message by ID.
     */
    public com.khoj.model.Message getMessageById(int messageId) {
        String query = "SELECT * FROM contact_messages WHERE message_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, messageId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    com.khoj.model.Message msg = new com.khoj.model.Message();
                    msg.setId(rs.getInt("message_id"));
                    msg.setFullName(rs.getString("full_name"));
                    msg.setEmail(rs.getString("email"));
                    msg.setSubject(rs.getString("subject"));
                    msg.setMessageBody(rs.getString("message"));
                    msg.setStatus(rs.getString("status"));
                    msg.setCreatedAt(rs.getString("created_at"));
                    return msg;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Admin: Marks a message as READ only if it is currently NEW.
     */
    public void markAsReadIfNew(int messageId) {
        String query = "UPDATE contact_messages SET status = 'READ' WHERE message_id = ? AND status = 'NEW'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, messageId);
            pst.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<Map<String, Object>> getTopProperties(int limit) {
        List<Map<String, Object>> topProperties = new ArrayList<>();
        String query = "SELECT p.title, COUNT(a.app_id) as app_count "
                + "FROM properties p "
                + "LEFT JOIN applications a ON p.property_id = a.property_id "
                + "GROUP BY p.property_id "
                + "ORDER BY app_count DESC "
                + "LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, limit);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    row.put("propertyTitle", rs.getString("title"));
                    row.put("applicationCount", rs.getInt("app_count"));
                    topProperties.add(row);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return topProperties;
    }

    public Map<String, Integer> getApplicationStatusBreakdown() {
        Map<String, Integer> breakdown = new LinkedHashMap<>();
        breakdown.put("PENDING", 0);
        breakdown.put("ACCEPTED", 0);
        breakdown.put("REJECTED", 0);

        String query = "SELECT status, COUNT(*) as status_count "
                + "FROM applications "
                + "GROUP BY status";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("status_count");
                if (breakdown.containsKey(status)) {
                    breakdown.put(status, count);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return breakdown;
    }

    public List<Map<String, Object>> getMonthlyUserRegistrations() {
        List<Map<String, Object>> monthlyRegistrations = new ArrayList<>();
        String query = "SELECT DATE_FORMAT(created_at, '%Y-%m') as month, COUNT(*) as user_count "
                + "FROM users "
                + "WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) "
                + "GROUP BY DATE_FORMAT(created_at, '%Y-%m') "
                + "ORDER BY month ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("month", rs.getString("month"));
                row.put("userCount", rs.getInt("user_count"));
                monthlyRegistrations.add(row);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return monthlyRegistrations;
    }

    public List<User> getPendingLandlords() {
        List<User> pendingLandlords = new ArrayList<>();
        String query = "SELECT u.user_id, u.full_name, u.email, u.password, u.approved_status, r.role_name "
                + "FROM users u JOIN roles r ON u.role_id = r.role_id "
                + "WHERE r.role_name = 'LANDLORD' AND u.approved_status = 'PENDING'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role_name"));
                user.setStatus(rs.getString("approved_status"));
                pendingLandlords.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return pendingLandlords;
    }

    public boolean approveLandlord(int userId) {
        String query = "UPDATE users SET approved_status = 'APPROVED' WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, userId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectLandlord(int userId) {
        String query = "UPDATE users SET approved_status = 'REJECTED' WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, userId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> getUsersByRole(String roleName) {
        List<User> users = new ArrayList<>();
        String query = "SELECT u.user_id, u.full_name, u.email, u.status, r.role_name " +
                       "FROM users u " +
                       "JOIN roles r ON u.role_id = r.role_id " +
                       "WHERE r.role_name = ? " +
                       "ORDER BY u.user_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, roleName);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setStatus(rs.getString("status"));
                    user.setRole(rs.getString("role_name"));
                    users.add(user);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return users;
    }

    public boolean setUserStatus(int userId, String status) {
        String query = "UPDATE users SET status = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, status);
            pst.setInt(2, userId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deactivateLandlordAndProperties(int landlordId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // 1. Deactivate User
            String updateUser = "UPDATE users SET status = 'INACTIVE' WHERE user_id = ?";
            try (PreparedStatement pst1 = conn.prepareStatement(updateUser)) {
                pst1.setInt(1, landlordId);
                pst1.executeUpdate();
            }

            // 2. Unpublish all properties (approved=false/is_verified=false)
            // Using 'is_verified' as established in PropertyDAO
            String updateProps = "UPDATE properties SET is_verified = FALSE WHERE landlord_id = ?";
            try (PreparedStatement pst2 = conn.prepareStatement(updateProps)) {
                pst2.setInt(1, landlordId);
                pst2.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    public boolean deleteUser(int userId) {
        String query = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, userId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}
