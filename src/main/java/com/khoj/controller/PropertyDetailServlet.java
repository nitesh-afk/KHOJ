package com.khoj.controller;

import com.khoj.model.Property;
import com.khoj.model.Review;
import com.khoj.model.User;
import com.khoj.service.PropertyService;
import com.khoj.service.ReviewService;
import com.khoj.service.WishlistService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.khoj.dao.ApplicationDAO;
import java.io.IOException;
import java.util.List;

@WebServlet("/property-detail")
public class PropertyDetailServlet extends HttpServlet {
    private final PropertyService propertyService = new PropertyService();
    private final ReviewService reviewService = new ReviewService();
    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int propertyId = Integer.parseInt(idParam);
                
                // Fetch the main property (Service already joins relational strings 
                // and populates amenities/images in getPropertyById)
                Property property = propertyService.getPropertyById(propertyId);
                
                if (property != null) {
                    List<Review> reviews = reviewService.getReviewsByProperty(propertyId);
                    double avgRating = reviewService.getAverageRating(propertyId);

                    HttpSession session = request.getSession(false);
                    User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;
                    boolean isWishlisted = false;
                    boolean hasApplied = false;
                    if (sessionUser != null && "TENANT".equalsIgnoreCase(sessionUser.getRole())) {
                        isWishlisted = wishlistService.isWishlisted(sessionUser.getId(), propertyId);
                        ApplicationDAO appDAO = new ApplicationDAO();
                        hasApplied = appDAO.hasApplied(sessionUser.getId(), propertyId);
                    }
                    request.setAttribute("property", property);
                    request.setAttribute("reviews", reviews);
                    request.setAttribute("avgRating", avgRating);
                    request.setAttribute("isWishlisted", isWishlisted);
                    request.setAttribute("hasApplied", hasApplied);
                    request.getRequestDispatcher("/views/property-detail.jsp").forward(request, response);
                } else {
                    response.sendRedirect("home?error=PropertyNotFound");
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("home?error=InvalidId");
            }
        } else {
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Application logic moved to ApplicationServlet.java
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}
