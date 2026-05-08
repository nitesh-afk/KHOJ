package com.khoj.controller;

import com.khoj.model.Property;
import com.khoj.service.PropertyService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/SearchServlet", "/search"})
public class SearchServlet extends HttpServlet {
    private final PropertyService propertyService = new PropertyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String location = request.getParameter("location");
        String type = request.getParameter("type");
        String priceModel = request.getParameter("priceModel");
        String theme = request.getParameter("theme");
        
        // Filter parameters
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String furnishing = request.getParameter("furnishing");
        String bedroomsStr = request.getParameter("bedrooms");

        Double minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Double.parseDouble(minPriceStr) : null;
        Double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : null;
        Integer bedrooms = (bedroomsStr != null && !bedroomsStr.isEmpty()) ? Integer.parseInt(bedroomsStr) : null;

        List<Property> properties;
        
        if (theme != null && !theme.isEmpty()) {
            properties = propertyService.getPropertiesByTheme(theme);
        } else {
            properties = propertyService.searchProperties(location, type, priceModel, minPrice, maxPrice, furnishing, bedrooms);
        }

        request.setAttribute("properties", properties);
        request.setAttribute("searchLocation", location != null ? location : theme);
        request.setAttribute("searchType", type);
        request.setAttribute("searchPriceModel", priceModel);
        request.setAttribute("searchTheme", theme);
        
        // Forward to search results page
        request.getRequestDispatcher("/views/tenant/dashboard.jsp").forward(request, response);
    }
}
