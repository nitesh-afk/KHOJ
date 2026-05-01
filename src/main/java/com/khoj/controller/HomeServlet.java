package com.khoj.controller;

import com.khoj.service.PropertyService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private final PropertyService propertyService = new PropertyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Fetch data for the horizontal swimlanes
        request.setAttribute("vibes", propertyService.getAllThemes());
        request.setAttribute("verifiedProperties", propertyService.getVerifiedProperties(8));
        request.setAttribute("propertyTypes", propertyService.getAllPropertyTypes());

        // Forward to the refactored landing page
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
