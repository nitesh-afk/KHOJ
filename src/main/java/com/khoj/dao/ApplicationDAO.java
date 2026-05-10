package com.khoj.dao;

import com.khoj.model.Application;
import com.khoj.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDAO {

    /**
     * PRECISION LOGIC GATE: Apply for a property only if no application exists.
     * Returns: 1 if success, 0 if already exists.
     * @throws SQLException for real database failures.
     */
    public int applyForProperty(int tenantId, int propertyId) throws SQLException {
        String query = "INSERT INTO applications (tenant_id, property_id, status) " +
                       "SELECT ?, ?, 'PENDING' FROM (SELECT 1) AS dummy " +
                       "WHERE NOT EXISTS ( " +
                       "    SELECT 1 FROM applications WHERE tenant_id = ? AND property_id = ? " +
                       ") LIMIT 1";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, tenantId);
            pst.setInt(2, propertyId);
            pst.setInt(3, tenantId);
            pst.setInt(4, propertyId);
            
            return pst.executeUpdate(); // 1 if inserted, 0 if WHERE NOT EXISTS blocked it
        }
    }

    public boolean hasApplied(int tenantId, int propertyId) {
        String query = "SELECT 1 FROM applications WHERE tenant_id = ? AND property_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, tenantId);
            pst.setInt(2, propertyId);
            try (ResultSet rs = pst.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * LANDLORD VIEW: Fetch students who applied for my rooms.
     */
    public List<Application> getApplicationsByLandlord(int landlordId) {
        List<Application> apps = new ArrayList<>();
        String query = "SELECT a.*, u.full_name AS tenant_name, u.email AS tenant_email, p.title AS property_title " +
                       "FROM applications a " +
                       "JOIN properties p ON a.property_id = p.property_id " +
                       "JOIN users u ON a.tenant_id = u.user_id " +
                       "WHERE p.landlord_id = ? " +
                       "ORDER BY a.app_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, landlordId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    apps.add(mapResultSetToApplication(rs, "tenant_name", "tenant_email", null, null));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return apps;
    }

    /**
     * STUDENT VIEW: Fetch my application statuses and landlord contact info.
     */
    public List<Application> getApplicationsByTenant(int tenantId) {
        List<Application> apps = new ArrayList<>();
        String query = "SELECT a.*, p.title AS property_title, u.full_name AS landlord_name, u.email AS landlord_email " +
                       "FROM applications a " +
                       "JOIN properties p ON a.property_id = p.property_id " +
                       "JOIN users u ON p.landlord_id = u.user_id " +
                       "WHERE a.tenant_id = ? " +
                       "ORDER BY a.app_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, tenantId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    apps.add(mapResultSetToApplication(rs, null, null, "landlord_name", "landlord_email"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return apps;
    }

    /**
     * SIMPLE UPDATE: Updates status without landlord verification (Use with caution).
     */
    public boolean updateApplicationStatus(int appId, String status) {
        String query = "UPDATE applications SET status = ? WHERE app_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, status);
            pst.setInt(2, appId);
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * PRECISION UPDATE: Only update status if current status is PENDING and landlord owns the property.
     */
    public boolean updateApplicationStatusPrecise(int appId, String newStatus, int landlordId) throws SQLException {
        String query = "UPDATE applications a " +
                       "JOIN properties p ON a.property_id = p.property_id " +
                       "SET a.status = ? " +
                       "WHERE a.app_id = ? AND a.status = 'PENDING' AND p.landlord_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, newStatus);
            pst.setInt(2, appId);
            pst.setInt(3, landlordId);
            
            boolean updated = pst.executeUpdate() > 0;
            
            // Logic Check: If accepted, mark property as RENTED (if schema allows)
            if (updated && "ACCEPTED".equalsIgnoreCase(newStatus)) {
                markPropertyAsRented(appId, conn);
            }
            
            return updated;
        }
    }

    private void markPropertyAsRented(int appId, Connection conn) {
        // We'll attempt to update a 'status' or 'availability' column if it exists
        // Given our schema audit, we might need to add it first.
        String query = "UPDATE properties p " +
                       "JOIN applications a ON p.property_id = a.property_id " +
                       "SET p.availability_status = 'RENTED' " +
                       "WHERE a.app_id = ?";
        try (PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setInt(1, appId);
            pst.executeUpdate();
        } catch (SQLException e) {
            // If column doesn't exist, this fails silently or we handle it
            System.err.println("Property availability column not found or update failed: " + e.getMessage());
        }
    }

    private Application mapResultSetToApplication(ResultSet rs, String tName, String tEmail, String lName, String lEmail) throws SQLException {
        Application app = new Application();
        app.setAppId(rs.getInt("app_id"));
        app.setTenantId(rs.getInt("tenant_id"));
        app.setPropertyId(rs.getInt("property_id"));
        app.setStatus(rs.getString("status"));
        app.setPropertyTitle(rs.getString("property_title"));
        app.setAppliedAt(rs.getString("applied_at"));
        if (tName != null) app.setTenantName(rs.getString(tName));
        if (tEmail != null) app.setTenantEmail(rs.getString(tEmail));
        if (lName != null) app.setLandlordName(rs.getString(lName));
        if (lEmail != null) app.setLandlordEmail(rs.getString(lEmail));
        return app;
    }
}
