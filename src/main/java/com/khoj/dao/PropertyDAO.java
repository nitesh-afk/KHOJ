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
import java.util.Locale;

public class PropertyDAO {

    /**
     * Query 1: Fetches a single property by ID with all relational data joined.
     */
    public Property getPropertyById(int propertyId) {
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                +
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
        } catch (SQLException e) {
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
        } catch (SQLException e) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }

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

    public List<Property> getAllProperties() {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                +
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return properties;
    }

    public List<PropertyType> getUniquePropertyTypes() {
        return getAllPropertyTypes();
    }

    public List<Theme> getAllThemes() {
        List<Theme> themes = new ArrayList<>();
        String sql = "SELECT * FROM destination_themes";
        try (Connection conn = DBConnection.getConnection();
                Statement st = conn.createStatement();
                ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Theme t = new Theme();
                t.setThemeId(rs.getInt("theme_id"));
                t.setName(rs.getString("theme_name"));
                t.setDescription(rs.getString("theme_description"));
                
                // Add default images based on theme name if needed
                if ("Urban".equalsIgnoreCase(t.getName())) t.setImageUrl("https://images.unsplash.com/photo-1449824913935-59a10b8d2000?auto=format&fit=crop&w=800&q=80");
                else if ("Nature".equalsIgnoreCase(t.getName())) t.setImageUrl("https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80");
                else t.setImageUrl("https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=800&q=80");
                
                themes.add(t);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return themes;
    }

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
                     "ORDER BY p.property_id DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, limit);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    properties.add(extractPropertyFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return properties;
    }

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
                types.add(pt);
            }

            if (types.isEmpty()) {
                try (Statement s = conn.createStatement()) {
                    s.executeUpdate("INSERT INTO property_types (type_name) VALUES ('Apartment')");
                    s.executeUpdate("INSERT INTO property_types (type_name) VALUES ('Hostel')");
                    s.executeUpdate("INSERT INTO property_types (type_name) VALUES ('Hotel')");
                    s.executeUpdate("INSERT INTO property_types (type_name) VALUES ('Villa')");
                }
                return getAllPropertyTypes();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return types;
    }

    public int getOrCreatePropertyType(String typeName) {
        if (typeName == null || typeName.trim().isEmpty()) return -1;
        String normalized = typeName.trim();
        
        String selectSql = "SELECT type_id FROM property_types WHERE LOWER(type_name) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(selectSql)) {
            pst.setString(1, normalized);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) return rs.getInt("type_id");
            }
            
            String insertSql = "INSERT INTO property_types (type_name) VALUES (?)";
            try (PreparedStatement ipst = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ipst.setString(1, normalized);
                ipst.executeUpdate();
                try (ResultSet grs = ipst.getGeneratedKeys()) {
                    if (grs.next()) return grs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int getOrCreateNeighborhood(String neighborhoodName) {
        if (neighborhoodName == null || neighborhoodName.trim().isEmpty()) return -1;
        String trimmedNeighborhood = neighborhoodName.trim();
        String query = "SELECT neighborhood_id FROM neighborhoods WHERE neighborhood_name = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, trimmedNeighborhood);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) return rs.getInt("neighborhood_id");
            }
            
            int cityId = getAnyCityId();
            String insert = "INSERT INTO neighborhoods (neighborhood_name, city_id) VALUES (?, ?)";
            try (PreparedStatement ipst = conn.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
                ipst.setString(1, trimmedNeighborhood);
                ipst.setInt(2, cityId);
                ipst.executeUpdate();
                try (ResultSet rs2 = ipst.getGeneratedKeys()) {
                    if (rs2.next()) return rs2.getInt(1);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    private int getAnyCityId() {
        try (Connection conn = DBConnection.getConnection(); Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT city_id FROM cities LIMIT 1")) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {}
        return 1; 
    }

    public int getAnyNeighborhoodId() {
        try (Connection conn = DBConnection.getConnection(); Statement s = conn.createStatement();
             ResultSet rs = s.executeQuery("SELECT neighborhood_id FROM neighborhoods LIMIT 1")) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {}
        return 1;
    }

    public int addProperty(Property p) {
        String sql = "INSERT INTO properties (landlord_id, neighborhood_id, type_id, title, description, price, price_model, furnishing_status, is_verified) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            pst.setInt(1, p.getLandlordId());
            pst.setInt(2, p.getNeighborhoodId());
            pst.setInt(3, p.getTypeId());
            pst.setString(4, p.getTitle());
            pst.setString(5, p.getDescription());
            pst.setDouble(6, p.getPrice());
            pst.setString(7, p.getPriceModel());
            pst.setString(8, p.getFurnishingStatus());
            pst.setBoolean(9, p.isVerified());
            pst.executeUpdate();
            try (ResultSet rs = pst.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
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
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean addPropertyAmenity(int propertyId, int amenityId) {
        String sql = "INSERT INTO property_amenities (property_id, amenity_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, propertyId);
            pst.setInt(2, amenityId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

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
                    properties.add(extractPropertyFromResultSet(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return properties;
    }

    public List<Property> searchProperties(String location, String type, String priceModel) {
        List<Property> properties = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name ")
                .append("FROM properties p ")
                .append("JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id ")
                .append("JOIN cities c ON n.city_id = c.city_id ")
                .append("JOIN destination_themes dt ON c.theme_id = dt.theme_id ")
                .append("JOIN property_types pt ON p.type_id = pt.type_id ")
                .append("JOIN users u ON p.landlord_id = u.user_id WHERE 1=1 ");

        if (location != null && !location.isEmpty()) sql.append("AND (n.neighborhood_name LIKE ? OR c.city_name LIKE ?) ");
        if (type != null && !type.isEmpty()) sql.append("AND p.type_id = ? ");
        if (priceModel != null && !priceModel.isEmpty()) sql.append("AND p.price_model = ? ");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql.toString())) {
            int paramIdx = 1;
            if (location != null && !location.isEmpty()) {
                pst.setString(paramIdx++, "%" + location + "%");
                pst.setString(paramIdx++, "%" + location + "%");
            }
            if (type != null && !type.isEmpty()) pst.setString(paramIdx++, type);
            if (priceModel != null && !priceModel.isEmpty()) pst.setString(paramIdx++, priceModel);

            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    properties.add(extractPropertyFromResultSet(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return properties;
    }

    public List<Property> getPropertiesByLandlord(int landlordId) {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name " +
                     "FROM properties p " +
                     "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                     "JOIN cities c ON n.city_id = c.city_id " +
                     "JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                     "JOIN property_types pt ON p.type_id = pt.type_id " +
                     "JOIN users u ON p.landlord_id = u.user_id WHERE p.landlord_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, landlordId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    properties.add(extractPropertyFromResultSet(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return properties;
    }

    public int getPropertyCount(int landlordId) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement("SELECT COUNT(*) FROM properties WHERE landlord_id = ?")) {
            pst.setInt(1, landlordId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public boolean deleteProperty(int propertyId) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                try (PreparedStatement p1 = conn.prepareStatement("DELETE FROM property_images WHERE property_id = ?")) {
                    p1.setInt(1, propertyId); p1.executeUpdate();
                }
                try (PreparedStatement p2 = conn.prepareStatement("DELETE FROM property_amenities WHERE property_id = ?")) {
                    p2.setInt(1, propertyId); p2.executeUpdate();
                }
                try (PreparedStatement p3 = conn.prepareStatement("DELETE FROM properties WHERE property_id = ?")) {
                    p3.setInt(1, propertyId);
                    if (p3.executeUpdate() > 0) {
                        conn.commit();
                        return true;
                    }
                }
                conn.rollback();
            } catch (Exception e) { conn.rollback(); throw e; }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
