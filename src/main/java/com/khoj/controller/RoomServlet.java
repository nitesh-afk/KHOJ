package com.khoj.controller;

import java.io.IOException;
import java.util.List;

import com.khoj.model.Property;
import com.khoj.model.PropertyType;
import com.khoj.model.User;
import com.khoj.service.PropertyService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet({"/RoomServlet", "/my-rooms", "/add-room"})
public class RoomServlet extends HttpServlet {
    private final PropertyService propertyService = new PropertyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security Check
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String servletPath = request.getServletPath();

        if ("/add-room".equals(servletPath)) {
            // Serve the Add Room form with all supported property types
            List<PropertyType> types = propertyService.getAllPropertyTypes();
            request.setAttribute("propertyTypes", types);
            request.getRequestDispatcher("/views/landlord/add-room.jsp").forward(request, response);
        } else {
            // Default: show My Rooms list
            List<Property> properties = propertyService.getPropertiesByLandlord(user.getId());
            request.setAttribute("properties", properties);
            request.getRequestDispatcher("/views/landlord/my-rooms.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Security Check
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            try {
                int propertyId = Integer.parseInt(request.getParameter("propertyId"));
                com.khoj.dao.PropertyDAO propertyDAO = new com.khoj.dao.PropertyDAO();
                
                // RBAC SECURITY FIX: Verify property ownership before deletion
                Property targetProperty = propertyDAO.getPropertyById(propertyId);
                if (targetProperty == null || targetProperty.getLandlordId() != user.getId()) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                List<String> imageUrls = propertyDAO.getImagesForProperty(propertyId);
                boolean dbDeleted = propertyDAO.deleteProperty(propertyId, user.getId());
                
                if (dbDeleted) {
                    String uploadPath = getServletContext().getRealPath("") + java.io.File.separator + "uploads";
                    for (String relativeUrl : imageUrls) {
                        String fileName = new java.io.File(relativeUrl).getName(); 
                        java.io.File physicalFile = new java.io.File(uploadPath + java.io.File.separator + fileName);
                        if (physicalFile.exists()) {
                            physicalFile.delete();
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/LandlordDashboard?success=deleted");
                } else {
                    response.sendRedirect(request.getContextPath() + "/LandlordDashboard?error=deletion_failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/LandlordDashboard?error=server_error");
            }
            return;
        }

        try {
            String neighborhoodName = request.getParameter("neighborhoodName");
            String typeIdStr        = request.getParameter("typeId");
            String title            = request.getParameter("title");
            String priceStr         = request.getParameter("price");

            // --- Validation ---
            if (neighborhoodName == null || neighborhoodName.trim().isEmpty() ||
                typeIdStr == null || typeIdStr.trim().isEmpty() ||
                title == null || title.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty()) {
                redirectWithError(request, response, "missing_fields", "All required fields must be filled.");
                return;
            }

            // --- Parse numeric fields ---
            int typeId;
            double price;
            try {
                typeId = Integer.parseInt(typeIdStr.trim());
                price = Double.parseDouble(priceStr.trim());
            } catch (NumberFormatException e) {
                redirectWithError(request, response, "invalid_number", "Invalid numeric values entered.");
                return;
            }

            String priceModel       = request.getParameter("priceModel");
            String furnishingStatus = request.getParameter("furnishingStatus");
            String rawDescription   = request.getParameter("description");
            String description      = com.khoj.util.SecurityUtil.sanitizeHTML(rawDescription);
            String imageUrl         = request.getParameter("imageUrl");
            String bedroomsStr      = request.getParameter("bedrooms");

            // --- Build and persist Property ---
            Property property = new Property();
            property.setLandlordId(user.getId());
            property.setTypeId(typeId);
            property.setTitle(title.trim());
            property.setDescription(description);
            property.setPrice(price);
            property.setPriceModel(priceModel);
            property.setFurnishingStatus(furnishingStatus);
            
            if (bedroomsStr != null && !bedroomsStr.trim().isEmpty()) {
                property.setBedrooms(Integer.parseInt(bedroomsStr.trim()));
            }

            // Use service to handle the complex add operation (including neighborhood resolution)
            int propertyId;
            try {
                propertyId = propertyService.addProperty(property, neighborhoodName.trim());
            } catch (RuntimeException dbEx) {
                redirectWithError(request, response, "db_error", "Database error: " + dbEx.getMessage());
                return;
            }

            if (propertyId > 0) {
                if (imageUrl != null && !imageUrl.trim().isEmpty()) {
                    propertyService.addPropertyImage(propertyId, imageUrl.trim(), true);
                }
                response.sendRedirect(request.getContextPath() + "/LandlordDashboard?msg=room_added");
            } else {
                redirectWithError(request, response, "failed", "Failed to save listing. Please check server logs.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectWithError(request, response, "server_error", "An unexpected server error occurred.");
        }
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response,
                                   String code, String message) throws IOException {
        HttpSession session = request.getSession();
        session.setAttribute("formError", message);
        response.sendRedirect(request.getContextPath() + "/add-room?error=" + code);
    }
}
