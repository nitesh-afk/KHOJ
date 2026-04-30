package com.khoj.controller;

import com.khoj.dao.PropertyDAO;
import com.khoj.model.Property;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private PropertyDAO propertyDAO = new PropertyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Fetch data for the horizontal swimlanes
        request.setAttribute("vibes", propertyDAO.getAllThemes());
        request.setAttribute("verifiedProperties", propertyDAO.getVerifiedProperties(8));
        request.setAttribute("propertyTypes", propertyDAO.getAllPropertyTypes());

        // Forward to the refactored landing page
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}
