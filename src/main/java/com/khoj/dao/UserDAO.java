package com.khoj.dao;

import com.khoj.model.User;
import com.khoj.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User getUserByEmail(String email) {
        String query = "SELECT u.*, r.role_name FROM users u " +
                       "JOIN roles r ON u.role_id = r.role_id " +
                       "WHERE u.email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, email);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("role_name"),
                        rs.getString("status")
                    );
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean registerUser(User user) {
        String query = "INSERT INTO users (full_name, email, password, role_id, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, user.getFullName());
            pst.setString(2, user.getEmail());
            pst.setString(3, user.getPassword());
            pst.setInt(4, getRoleIdByName(user.getRole()));
            pst.setString(5, user.getStatus() != null ? user.getStatus() : "ACTIVE");
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public User loginUser(String email, String plainPassword) {
        String query = "SELECT u.*, r.role_name FROM users u " +
                       "JOIN roles r ON u.role_id = r.role_id " +
                       "WHERE u.email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, email);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    
                    // Verify hashed password using BCrypt
                    if (com.khoj.util.SecurityUtil.verifyPassword(plainPassword, hashedPassword)) {
                        return new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            hashedPassword,
                            rs.getString("role_name"),
                            rs.getString("status")
                        );
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT u.*, r.role_name FROM users u " +
                       "JOIN roles r ON u.role_id = r.role_id " +
                       "WHERE r.role_name != 'ADMIN' ORDER BY u.user_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                users.add(new User(
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    null,
                    rs.getString("role_name"),
                    rs.getString("status")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return users;
    }

    public boolean deleteUser(int userId) {
        String query = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, userId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateUserStatus(int userId, String status) {
        String query = "UPDATE users SET status = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, status);
            pst.setInt(2, userId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    private int getRoleIdByName(String roleName) {
        if ("ADMIN".equalsIgnoreCase(roleName)) return 1;
        if ("LANDLORD".equalsIgnoreCase(roleName)) return 2;
        if ("TENANT".equalsIgnoreCase(roleName)) return 3;
        return 3; 
    }
}