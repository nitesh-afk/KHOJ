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
                       "LEFT JOIN roles r ON u.role_id = r.role_id " +
                       "WHERE u.email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, email);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    User user = new User(
                        rs.getInt("user_id"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("password"),
                        rs.getString("role_name"),
                        rs.getString("status")
                    );
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setApprovalStatus(rs.getString("approved_status"));
                    user.setCreatedAt(rs.getString("created_at"));
                    return user;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean registerUser(User user) {
        String query = "INSERT INTO users (full_name, email, password, phone_number, role_id, status, approved_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, user.getFullName());
            pst.setString(2, user.getEmail());
            pst.setString(3, user.getPassword());
            pst.setString(4, user.getPhoneNumber());
            pst.setInt(5, getRoleIdByName(user.getRole()));
            pst.setString(6, user.getStatus() != null ? user.getStatus() : "ACTIVE");
            String appr = user.getApprovalStatus();
            pst.setString(7, (appr != null && !appr.isEmpty()) ? appr : "APPROVED");
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    /**
     * @return true if another user already uses this phone number (non-blank).
     */
    public boolean isPhoneTaken(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return false;
        }
        String query = "SELECT 1 FROM users WHERE phone_number = ? LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, phone.trim());
            try (ResultSet rs = pst.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public User loginUser(String email, String plainPassword) {
        String query = "SELECT u.*, r.role_name FROM users u " +
                       "LEFT JOIN roles r ON u.role_id = r.role_id " +
                       "WHERE u.email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, email);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    
                    // Verify hashed password using BCrypt
                    if (com.khoj.util.SecurityUtil.verifyPassword(plainPassword, hashedPassword)) {
                        User u = new User(
                            rs.getInt("user_id"),
                            rs.getString("full_name"),
                            rs.getString("email"),
                            hashedPassword,
                            rs.getString("role_name"),
                            rs.getString("status")
                        );
                        u.setPhoneNumber(rs.getString("phone_number"));
                        u.setApprovalStatus(rs.getString("approved_status"));
                        u.setCreatedAt(rs.getString("created_at"));
                        return u;
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String query = "SELECT u.*, r.role_name FROM users u " +
                       "LEFT JOIN roles r ON u.role_id = r.role_id " +
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

    public boolean updateUserProfile(User user) {
        String duplicateCheckQuery = "SELECT 1 FROM users WHERE email = ? AND user_id <> ? LIMIT 1";
        String updateQuery = "UPDATE users SET full_name = ?, email = ?, phone_number = ?, profile_img = ? WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement duplicatePst = conn.prepareStatement(duplicateCheckQuery)) {
                duplicatePst.setString(1, user.getEmail());
                duplicatePst.setInt(2, user.getId());
                try (ResultSet rs = duplicatePst.executeQuery()) {
                    if (rs.next()) {
                        return false;
                    }
                }
            }

            try (PreparedStatement updatePst = conn.prepareStatement(updateQuery)) {
                updatePst.setString(1, user.getFullName());
                updatePst.setString(2, user.getEmail());
                updatePst.setString(3, user.getPhoneNumber());
                updatePst.setString(4, user.getProfileImg());
                updatePst.setInt(5, user.getId());
                return updatePst.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updatePassword(int userId, String newHashedPassword) {
        String query = "UPDATE users SET password = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, newHashedPassword);
            pst.setInt(2, userId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserById(int userId) {
        String query = "SELECT u.*, r.role_name FROM users u "
                + "LEFT JOIN roles r ON u.role_id = r.role_id "
                + "WHERE u.user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, userId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setId(rs.getInt("user_id"));
                    user.setFullName(rs.getString("full_name"));
                    user.setEmail(rs.getString("email"));
                    user.setPhoneNumber(rs.getString("phone_number"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role_name"));
                    user.setStatus(rs.getString("status"));
                    user.setProfileImg(rs.getString("profile_img"));
                    user.setApprovalStatus(rs.getString("approved_status"));
                    user.setCreatedAt(rs.getString("created_at"));
                    return user;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private int getRoleIdByName(String roleName) {
        if ("ADMIN".equalsIgnoreCase(roleName)) return 1;
        if ("LANDLORD".equalsIgnoreCase(roleName)) return 2;
        if ("TENANT".equalsIgnoreCase(roleName)) return 3;
        return 3; 
    }
}