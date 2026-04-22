package com.khoj.dao;

import com.khoj.model.Room;
import com.khoj.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RoomDAO {

    public boolean addRoom(Room room) {
        String query = "INSERT INTO rooms (owner_id, title, description, location, price, room_type, image_url, status, is_approved) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, room.getOwnerId());
            pst.setString(2, room.getTitle());
            pst.setString(3, room.getDescription());
            pst.setString(4, room.getLocation());
            pst.setDouble(5, room.getPrice());
            pst.setString(6, room.getRoomType());
            pst.setString(7, room.getImageUrl());
            pst.setString(8, room.getStatus() != null ? room.getStatus() : "Available");
            pst.setBoolean(9, false); // Default to unapproved
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public List<Room> getRoomsByOwner(int ownerId) {
        List<Room> rooms = new ArrayList<>();
        String query = "SELECT * FROM rooms WHERE owner_id = ? ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, ownerId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return rooms;
    }

    public List<Room> searchRooms(String queryText) {
        List<Room> rooms = new ArrayList<>();
        // SECURE FILTER: Only show approved rooms
        String sql = "SELECT * FROM rooms WHERE (location LIKE ? OR room_type LIKE ?) AND status = 'Available' AND is_approved = TRUE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            String searchPattern = "%" + queryText + "%";
            pst.setString(1, searchPattern);
            pst.setString(2, searchPattern);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    rooms.add(mapResultSetToRoom(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return rooms;
    }

    public Room getRoomById(int roomId) {
        String query = "SELECT * FROM rooms WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, roomId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) return mapResultSetToRoom(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // --- ADMIN METHODS ---

    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String query = "SELECT * FROM rooms ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                rooms.add(mapResultSetToRoom(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return rooms;
    }

    public boolean updateRoomApproval(int roomId, boolean approved) {
        String query = "UPDATE rooms SET is_approved = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setBoolean(1, approved);
            pst.setInt(2, roomId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public int getGlobalRoomCount() {
        String query = "SELECT COUNT(*) FROM rooms";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public int getRoomCount(int ownerId, String status) {
        String query = "SELECT COUNT(*) FROM rooms WHERE owner_id = ?" + (status != null ? " AND status = ?" : "");
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, ownerId);
            if (status != null) pst.setString(2, status);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    private Room mapResultSetToRoom(ResultSet rs) throws Exception {
        return new Room(
            rs.getInt("id"),
            rs.getInt("owner_id"),
            rs.getString("title"),
            rs.getString("description"),
            rs.getString("location"),
            rs.getDouble("price"),
            rs.getString("room_type"),
            rs.getString("image_url"),
            rs.getString("status"),
            rs.getBoolean("is_approved")
        );
    }
}
