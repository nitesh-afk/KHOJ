package com.khoj.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.khoj.model.Review;
import com.khoj.util.DBConnection;

public class ReviewDAO {

    public boolean addReview(int tenantId, int propertyId, int rating, String comment) {
        if (rating < 1 || rating > 5) {
            return false;
        }

        if (hasReviewed(tenantId, propertyId)) {
            return false;
        }

        String sql = "INSERT INTO property_reviews (tenant_id, property_id, rating, comment) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setInt(1, tenantId);
            pst.setInt(2, propertyId);
            pst.setInt(3, rating);
            pst.setString(4, comment);
            return pst.executeUpdate() > 0;
        } catch (SQLException e)
        {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasReviewed(int tenantId, int propertyId) {
        String sql = "SELECT 1 FROM property_reviews WHERE tenant_id = ? AND property_id = ? LIMIT 1";

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

    public List<Review> getReviewsByProperty(int propertyId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT pr.review_id, pr.tenant_id, pr.property_id, pr.rating, pr.comment, pr.created_at, u.full_name AS tenant_name "
                + "FROM property_reviews pr "
                + "JOIN users u ON pr.tenant_id = u.user_id "
                + "WHERE pr.property_id = ? "
                + "ORDER BY pr.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setInt(1, propertyId);

            try (ResultSet rs = pst.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setTenantId(rs.getInt("tenant_id"));
                    review.setPropertyId(rs.getInt("property_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setCreatedAt(rs.getString("created_at"));
                    review.setTenantName(rs.getString("tenant_name"));
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviews;
    }

    public double getAverageRating(int propertyId) {
        String sql = "SELECT AVG(rating) AS average_rating FROM property_reviews WHERE property_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement pst = conn.prepareStatement(sql)) {

            pst.setInt(1, propertyId);
            try (ResultSet rs = pst.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("average_rating");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }
}
