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

@WebServlet({"/SearchServlet", "/search"})
public class SearchServlet extends HttpServlet {
    private PropertyDAO propertyDAO = new PropertyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String location = request.getParameter("location");
        String type = request.getParameter("type");
        String priceModel = request.getParameter("priceModel");
        String theme = request.getParameter("theme");

        List<Property> properties;
        
        if (theme != null && !theme.isEmpty()) {
            properties = propertyDAO.getPropertiesByTheme(theme);
        } else {
            // Advanced search using PropertyDAO
            properties = propertyDAO.searchProperties(location, type, priceModel);
        }

        request.setAttribute("properties", properties);
        request.setAttribute("searchLocation", location != null ? location : theme);
        
        // Forward to search results page
        request.getRequestDispatcher("/views/tenant/dashboard.jsp").forward(request, response);
    }
}
