package com.khoj.controller;

import com.khoj.dao.PropertyDAO;
import com.khoj.model.Property;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/property-detail")
public class PropertyDetailServlet extends HttpServlet {
    private PropertyDAO propertyDAO = new PropertyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                int propertyId = Integer.parseInt(idParam);
                
                // Fetch the main property (DAO already joins relational strings 
                // and populates amenities/images in getPropertyById)
                Property property = propertyDAO.getPropertyById(propertyId);
                
                if (property != null) {
                    request.setAttribute("property", property);
                    // amenities and imageUrls are already inside the property object
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
}
