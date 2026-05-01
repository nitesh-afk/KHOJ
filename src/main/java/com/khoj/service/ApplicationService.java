package com.khoj.service;

import com.khoj.dao.ApplicationDAO;
import com.khoj.model.Application;
import java.util.List;

/**
 * Service class for handling Rental Application-related business logic.
 */
public class ApplicationService {
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    public boolean applyForProperty(int tenantId, int propertyId) {
        return applicationDAO.applyForProperty(tenantId, propertyId);
    }

    public List<Application> getApplicationsByLandlord(int landlordId) {
        return applicationDAO.getApplicationsByLandlord(landlordId);
    }

    public List<Application> getApplicationsByTenant(int tenantId) {
        return applicationDAO.getApplicationsByTenant(tenantId);
    }

    public boolean updateApplicationStatus(int appId, String status) {
        return applicationDAO.updateApplicationStatus(appId, status);
    }
}
