package com.khoj.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import com.khoj.model.Property;
import com.khoj.model.PropertyType;
import com.khoj.model.Theme;
import com.khoj.util.DBConnection;

public class PropertyDAO {

    /**
     * Query 1: Fetches a single property by ID with all relational data joined.
     */
    public Property getPropertyById(int propertyId) {
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name, u.email as landlord_email, u.phone_number as landlord_phone "
                +
                "FROM properties p " +
                "LEFT JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                "LEFT JOIN cities c ON n.city_id = c.city_id " +
                "LEFT JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                "LEFT JOIN property_types pt ON p.type_id = pt.type_id " +
                "LEFT JOIN users u ON p.landlord_id = u.user_id " +
                "WHERE p.property_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setInt(1, propertyId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    Property property = extractPropertyFromResultSet(rs);
                    property.setDetailedAmenities(getPropertyAmenities(propertyId));
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
     * PRECISION: Fetch detailed Amenity objects with icons.
     */
    public List<Amenity> getPropertyAmenities(int propertyId) {
        List<Amenity> amenities = new ArrayList<>();
        String sql = "SELECT a.* FROM property_amenities pa " +
                     "JOIN amenities a ON pa.amenity_id = a.amenity_id " +
                     "WHERE pa.property_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, propertyId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    amenities.add(new Amenity(
                        rs.getInt("amenity_id"),
                        rs.getString("amenity_name"),
                        rs.getString("icon_code")
                    ));
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return amenities;
    }

    /**
     * REVIEWS: Fetch all reviews for a property with tenant names.
     */
    public List<Review> getPropertyReviews(int propertyId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name as tenant_name FROM reviews r " +
                     "JOIN users u ON r.tenant_id = u.user_id " +
                     "WHERE r.property_id = ? ORDER BY r.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, propertyId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setReviewId(rs.getInt("review_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setCreatedAt(rs.getString("created_at"));
                    r.setTenantName(rs.getString("tenant_name"));
                    reviews.add(r);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return reviews;
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

    /**
     * Query 4: Fetches properties categorized by theme name.
     */
    public List<Property> getPropertiesByTheme(String themeName) {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                +
                "FROM properties p " +
                "LEFT JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                "LEFT JOIN cities c ON n.city_id = c.city_id " +
                "LEFT JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                "LEFT JOIN property_types pt ON p.type_id = pt.type_id " +
                "LEFT JOIN users u ON p.landlord_id = u.user_id " +
                "WHERE dt.theme_name = ? AND p.is_verified = TRUE";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, themeName);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Property p = extractPropertyFromResultSet(rs);
                    p.setAmenities(getAmenitiesForProperty(p.getPropertyId()));
                    p.setImageUrls(getImagesForProperty(p.getPropertyId()));
                    properties.add(p);
                }
            }
        } catch (SQLException e) {
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
        property.setBedrooms(rs.getInt("bedrooms"));
        property.setCreatedAt(rs.getString("created_at"));

        // Joined Fields
        property.setNeighborhoodName(rs.getString("neighborhood_name"));
        property.setCityName(rs.getString("city_name"));
        property.setThemeName(rs.getString("theme_name"));
        property.setPropertyType(rs.getString("type_name"));
        property.setLandlordName(rs.getString("landlord_name"));
        property.setLandlordEmail(rs.getString("landlord_email"));
        property.setLandlordPhone(rs.getString("landlord_phone"));

        return property;
    }

    /**
     * Advanced Search: Fetches properties based on location, type, and price model.
     */
    public List<Property> searchProperties(String location, String type, String priceModel, 
                                          Double minPrice, Double maxPrice, String furnishing, 
                                          Integer bedrooms, int limit, int offset) {
        List<Property> properties = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                        + "FROM properties p " 
                        + "LEFT JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " 
                        + "LEFT JOIN cities c ON n.city_id = c.city_id " 
                        + "LEFT JOIN destination_themes dt ON c.theme_id = dt.theme_id " 
                        + "LEFT JOIN property_types pt ON p.type_id = pt.type_id " 
                        + "LEFT JOIN users u ON p.landlord_id = u.user_id " 
                        + "WHERE p.is_verified = TRUE ");

        if (location != null && !location.isEmpty())
            sql.append("AND (c.city_name LIKE ? OR n.neighborhood_name LIKE ?) ");
        if (type != null && !type.isEmpty())
            sql.append("AND pt.type_name = ? ");
        if (priceModel != null && !priceModel.isEmpty())
            sql.append("AND p.price_model = ? ");
        if (minPrice != null)
            sql.append("AND p.price >= ? ");
        if (maxPrice != null)
            sql.append("AND p.price <= ? ");
        if (furnishing != null && !furnishing.isEmpty())
            sql.append("AND p.furnishing_status = ? ");
        if (bedrooms != null && bedrooms > 0)
            sql.append("AND p.bedrooms = ? ");

        sql.append("ORDER BY p.property_id DESC LIMIT ? OFFSET ?");

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (location != null && !location.isEmpty()) {
                String locPattern = "%" + location + "%";
                pst.setString(paramIndex++, locPattern);
                pst.setString(paramIndex++, locPattern);
            }
            if (type != null && !type.isEmpty())
                pst.setString(paramIndex++, type);
            if (priceModel != null && !priceModel.isEmpty())
                pst.setString(paramIndex++, priceModel);
            if (minPrice != null)
                pst.setDouble(paramIndex++, minPrice);
            if (maxPrice != null)
                pst.setDouble(paramIndex++, maxPrice);
            if (furnishing != null && !furnishing.isEmpty())
                pst.setString(paramIndex++, furnishing);
            if (bedrooms != null && bedrooms > 0)
                pst.setInt(paramIndex++, bedrooms);
            
            pst.setInt(paramIndex++, limit);
            pst.setInt(paramIndex++, offset);

            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Property p = extractPropertyFromResultSet(rs);
                    p.setAmenities(getAmenitiesForProperty(p.getPropertyId()));
                    p.setImageUrls(getImagesForProperty(p.getPropertyId()));
                    properties.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return properties;
    }

    /**
     * LANDLORD VIEW: Fetches all properties owned by a specific landlord.
     */
    public List<Property> getPropertiesByLandlord(int landlordId) {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                +
                "FROM properties p " +
                "LEFT JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                "LEFT JOIN cities c ON n.city_id = c.city_id " +
                "LEFT JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                "LEFT JOIN property_types pt ON p.type_id = pt.type_id " +
                "LEFT JOIN users u ON p.landlord_id = u.user_id " +
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
        } catch (SQLException e) {
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
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateProperty(int propertyId, int landlordId, String title, String description,
            double price, String priceModel, String furnishingStatus, int bedrooms) {
        String sql = "UPDATE properties "
                + "SET title = ?, description = ?, price = ?, price_model = ?, furnishing_status = ?, bedrooms = ? "
                + "WHERE property_id = ? AND landlord_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

            String resolvedPriceModel = resolveEnumValue(conn, "properties", "price_model", priceModel, "Monthly");
            String resolvedFurnishing = resolveEnumValue(conn, "properties", "furnishing_status", furnishingStatus,
                    "Unfurnished");

            pst.setString(1, title);
            pst.setString(2, description);
            pst.setDouble(3, price);
            pst.setString(4, resolvedPriceModel);
            pst.setString(5, resolvedFurnishing);
            pst.setInt(6, bedrooms);
            pst.setInt(7, propertyId);
            pst.setInt(8, landlordId);
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteProperty(int propertyId, int landlordId) {
        String sql = "DELETE FROM properties WHERE property_id = ? AND landlord_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, propertyId);
            pst.setInt(2, landlordId);
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<String, Integer> getPropertyCountByStatus(int landlordId) {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("total", 0);
        counts.put("verified", 0);
        counts.put("pending", 0);

        String sql = "SELECT COUNT(*) AS total, "
                + "SUM(CASE WHEN is_verified = 1 THEN 1 ELSE 0 END) AS verified, "
                + "SUM(CASE WHEN is_verified = 0 THEN 1 ELSE 0 END) AS pending "
                + "FROM properties WHERE landlord_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, landlordId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    counts.put("total", rs.getInt("total"));
                    counts.put("verified", rs.getInt("verified"));
                    counts.put("pending", rs.getInt("pending"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return counts;
    }

    /**
     * LANDLORD: Adds a new property and returns the generated property_id.
     * Throws RuntimeException with the SQL error message on failure so callers can surface it.
     */
    public int addProperty(Property property) throws RuntimeException {
        String sql = "INSERT INTO properties "
                + "(landlord_id, neighborhood_id, type_id, title, description, price, price_model, furnishing_status, is_verified, bedrooms) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Resolve the exact ENUM values the DB actually uses
            String resolvedPriceModel   = resolveEnumValue(conn, "properties", "price_model",       property.getPriceModel(),       "Monthly");
            String resolvedFurnishing   = resolveEnumValue(conn, "properties", "furnishing_status",  property.getFurnishingStatus(), "Unfurnished");

            pst.setInt(1, property.getLandlordId());
            pst.setInt(2, property.getNeighborhoodId());
            pst.setInt(3, property.getTypeId());
            pst.setString(4, property.getTitle() != null ? property.getTitle().trim() : "");
            pst.setString(5, property.getDescription());
            pst.setDouble(6, property.getPrice());
            pst.setString(7, resolvedPriceModel);
            pst.setString(8, resolvedFurnishing);
            pst.setBoolean(9, false); // new listings start unverified
            pst.setInt(10, property.getBedrooms());

            int rows = pst.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = pst.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
            return -1;

        } catch (SQLException e) {
            String msg = "SQL error inserting property: [" + e.getErrorCode() + "] " + e.getMessage();
            e.printStackTrace();
            throw new RuntimeException(msg, e);
        }
    }

    /**
     * Reads the ENUM definition for a column from INFORMATION_SCHEMA and returns
     * the allowed value that best matches the user-supplied input.
     */
    private String resolveEnumValue(Connection conn, String table, String column,
                                    String input, String defaultValue) {
        String infoSql = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS "
                + "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?";
        List<String> allowed = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(infoSql)) {
            ps.setString(1, table);
            ps.setString(2, column);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String colType = rs.getString(1); 
                    String inner = colType.replaceAll("(?i)^enum\\(", "").replaceAll("\\)$", "");
                    for (String part : inner.split(",")) {
                        allowed.add(part.trim().replaceAll("^'", "").replaceAll("'$", ""));
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("WARN resolveEnumValue => could not read INFORMATION_SCHEMA: " + e.getMessage());
        }

        if (allowed.isEmpty()) {
            return input != null ? input : defaultValue;
        }

        if (input == null || input.trim().isEmpty()) {
            return defaultValue;
        }

        String inputKey = input.trim().toLowerCase(Locale.ROOT).replaceAll("[\\s_\\-]+", "");

        for (String candidate : allowed) {
            String candidateKey = candidate.toLowerCase(Locale.ROOT).replaceAll("[\\s_\\-]+", "");
            if (inputKey.equals(candidateKey)) {
                return candidate;
            }
        }
        return defaultValue;
    }

    public int getAnyNeighborhoodId() {
        String sql = "SELECT neighborhood_id FROM neighborhoods ORDER BY neighborhood_id ASC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql);
                ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("neighborhood_id");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return -1;
    }

    public int getAnyPropertyTypeId() {
        String sql = "SELECT type_id FROM property_types ORDER BY type_id ASC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql);
                ResultSet rs = pst.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("type_id");
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
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                +
                "FROM properties p " +
                "LEFT JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                "LEFT JOIN cities c ON n.city_id = c.city_id " +
                "LEFT JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                "LEFT JOIN property_types pt ON p.type_id = pt.type_id " +
                "LEFT JOIN users u ON p.landlord_id = u.user_id " +
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
        } catch (Exception e) { e.printStackTrace(); }
        return types;
    }

    public List<PropertyType> getUniquePropertyTypes() {
        List<PropertyType> types = new ArrayList<>();
        String sql = "SELECT DISTINCT pt.type_id, pt.type_name "
                + "FROM property_types pt "
                + "JOIN properties p ON pt.type_id = p.type_id "
                + "ORDER BY pt.type_name";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql);
                ResultSet rs = pst.executeQuery()) {
            while (rs.next()) {
                PropertyType pt = new PropertyType();
                pt.setTypeId(rs.getInt("type_id"));
                pt.setName(rs.getString("type_name"));
                types.add(pt);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return types;
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
                themes.add(t);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return themes;
    }

    public List<Property> getVerifiedProperties(int limit) {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                +
                "FROM properties p " +
                "LEFT JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                "LEFT JOIN cities c ON n.city_id = c.city_id " +
                "LEFT JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                "LEFT JOIN property_types pt ON p.type_id = pt.type_id " +
                "LEFT JOIN users u ON p.landlord_id = u.user_id " +
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
        } catch (SQLException e) { e.printStackTrace(); }
        return properties;
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
        } catch (SQLException e) { e.printStackTrace(); }
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

    public int getSearchTotalCount(String location, String type, String priceModel, 
                                   Double minPrice, Double maxPrice, String furnishing, Integer bedrooms) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM properties p " 
                        + "LEFT JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " 
                        + "LEFT JOIN cities c ON n.city_id = c.city_id " 
                        + "LEFT JOIN property_types pt ON p.type_id = pt.type_id " 
                        + "WHERE p.is_verified = TRUE ");

        if (location != null && !location.isEmpty())
            sql.append("AND (c.city_name LIKE ? OR n.neighborhood_name LIKE ?) ");
        if (type != null && !type.isEmpty())
            sql.append("AND pt.type_name = ? ");
        if (priceModel != null && !priceModel.isEmpty())
            sql.append("AND p.price_model = ? ");
        if (minPrice != null)
            sql.append("AND p.price >= ? ");
        if (maxPrice != null)
            sql.append("AND p.price <= ? ");
        if (furnishing != null && !furnishing.isEmpty())
            sql.append("AND p.furnishing_status = ? ");
        if (bedrooms != null && bedrooms > 0)
            sql.append("AND p.bedrooms = ? ");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (location != null && !location.isEmpty()) {
                String locPattern = "%" + location + "%";
                pst.setString(paramIndex++, locPattern);
                pst.setString(paramIndex++, locPattern);
            }
            if (type != null && !type.isEmpty())
                pst.setString(paramIndex++, type);
            if (priceModel != null && !priceModel.isEmpty())
                pst.setString(paramIndex++, priceModel);
            if (minPrice != null)
                pst.setDouble(paramIndex++, minPrice);
            if (maxPrice != null)
                pst.setDouble(paramIndex++, maxPrice);
            if (furnishing != null && !furnishing.isEmpty())
                pst.setString(paramIndex++, furnishing);
            if (bedrooms != null && bedrooms > 0)
                pst.setInt(paramIndex++, bedrooms);

            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalVerifiedCount() {
        String sql = "SELECT COUNT(*) FROM properties WHERE is_verified = TRUE";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql);
             ResultSet rs = pst.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }
}
