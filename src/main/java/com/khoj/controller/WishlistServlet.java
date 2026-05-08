package com.khoj.controller;

import com.khoj.model.User;
import com.khoj.model.Wishlist;
import com.khoj.service.WishlistService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/wishlist")
public class WishlistServlet extends HttpServlet {
    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"TENANT".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=unauthorized");
            return;
        }

        int tenantId = user.getId();
        List<Wishlist> wishlists = wishlistService.getWishlistByTenant(tenantId);
        request.setAttribute("wishlists", wishlists);
        request.getRequestDispatcher("/views/tenant/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"TENANT".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        String propertyIdParam = request.getParameter("propertyId");

        int propertyId;
        try {
            propertyId = Integer.parseInt(propertyIdParam);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/wishlist?error=invalid_property");
            return;
        }

        int tenantId = user.getId();
        boolean success;

        if ("add".equalsIgnoreCase(action)) {
            success = wishlistService.addToWishlist(tenantId, propertyId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/wishlist?msg=added");
            } else {
                response.sendRedirect(request.getContextPath() + "/wishlist?error=add_failed");
            }
        } else if ("remove".equalsIgnoreCase(action)) {
            success = wishlistService.removeFromWishlist(tenantId, propertyId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/wishlist?msg=removed");
            } else {
                response.sendRedirect(request.getContextPath() + "/wishlist?error=remove_failed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist?error=invalid_action");
        }
    }
}
