package com.khoj.service;

import com.khoj.dao.ReviewDAO;
import com.khoj.model.Review;

import java.util.ArrayList;
import java.util.List;

public class ReviewService {
    private final ReviewDAO reviewDAO = new ReviewDAO();

    public boolean addReview(int tenantId, int propertyId, int rating, String comment) {
        try {
            return reviewDAO.addReview(tenantId, propertyId, rating, comment);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasReviewed(int tenantId, int propertyId) {
        try {
            return reviewDAO.hasReviewed(tenantId, propertyId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Review> getReviewsByProperty(int propertyId) {
        try {
            return reviewDAO.getReviewsByProperty(propertyId);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public double getAverageRating(int propertyId) {
        try {
            return reviewDAO.getAverageRating(propertyId);
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }
}
