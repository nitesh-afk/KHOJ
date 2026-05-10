package com.khoj.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.khoj.model.Wishlist;
import com.khoj.util.DBConnection;

public class WishlistDAO {

    public boolean addToWishlist(int tenantId, int propertyId) {
        if (isWishlisted(tenantId, propertyId)) {
            return true;
        }

        String sql = "INSERT INTO wishlists (tenant_id, property_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setInt(1, tenantId);
            pst.setInt(2, propertyId);
            return pst.executeUpdate() > 0;
        } catch (java.sql.SQLIntegrityConstraintViolationException e) {
            // Already in wishlist, treat as success
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeFromWishlist(int tenantId, int propertyId) {
        String sql = "DELETE FROM wishlists WHERE tenant_id = ? AND property_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setInt(1, tenantId);
            pst.setInt(2, propertyId);
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isWishlisted(int tenantId, int propertyId) {
        String sql = "SELECT 1 FROM wishlists WHERE tenant_id = ? AND property_id = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

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

    public List<Wishlist> getWishlistByTenant(int tenantId) {
        List<Wishlist> wishlistItems = new ArrayList<>();
        String sql = "SELECT w.wishlist_id, w.tenant_id, w.property_id, w.created_at, p.title, p.price "
                + "FROM wishlists w "
                + "JOIN properties p ON w.property_id = p.property_id "
                + "WHERE w.tenant_id = ? "
                + "ORDER BY w.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setInt(1, tenantId);
            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Wishlist wishlist = new Wishlist();
                    wishlist.setWishlistId(rs.getInt("wishlist_id"));
                    wishlist.setTenantId(rs.getInt("tenant_id"));
                    wishlist.setPropertyId(rs.getInt("property_id"));
                    wishlist.setCreatedAt(rs.getString("created_at"));
                    wishlist.setPropertyTitle(rs.getString("title"));
                    wishlist.setPrice(rs.getDouble("price"));
                    wishlistItems.add(wishlist);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return wishlistItems;
    }
}
