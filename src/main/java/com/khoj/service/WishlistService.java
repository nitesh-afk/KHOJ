package com.khoj.service;

import com.khoj.dao.WishlistDAO;
import com.khoj.model.Wishlist;

import java.util.ArrayList;
import java.util.List;

public class WishlistService {
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    public boolean addToWishlist(int tenantId, int propertyId) {
        try {
            return wishlistDAO.addToWishlist(tenantId, propertyId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean removeFromWishlist(int tenantId, int propertyId) {
        try {
            return wishlistDAO.removeFromWishlist(tenantId, propertyId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean isWishlisted(int tenantId, int propertyId) {
        try {
            return wishlistDAO.isWishlisted(tenantId, propertyId);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Wishlist> getWishlistByTenant(int tenantId) {
        try {
            return wishlistDAO.getWishlistByTenant(tenantId);
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
}
