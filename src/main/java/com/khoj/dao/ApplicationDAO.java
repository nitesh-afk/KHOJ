package com.khoj.dao;

import com.khoj.model.Application;
import com.khoj.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    public boolean applyForRoom(int tenantId, int roomId) {
        String query = "INSERT INTO applications (tenant_id, room_id, status) VALUES (?, ?, 'PENDING')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, tenantId);
            pst.setInt(2, roomId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    /**
     * LANDLORD VIEW: Fetch students who applied for my rooms.
     */
    public List<Application> getApplicationsByLandlord(int landlordId) {
        List<Application> apps = new ArrayList<>();
        String query = "SELECT a.*, u.full_name AS student_name, u.email AS student_email, r.title AS room_title " +
                       "FROM applications a " +
                       "JOIN rooms r ON a.room_id = r.id " +
                       "JOIN users u ON a.tenant_id = u.user_id " +
                       "WHERE r.owner_id = ? " +
                       "ORDER BY a.app_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, landlordId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    apps.add(mapResultSetToApplication(rs, "student_name", "student_email", null, null));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return apps;
    }

    /**
     * STUDENT VIEW: Fetch my application statuses and landlord contact info.
     */
    public List<Application> getApplicationsByStudent(int studentId) {
        List<Application> apps = new ArrayList<>();
        String query = "SELECT a.*, r.title AS room_title, u.full_name AS landlord_name, u.email AS landlord_email " +
                       "FROM applications a " +
                       "JOIN rooms r ON a.room_id = r.id " +
                       "JOIN users u ON r.owner_id = u.user_id " +
                       "WHERE a.tenant_id = ? " +
                       "ORDER BY a.app_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, studentId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    apps.add(mapResultSetToApplication(rs, null, null, "landlord_name", "landlord_email"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return apps;
    }

    public boolean updateApplicationStatus(int appId, String status) {
        String query = "UPDATE applications SET status = ? WHERE app_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, status);
            pst.setInt(2, appId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    private Application mapResultSetToApplication(ResultSet rs, String sName, String sEmail, String lName, String lEmail) throws Exception {
        Application app = new Application();
        app.setAppId(rs.getInt("app_id"));
        app.setTenantId(rs.getInt("tenant_id"));
        app.setRoomId(rs.getInt("room_id"));
        app.setStatus(rs.getString("status"));
        app.setRoomTitle(rs.getString("room_title"));
        if (sName != null) app.setStudentName(rs.getString(sName));
        if (sEmail != null) app.setStudentEmail(rs.getString(sEmail));
        if (lName != null) app.setLandlordName(rs.getString(lName));
        if (lEmail != null) app.setLandlordEmail(rs.getString(lEmail));
        return app;
    }
}
