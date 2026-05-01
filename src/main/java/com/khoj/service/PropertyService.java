package com.khoj.service;

import com.khoj.dao.PropertyDAO;
import com.khoj.model.Property;
import com.khoj.model.PropertyType;
import com.khoj.model.Theme;
import java.util.List;

/**
 * Service class for handling Property-related business logic.
 */
public class PropertyService {
    private final PropertyDAO propertyDAO = new PropertyDAO();

    public Property getPropertyById(int propertyId) {
        return propertyDAO.getPropertyById(propertyId);
    }

    public List<Property> getPropertiesByTheme(String themeName) {
        return propertyDAO.getPropertiesByTheme(themeName);
    }

    public List<Property> searchProperties(String location, String type, String priceModel) {
        return propertyDAO.searchProperties(location, type, priceModel);
    }

    public List<Property> getPropertiesByLandlord(int landlordId) {
        return propertyDAO.getPropertiesByLandlord(landlordId);
    }

    public int getPropertyCount(int landlordId) {
        return propertyDAO.getPropertyCount(landlordId);
    }

    /**
     * Adds a property with necessary neighborhood resolution.
     */
    public int addProperty(Property property, String locationName) {
        // Resolve neighborhood (Business Logic: converting text to ID)
        int neighborhoodId = propertyDAO.getOrCreateNeighborhood(locationName);
        if (neighborhoodId == -1) {
            neighborhoodId = propertyDAO.getAnyNeighborhoodId();
        }
        property.setNeighborhoodId(neighborhoodId);
        
        return propertyDAO.addProperty(property);
    }

    public boolean addPropertyImage(int propertyId, String imageUrl, boolean isPrimary) {
        return propertyDAO.addPropertyImage(propertyId, imageUrl, isPrimary);
    }

    public boolean addPropertyAmenity(int propertyId, int amenityId) {
        return propertyDAO.addPropertyAmenity(propertyId, amenityId);
    }

    public List<Property> getAllProperties() {
        return propertyDAO.getAllProperties();
    }

    public List<Theme> getAllThemes() {
        return propertyDAO.getAllThemes();
    }

    public List<Property> getVerifiedProperties(int limit) {
        return propertyDAO.getVerifiedProperties(limit);
    }

    public List<PropertyType> getAllPropertyTypes() {
        return propertyDAO.getAllPropertyTypes();
    }
}
