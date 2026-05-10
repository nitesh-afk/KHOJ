package com.khoj.dao;

import com.khoj.model.Message;
import com.khoj.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MessageDAO {

    /**
     * PRECISION SEND: Send message only if an application exists between these two parties for this property.
     */
    public boolean sendMessage(Message msg) throws SQLException {
        String checkQuery = "SELECT 1 FROM applications WHERE (tenant_id = ? OR tenant_id = ?) AND property_id = ?";
        String insertQuery = "INSERT INTO messages (sender_id, receiver_id, property_id, content) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            // Security Check
            try (PreparedStatement checkPst = conn.prepareStatement(checkQuery)) {
                checkPst.setInt(1, msg.getSenderId());
                checkPst.setInt(2, msg.getReceiverId());
                checkPst.setInt(3, msg.getPropertyId());
                try (ResultSet rs = checkPst.executeQuery()) {
                    if (!rs.next()) return false; // No application found
                }
            }

            // Insert Message
            try (PreparedStatement insertPst = conn.prepareStatement(insertQuery)) {
                insertPst.setInt(1, msg.getSenderId());
                insertPst.setInt(2, msg.getReceiverId());
                insertPst.setInt(3, msg.getPropertyId());
                insertPst.setString(4, msg.getContent());
                return insertPst.executeUpdate() > 0;
            }
        }
    }

    public List<Message> getConversation(int userId1, int userId2, int propertyId) throws SQLException {
        List<Message> messages = new ArrayList<>();
        String query = "SELECT m.*, u.full_name AS sender_name " +
                       "FROM messages m " +
                       "JOIN users u ON m.sender_id = u.user_id " +
                       "WHERE ((sender_id = ? AND receiver_id = ?) OR (sender_id = ? AND receiver_id = ?)) " +
                       "AND property_id = ? " +
                       "ORDER BY sent_at ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, userId1);
            pst.setInt(2, userId2);
            pst.setInt(3, userId2);
            pst.setInt(4, userId1);
            pst.setInt(5, propertyId);
            
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Message m = new Message();
                    m.setMessageId(rs.getInt("message_id"));
                    m.setSenderId(rs.getInt("sender_id"));
                    m.setReceiverId(rs.getInt("receiver_id"));
                    m.setPropertyId(rs.getInt("property_id"));
                    m.setContent(rs.getString("content"));
                    m.setSentAt(rs.getTimestamp("sent_at"));
                    m.setRead(rs.getBoolean("is_read"));
                    m.setSenderName(rs.getString("sender_name"));
                    messages.add(m);
                }
            }
        }
        return messages;
    }

    public List<Message> getInbox(int userId) throws SQLException {
        List<Message> inbox = new ArrayList<>();
        // Updated query to also count unread messages for this user in each thread
        String query = "SELECT m1.*, u.full_name AS other_user_name, p.title AS property_title, " +
                       "(SELECT COUNT(*) FROM messages WHERE receiver_id = ? AND property_id = m1.property_id AND is_read = FALSE) as unread_count " +
                       "FROM messages m1 " +
                       "JOIN (SELECT MAX(message_id) AS max_id FROM messages WHERE sender_id = ? OR receiver_id = ? GROUP BY property_id, IF(sender_id = ?, receiver_id, sender_id)) m2 " +
                       "ON m1.message_id = m2.max_id " +
                       "JOIN users u ON u.user_id = IF(m1.sender_id = ?, m1.receiver_id, m1.sender_id) " +
                       "JOIN properties p ON p.property_id = m1.property_id " +
                       "ORDER BY m1.sent_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, userId);
            pst.setInt(2, userId);
            pst.setInt(3, userId);
            pst.setInt(4, userId);
            pst.setInt(5, userId);
            
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Message m = new Message();
                    m.setMessageId(rs.getInt("message_id"));
                    int senderId = rs.getInt("sender_id");
                    m.setOtherUserId(senderId == userId ? rs.getInt("receiver_id") : senderId);
                    m.setOtherUserName(rs.getString("other_user_name"));
                    m.setPropertyId(rs.getInt("property_id"));
                    m.setPropertyTitle(rs.getString("property_title"));
                    m.setLastMessage(rs.getString("content"));
                    m.setSentAt(rs.getTimestamp("sent_at"));
                    m.setRead(rs.getInt("unread_count") == 0); // Consider "read" if no unread messages
                    m.setUnreadCount(rs.getInt("unread_count"));
                    inbox.add(m);
                }
            }
        }
        return inbox;
    }

    /**
     * MARK AS READ: Marks all unread messages for a specific user and property.
     */
    public void markMessagesAsRead(int receiverId, int propertyId) throws SQLException {
        String query = "UPDATE messages SET is_read = TRUE WHERE receiver_id = ? AND property_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, receiverId);
            pst.setInt(2, propertyId);
            pst.executeUpdate();
        }
    }

    public int getTotalUnreadCount(int userId) throws SQLException {
        String query = "SELECT COUNT(*) FROM messages WHERE receiver_id = ? AND is_read = FALSE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, userId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public void markAsRead(int receiverId, int senderId, int propertyId) throws SQLException {
        String query = "UPDATE messages SET is_read = TRUE WHERE receiver_id = ? AND sender_id = ? AND property_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, receiverId);
            pst.setInt(2, senderId);
            pst.setInt(3, propertyId);
            pst.executeUpdate();
        }
    }
}
