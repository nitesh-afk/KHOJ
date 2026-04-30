package com.khoj.dao;

import com.khoj.model.Property;
import com.khoj.model.PropertyType;
import com.khoj.model.Theme;
import com.khoj.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class PropertyDAO {

    /**
     * Query 1: Fetches a single property by ID with all relational data joined.
     */
    public Property getPropertyById(int propertyId) {
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name " +
                     "FROM properties p " +
                     "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                     "JOIN cities c ON n.city_id = c.city_id " +
                     "JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                     "JOIN property_types pt ON p.type_id = pt.type_id " +
                     "JOIN users u ON p.landlord_id = u.user_id " +
                     "WHERE p.property_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            
            pst.setInt(1, propertyId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    Property property = extractPropertyFromResultSet(rs);
                    property.setAmenities(getAmenitiesForProperty(propertyId));
                    property.setImageUrls(getImagesForProperty(propertyId));
                    return property;
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Query 2: Fetches amenities for a specific property.
     */
    public List<String> getAmenitiesForProperty(int propertyId) {
        List<String> amenities = new ArrayList<>();
        String sql = "SELECT a.amenity_name " +
                     "FROM property_amenities pa " +
                     "JOIN amenities a ON pa.amenity_id = a.amenity_id " +
                     "WHERE pa.property_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            
            pst.setInt(1, propertyId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    amenities.add(rs.getString("amenity_name"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return amenities;
    }

    /**
     * Query 3: Fetches all image URLs for a specific property.
     */
    public List<String> getImagesForProperty(int propertyId) {
        List<String> images = new ArrayList<>();
        String sql = "SELECT image_url FROM property_images WHERE property_id = ? ORDER BY is_primary DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            
            pst.setInt(1, propertyId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getString("image_url"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return images;
    }

    /**
     * Query 4: Fetches properties categorized by theme name.
     */
    public List<Property> getPropertiesByTheme(String themeName) {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name " +
                     "FROM properties p " +
                     "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                     "JOIN cities c ON n.city_id = c.city_id " +
                     "JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                     "JOIN property_types pt ON p.type_id = pt.type_id " +
                     "JOIN users u ON p.landlord_id = u.user_id " +
                     "WHERE dt.theme_name = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            
            pst.setString(1, themeName);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Property p = extractPropertyFromResultSet(rs);
                    // For performance in list views, we often fetch amenities/images separately or lazily,
                    // but for this phase, we ensure the DTO is fully populated as per requirements.
                    p.setAmenities(getAmenitiesForProperty(p.getPropertyId()));
                    p.setImageUrls(getImagesForProperty(p.getPropertyId()));
                    properties.add(p);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return properties;
    }

    /**
     * Private helper to map a ResultSet row to a Property object.
     */
    private Property extractPropertyFromResultSet(ResultSet rs) throws SQLException {
        Property property = new Property();
        property.setPropertyId(rs.getInt("property_id"));
        property.setLandlordId(rs.getInt("landlord_id"));
        property.setNeighborhoodId(rs.getInt("neighborhood_id"));
        property.setTypeId(rs.getInt("type_id"));
        property.setTitle(rs.getString("title"));
        property.setDescription(rs.getString("description"));
        property.setPrice(rs.getDouble("price"));
        property.setPriceModel(rs.getString("price_model"));
        property.setFurnishingStatus(rs.getString("furnishing_status"));
        property.setVerified(rs.getBoolean("is_verified"));
        property.setCreatedAt(rs.getString("created_at"));
        
        // Joined Fields
        property.setNeighborhoodName(rs.getString("neighborhood_name"));
        property.setCityName(rs.getString("city_name"));
        property.setThemeName(rs.getString("theme_name"));
        property.setPropertyType(rs.getString("type_name"));
        property.setLandlordName(rs.getString("landlord_name"));
        
        return property;
    }

    /**
     * Advanced Search: Fetches properties based on location, type, and price model.
     */
    public List<Property> searchProperties(String location, String type, String priceModel) {
        List<Property> properties = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name " +
            "FROM properties p " +
            "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
            "JOIN cities c ON n.city_id = c.city_id " +
            "JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
            "JOIN property_types pt ON p.type_id = pt.type_id " +
            "JOIN users u ON p.landlord_id = u.user_id " +
            "WHERE 1=1 "
        );

        if (location != null && !location.isEmpty()) sql.append("AND (c.city_name LIKE ? OR n.neighborhood_name LIKE ?) ");
        if (type != null && !type.isEmpty()) sql.append("AND pt.type_name = ? ");
        if (priceModel != null && !priceModel.isEmpty()) sql.append("AND p.price_model = ? ");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (location != null && !location.isEmpty()) {
                String locPattern = "%" + location + "%";
                pst.setString(paramIndex++, locPattern);
                pst.setString(paramIndex++, locPattern);
            }
            if (type != null && !type.isEmpty()) pst.setString(paramIndex++, type);
            if (priceModel != null && !priceModel.isEmpty()) pst.setString(paramIndex++, priceModel);

            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Property p = extractPropertyFromResultSet(rs);
                    p.setAmenities(getAmenitiesForProperty(p.getPropertyId()));
                    p.setImageUrls(getImagesForProperty(p.getPropertyId()));
                    properties.add(p);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return properties;
    }

    /**
     * LANDLORD VIEW: Fetches all properties owned by a specific landlord.
     */
    public List<Property> getPropertiesByLandlord(int landlordId) {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name " +
                     "FROM properties p " +
                     "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                     "JOIN cities c ON n.city_id = c.city_id " +
                     "JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                     "JOIN property_types pt ON p.type_id = pt.type_id " +
                     "JOIN users u ON p.landlord_id = u.user_id " +
                     "WHERE p.landlord_id = ? " +
                     "ORDER BY p.property_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            
            pst.setInt(1, landlordId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Property p = extractPropertyFromResultSet(rs);
                    properties.add(p);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return properties;
    }

    /**
     * Statistics: Counts properties for a landlord.
     */
    public int getPropertyCount(int landlordId) {
        String sql = "SELECT COUNT(*) FROM properties WHERE landlord_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, landlordId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /**
     * LANDLORD: Adds a new property and returns the generated property_id.
     */
    public int addProperty(Property property) {
        String sql = "INSERT INTO properties (landlord_id, neighborhood_id, type_id, title, description, price, price_model, furnishing_status, is_verified) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pst.setInt(1, property.getLandlordId());
            pst.setInt(2, property.getNeighborhoodId());
            pst.setInt(3, property.getTypeId());
            pst.setString(4, property.getTitle());
            pst.setString(5, property.getDescription());
            pst.setDouble(6, property.getPrice());
            pst.setString(7, property.getPriceModel());
            pst.setString(8, property.getFurnishingStatus());
            pst.setBoolean(9, false); 

            if (pst.executeUpdate() > 0) {
                try (ResultSet rs = pst.getGeneratedKeys()) {
                    if (rs.next()) return rs.getInt(1);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    public boolean addPropertyImage(int propertyId, String imageUrl, boolean isPrimary) {
        String sql = "INSERT INTO property_images (property_id, image_url, is_primary) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, propertyId);
            pst.setString(2, imageUrl);
            pst.setBoolean(3, isPrimary);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean addPropertyAmenity(int propertyId, int amenityId) {
        String sql = "INSERT INTO property_amenities (property_id, amenity_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, propertyId);
            pst.setInt(2, amenityId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    /**
     * ADMIN: Fetches all properties in the system.
     */
    public List<Property> getAllProperties() {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name " +
                     "FROM properties p " +
                     "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                     "JOIN cities c ON n.city_id = c.city_id " +
                     "JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                     "JOIN property_types pt ON p.type_id = pt.type_id " +
                     "JOIN users u ON p.landlord_id = u.user_id " +
                     "ORDER BY p.property_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    properties.add(extractPropertyFromResultSet(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return properties;
    }

    /**
     * Fetch all from destination_themes with hardcoded image mapping.
     */
    public List<Theme> getAllThemes() {
        List<Theme> themes = new ArrayList<>();
        String sql = "SELECT * FROM destination_themes";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            
            while (rs.next()) {
                Theme theme = new Theme();
                theme.setThemeId(rs.getInt("theme_id"));
                theme.setName(rs.getString("theme_name"));
                theme.setDescription(rs.getString("theme_description"));
                
                // Hardcoded image mapping based on theme name for high-end UI vibes
                String themeName = theme.getName().toLowerCase();
                if (themeName.contains("city") || themeName.contains("urban")) 
                    theme.setImageUrl("https://images.unsplash.com/photo-1449824913935-59a10b8d2000?auto=format&fit=crop&w=800&q=80");
                else if (themeName.contains("weekend") || themeName.contains("escape")) 
                    theme.setImageUrl("https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=800&q=80");
                else if (themeName.contains("budget") || themeName.contains("student")) 
                    theme.setImageUrl("https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=800&q=80");
                else if (themeName.contains("luxury") || themeName.contains("premium"))
                    theme.setImageUrl("https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80");
                else if (themeName.contains("nature") || themeName.contains("hill"))
                    theme.setImageUrl("https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80");
                else 
                    theme.setImageUrl("https://images.unsplash.com/photo-1444418776041-9c7e33cc5a9c?auto=format&fit=crop&w=800&q=80");
                
                themes.add(theme);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return themes;
    }

    /**
     * Fetch properties where is_verified = TRUE.
     */
    public List<Property> getVerifiedProperties(int limit) {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name " +
                     "FROM properties p " +
                     "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                     "JOIN cities c ON n.city_id = c.city_id " +
                     "JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                     "JOIN property_types pt ON p.type_id = pt.type_id " +
                     "JOIN users u ON p.landlord_id = u.user_id " +
                     "WHERE p.is_verified = TRUE " +
                     "LIMIT ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, limit);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Property p = extractPropertyFromResultSet(rs);
                    p.setImageUrls(getImagesForProperty(p.getPropertyId())); // Fetch images for the card
                    properties.add(p);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return properties;
    }

    /**
     * Fetch all property types.
     */
    public List<PropertyType> getAllPropertyTypes() {
        List<PropertyType> types = new ArrayList<>();
        String sql = "SELECT * FROM property_types";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            
            while (rs.next()) {
                PropertyType pt = new PropertyType();
                pt.setTypeId(rs.getInt("type_id"));
                pt.setName(rs.getString("type_name"));
                pt.setDescription(rs.getString("type_description"));
                types.add(pt);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return types;
    }
}
