package com.khoj.controller;

import com.khoj.model.User;
import com.khoj.service.ReviewService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"TENANT".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=unauthorized");
            return;
        }

        String propertyIdParam = request.getParameter("propertyId");
        String ratingParam = request.getParameter("rating");
        String comment = request.getParameter("comment");

        int propertyId;
        int rating;
        try {
            propertyId = Integer.parseInt(propertyIdParam);
            rating = Integer.parseInt(ratingParam);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/property-detail?id=" + propertyIdParam
                    + "&error=invalid_rating");
            return;
        }

        if (rating < 1 || rating > 5) {
            response.sendRedirect(request.getContextPath() + "/property-detail?id=" + propertyId
                    + "&error=invalid_rating");
            return;
        }

        if (comment == null || comment.trim().isEmpty() || comment.length() > 500) {
            response.sendRedirect(request.getContextPath() + "/property-detail?id=" + propertyId
                    + "&error=invalid_comment");
            return;
        }

        int tenantId = user.getId();
        if (reviewService.hasReviewed(tenantId, propertyId)) {
            response.sendRedirect(request.getContextPath() + "/property-detail?id=" + propertyId
                    + "&error=already_reviewed");
            return;
        }

        boolean success = reviewService.addReview(tenantId, propertyId, rating, comment.trim());
        if (success) {
            response.sendRedirect(request.getContextPath() + "/property-detail?id=" + propertyId
                    + "&success=reviewed");
        } else {
            response.sendRedirect(request.getContextPath() + "/property-detail?id=" + propertyId
                    + "&error=review_failed");
        }
    }
}
