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
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                +
                "FROM properties p " +
                "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                "JOIN cities c ON n.city_id = c.city_id " +
                "JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                "JOIN property_types pt ON p.type_id = pt.type_id " +
                "JOIN users u ON p.landlord_id = u.user_id " +
                "WHERE dt.theme_name = ? AND p.is_verified = TRUE";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setString(1, themeName);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Property p = extractPropertyFromResultSet(rs);
                    // For performance in list views, we often fetch amenities/images separately or
                    // lazily,
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
                "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                        +
                        "FROM properties p " +
                        "JOIN neighborhoods n ON p.neighborhood_id = n.neighborhood_id " +
                        "JOIN cities c ON n.city_id = c.city_id " +
                        "JOIN destination_themes dt ON c.theme_id = dt.theme_id " +
                        "JOIN property_types pt ON p.type_id = pt.type_id " +
                        "JOIN users u ON p.landlord_id = u.user_id " +
                        "WHERE p.is_verified = TRUE ");

        if (location != null && !location.isEmpty())
            sql.append("AND (c.city_name LIKE ? OR n.neighborhood_name LIKE ?) ");
        if (type != null && !type.isEmpty())
            sql.append("AND pt.type_name = ? ");
        if (priceModel != null && !priceModel.isEmpty())
            sql.append("AND p.price_model = ? ");

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
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                +
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
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * LANDLORD: Adds a new property and returns the generated property_id.
     * Throws RuntimeException with the SQL error message on failure so callers can surface it.
     */
    public int addProperty(Property property) throws RuntimeException {
        String sql = "INSERT INTO properties "
                + "(landlord_id, neighborhood_id, type_id, title, description, price, price_model, furnishing_status, is_verified) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // Resolve the exact ENUM values the DB actually uses
            String resolvedPriceModel   = resolveEnumValue(conn, "properties", "price_model",       property.getPriceModel(),       "Monthly");
            String resolvedFurnishing   = resolveEnumValue(conn, "properties", "furnishing_status",  property.getFurnishingStatus(), "Unfurnished");

            System.out.println("DEBUG PropertyDAO.addProperty => landlordId=" + property.getLandlordId()
                    + ", neighborhoodId=" + property.getNeighborhoodId()
                    + ", typeId=" + property.getTypeId()
                    + ", title='" + property.getTitle() + "'"
                    + ", price=" + property.getPrice()
                    + ", priceModel='" + resolvedPriceModel + "'"
                    + ", furnishing='" + resolvedFurnishing + "'");

            pst.setInt(1, property.getLandlordId());
            pst.setInt(2, property.getNeighborhoodId());
            pst.setInt(3, property.getTypeId());
            pst.setString(4, property.getTitle() != null ? property.getTitle().trim() : "");
            pst.setString(5, property.getDescription());
            pst.setDouble(6, property.getPrice());
            pst.setString(7, resolvedPriceModel);
            pst.setString(8, resolvedFurnishing);
            pst.setBoolean(9, false); // new listings start unverified

            int rows = pst.executeUpdate();
            System.out.println("DEBUG PropertyDAO.addProperty => rows affected: " + rows);

            if (rows > 0) {
                try (ResultSet rs = pst.getGeneratedKeys()) {
                    if (rs.next()) {
                        int newId = rs.getInt(1);
                        System.out.println("DEBUG PropertyDAO.addProperty => generated property_id=" + newId);
                        return newId;
                    }
                }
            }
            return -1;

        } catch (SQLException e) {
            String msg = "SQL error inserting property: [" + e.getErrorCode() + "] " + e.getMessage();
            System.err.println("ERROR PropertyDAO.addProperty => " + msg);
            e.printStackTrace();
            throw new RuntimeException(msg, e);
        } catch (ClassNotFoundException e) {
            String msg = "DB driver not found: " + e.getMessage();
            System.err.println("ERROR PropertyDAO.addProperty => " + msg);
            e.printStackTrace();
            throw new RuntimeException(msg, e);
        }
    }

    /**
     * Reads the ENUM definition for a column from INFORMATION_SCHEMA and returns
     * the allowed value that best matches the user-supplied input (case-insensitive,
     * ignoring spaces/hyphens/underscores).  Falls back to {@code defaultValue} when
     * no match is found.
     *
     * Example: DB has ENUM('fully_furnished','semi_furnished','unfurnished').
     * Input "Fully Furnished" → stripped key "fullyfurnished" matches "fullyfurnished" → returns "fully_furnished".
     */
    private String resolveEnumValue(Connection conn, String table, String column,
                                    String input, String defaultValue) {
        // 1. Fetch the raw ENUM definition from information_schema
        String infoSql = "SELECT COLUMN_TYPE FROM INFORMATION_SCHEMA.COLUMNS "
                + "WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?";
        List<String> allowed = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(infoSql)) {
            ps.setString(1, table);
            ps.setString(2, column);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String colType = rs.getString(1); // e.g. "enum('Monthly','Daily')"
                    System.out.println("DEBUG resolveEnumValue => " + column + " COLUMN_TYPE: " + colType);
                    // Parse out the quoted values
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
            // Column might be VARCHAR, not ENUM — just return the input as-is
            return input != null ? input : defaultValue;
        }

        System.out.println("DEBUG resolveEnumValue => " + column + " allowed values: " + allowed);

        if (input == null || input.trim().isEmpty()) {
            return defaultValue;
        }

        // 2. Strip spaces, hyphens, underscores to create a comparison key
        String inputKey = input.trim().toLowerCase(Locale.ROOT)
                .replaceAll("[\\s_\\-]+", "");

        for (String candidate : allowed) {
            String candidateKey = candidate.toLowerCase(Locale.ROOT)
                    .replaceAll("[\\s_\\-]+", "");
            if (inputKey.equals(candidateKey)) {
                System.out.println("DEBUG resolveEnumValue => " + column + ": '" + input + "' -> '" + candidate + "'");
                return candidate;
            }
        }

        // 3. Partial match fallback (input starts-with or contains candidate key)
        for (String candidate : allowed) {
            String candidateKey = candidate.toLowerCase(Locale.ROOT)
                    .replaceAll("[\\s_\\-]+", "");
            if (inputKey.contains(candidateKey) || candidateKey.contains(inputKey)) {
                System.out.println("DEBUG resolveEnumValue => " + column + " partial: '" + input + "' -> '" + candidate + "'");
                return candidate;
            }
        }

        // 4. Nothing matched — use first allowed value and log a warning
        System.err.println("WARN resolveEnumValue => No match for '" + input
                + "' in " + column + "=" + allowed + ". Using default: '" + defaultValue + "'");
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
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        } catch (Exception e) {
            e.printStackTrace();
        }
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
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addPropertyAmenity(int propertyId, int amenityId) {
        String sql = "INSERT INTO property_amenities (property_id, amenity_id) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {
            pst.setInt(1, propertyId);
            pst.setInt(2, amenityId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * ADMIN: Fetches all properties in the system.
     */
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
                    theme.setImageUrl(
                            "https://images.unsplash.com/photo-1449824913935-59a10b8d2000?auto=format&fit=crop&w=800&q=80");
                else if (themeName.contains("weekend") || themeName.contains("escape"))
                    theme.setImageUrl(
                            "https://images.unsplash.com/photo-1500382017468-9049fed747ef?auto=format&fit=crop&w=800&q=80");
                else if (themeName.contains("budget") || themeName.contains("student"))
                    theme.setImageUrl(
                            "https://images.unsplash.com/photo-1518780664697-55e3ad937233?auto=format&fit=crop&w=800&q=80");
                else if (themeName.contains("luxury") || themeName.contains("premium"))
                    theme.setImageUrl(
                            "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=800&q=80");
                else if (themeName.contains("nature") || themeName.contains("hill"))
                    theme.setImageUrl(
                            "https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80");
                else
                    theme.setImageUrl(
                            "https://images.unsplash.com/photo-1444418776041-9c7e33cc5a9c?auto=format&fit=crop&w=800&q=80");

                themes.add(theme);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return themes;
    }

    /**
     * Fetch properties where is_verified = TRUE.
     */
    public List<Property> getVerifiedProperties(int limit) {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT p.*, n.neighborhood_name, c.city_name, dt.theme_name, pt.type_name, u.full_name as landlord_name "
                +
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
        } catch (Exception e) {
            e.printStackTrace();
        }
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
                types.add(pt);
            }

            // Auto-populate default property types if the table is completely empty
            if (types.isEmpty()) {
                try (Statement s = conn.createStatement()) {
                    s.executeUpdate(
                            "INSERT INTO property_types (type_name) VALUES ('Apartment')");
                    s.executeUpdate(
                            "INSERT INTO property_types (type_name) VALUES ('Hostel')");
                    s.executeUpdate(
                            "INSERT INTO property_types (type_name) VALUES ('Hotel')");
                    s.executeUpdate(
                            "INSERT INTO property_types (type_name) VALUES ('Villa')");
                }
                // Recursively fetch the newly inserted types
                return getAllPropertyTypes();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return types;
    }

    /**
     * Converts a free-text location name into a valid neighborhood_id foreign key.
     * Searches for the name; if not found, creates a new neighborhood record on the
     * fly.
     */
    public int getOrCreateNeighborhood(String neighborhoodName) {
        if (neighborhoodName == null || neighborhoodName.trim().isEmpty())
            return -1;

        String trimmedNeighborhood = neighborhoodName.trim();
        String query = "SELECT neighborhood_id FROM neighborhoods WHERE neighborhood_name = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(query)) {

            pst.setString(1, trimmedNeighborhood);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // Found existing
                }
            }

            // Not found: ensure at least one city exists before inserting neighborhood.
            int cityId = -1;
            try (Statement s = conn.createStatement()) {
                ResultSet rsCity = s.executeQuery("SELECT city_id FROM cities LIMIT 1");
                if (rsCity.next()) {
                    cityId = rsCity.getInt(1);
                } else {
                    // No city exists: create one using an existing theme, or create a default theme first.
                    int themeId = -1;
                    try (ResultSet rsTheme = s.executeQuery("SELECT theme_id FROM destination_themes LIMIT 1")) {
                        if (rsTheme.next()) {
                            themeId = rsTheme.getInt(1);
                        }
                    }

                    if (themeId <= 0) {
                        String insertTheme = "INSERT INTO destination_themes (theme_name, theme_description) VALUES (?, ?)";
                        try (PreparedStatement themePst = conn.prepareStatement(insertTheme, Statement.RETURN_GENERATED_KEYS)) {
                            themePst.setString(1, "Default Theme");
                            themePst.setString(2, "Auto-created theme");
                            themePst.executeUpdate();
                            try (ResultSet themeKeys = themePst.getGeneratedKeys()) {
                                if (themeKeys.next()) {
                                    themeId = themeKeys.getInt(1);
                                }
                            }
                        }
                    }

                    if (themeId <= 0) {
                        return -1;
                    }

                    String insertCity = "INSERT INTO cities (city_name, theme_id) VALUES (?, ?)";
                    try (PreparedStatement cityPst = conn.prepareStatement(insertCity, Statement.RETURN_GENERATED_KEYS)) {
                        cityPst.setString(1, "Default City");
                        cityPst.setInt(2, themeId);
                        cityPst.executeUpdate();
                        try (ResultSet cityKeys = cityPst.getGeneratedKeys()) {
                            if (cityKeys.next()) {
                                cityId = cityKeys.getInt(1);
                            }
                        }
                    }
                }

                if (cityId <= 0) {
                    return -1;
                }

                String insert = "INSERT INTO neighborhoods (neighborhood_name, city_id) VALUES (?, ?)";
                try (PreparedStatement insertPst = conn.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS)) {
                    insertPst.setString(1, trimmedNeighborhood);
                    insertPst.setInt(2, cityId);
                    insertPst.executeUpdate();

                    try (ResultSet keys = insertPst.getGeneratedKeys()) {
                        if (keys.next())
                            return keys.getInt(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }
}
