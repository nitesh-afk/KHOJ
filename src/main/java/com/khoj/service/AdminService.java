package com.khoj.service;

import com.khoj.dao.AdminDAO;
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
}
