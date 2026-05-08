package com.khoj.service;

import com.khoj.dao.AdminDAO;
import com.khoj.model.User;
import java.util.List;
import java.util.Map;

/**
 * Service class for handling Administrative business logic.
 */
public class AdminService {
    private final AdminDAO adminDAO = new AdminDAO();

    public Map<String, Integer> getSystemSummary() {
        return adminDAO.getSystemSummary();
    }

    public boolean verifyProperty(int propertyId, boolean verified) {
        return adminDAO.verifyProperty(propertyId, verified);
    }

    public List<Map<String, Object>> getTopProperties(int limit) {
        return adminDAO.getTopProperties(limit);
    }

    public Map<String, Integer> getApplicationStatusBreakdown() {
        return adminDAO.getApplicationStatusBreakdown();
    }

    public List<Map<String, Object>> getMonthlyUserRegistrations() {
        return adminDAO.getMonthlyUserRegistrations();
    }

    public List<User> getPendingLandlords() {
        return adminDAO.getPendingLandlords();
    }

    public boolean approveLandlord(int userId) {
        return adminDAO.approveLandlord(userId);
    }

    public boolean rejectLandlord(int userId) {
        return adminDAO.rejectLandlord(userId);
    }

    public List<User> getTenants() {
        return adminDAO.getUsersByRole("TENANT");
    }

    public List<User> getLandlords() {
        return adminDAO.getUsersByRole("LANDLORD");
    }

    public boolean deactivateUser(int userId, String role) {
        if ("LANDLORD".equalsIgnoreCase(role)) {
            return adminDAO.deactivateLandlordAndProperties(userId);
        } else {
            return adminDAO.setUserStatus(userId, "INACTIVE");
        }
    }

    public boolean reactivateUser(int userId) {
        return adminDAO.setUserStatus(userId, "ACTIVE");
    }

    public boolean deleteUser(int userId) {
        return adminDAO.deleteUser(userId);
    }
}
