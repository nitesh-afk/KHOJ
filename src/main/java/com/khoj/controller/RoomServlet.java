package com.khoj.controller;

import com.khoj.dao.PropertyDAO;
import com.khoj.model.Property;
import com.khoj.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/RoomServlet", "/my-rooms"})
public class RoomServlet extends HttpServlet {
    private PropertyDAO propertyDAO = new PropertyDAO();

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

        // Fetch All Properties for this Landlord
        List<Property> properties = propertyDAO.getPropertiesByLandlord(user.getId());
        request.setAttribute("properties", properties);
        
        // Forward to the Inventory View (Note: my-rooms.jsp might need field updates too)
        request.getRequestDispatcher("/views/landlord/my-rooms.jsp").forward(request, response);
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

        try {
            String neighborhoodIdStr = request.getParameter("neighborhoodId");
            String typeIdStr = request.getParameter("typeId");
            
            if (neighborhoodIdStr == null || neighborhoodIdStr.isEmpty() ||
                typeIdStr == null || typeIdStr.isEmpty()) {
                response.sendRedirect(request.getContextPath() + 
                    "/views/landlord/add-room.jsp?error=missing_fields");
                return;
            }
            
            int neighborhoodId = Integer.parseInt(neighborhoodIdStr);
            int typeId = Integer.parseInt(typeIdStr);
            double price = Double.parseDouble(request.getParameter("price"));
            String priceModel = request.getParameter("priceModel");
            String furnishingStatus = request.getParameter("furnishingStatus");
            
            // Capture remaining Property Data
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String imageUrl = request.getParameter("imageUrl");
            
            // Create Model
            Property property = new Property();
            property.setLandlordId(user.getId());
            property.setNeighborhoodId(neighborhoodId);
            property.setTypeId(typeId);
            property.setTitle(title);
            property.setDescription(description);
            property.setPrice(price);
            property.setPriceModel(priceModel);
            property.setFurnishingStatus(furnishingStatus);

            // Save to DB
            int propertyId = propertyDAO.addProperty(property);

            if (propertyId > 0) {
                // Save primary image
                if (imageUrl != null && !imageUrl.isEmpty()) {
                    propertyDAO.addPropertyImage(propertyId, imageUrl, true);
                }
                response.sendRedirect(request.getContextPath() + "/LandlordDashboard?msg=room_added");
            } else {
                response.sendRedirect(request.getContextPath() + "/views/landlord/add-room.jsp?error=failed");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + 
                "/views/landlord/add-room.jsp?error=invalid_number");
            return;
        }
    }
}
