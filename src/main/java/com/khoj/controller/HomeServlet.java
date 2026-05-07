package com.khoj.controller;

import com.khoj.service.PropertyService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet({"/home", ""})
public class HomeServlet extends HttpServlet {
    private final PropertyService propertyService = new PropertyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Intelligent Session Routing
        jakarta.servlet.http.HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            com.khoj.model.User user = (com.khoj.model.User) session.getAttribute("user");
            String role = user.getRole();
            
            if ("ADMIN".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/AdminServlet");
                return;
            } else if ("LANDLORD".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/LandlordDashboard");
                return;
            }
            // TENANTs fall through to the public discovery feed below
        }

        // 2. Fetch data for the horizontal swimlanes
        request.setAttribute("vibes", propertyService.getAllThemes());
        request.setAttribute("verifiedProperties", propertyService.getVerifiedProperties(8));
        request.setAttribute("propertyTypes", propertyService.getUniquePropertyTypes());
        request.setAttribute("properties", propertyService.getAllProperties());

        // 3. Forward to the refactored landing page
        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
}
