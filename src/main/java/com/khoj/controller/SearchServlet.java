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
        
        // Fetch dynamic property types for the dropdown
        List<com.khoj.model.PropertyType> propertyTypes = propertyService.getAllPropertyTypes();
        request.setAttribute("propertyTypes", propertyTypes);
        
        // Filter parameters
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String furnishing = request.getParameter("furnishing");
        String bedroomsStr = request.getParameter("bedrooms");

        Double minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Double.parseDouble(minPriceStr) : null;
        Double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : null;
        Integer bedrooms = (bedroomsStr != null && !bedroomsStr.isEmpty()) ? Integer.parseInt(bedroomsStr) : null;
        
        // Sanitization
        String sanitizedLocation = (location != null) ? location.trim() : null;

        // Pagination logic
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try { page = Integer.parseInt(pageStr); } catch(NumberFormatException e) { page = 1; }
        }
        int limit = 12;
        int offset = (page - 1) * limit;

        List<Property> properties;
        int totalResults;
        
        if (theme != null && !theme.isEmpty()) {
            properties = propertyService.getPropertiesByTheme(theme);
            totalResults = properties.size();
        } else {
            properties = propertyService.searchProperties(sanitizedLocation, type, priceModel, minPrice, maxPrice, furnishing, bedrooms, limit, offset);
            totalResults = propertyService.getSearchTotalCount(sanitizedLocation, type, priceModel, minPrice, maxPrice, furnishing, bedrooms);
        }

        int totalPages = (int) Math.ceil((double) totalResults / limit);

        request.setAttribute("properties", properties);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalResults", totalResults);
        
        request.setAttribute("searchLocation", sanitizedLocation != null ? sanitizedLocation : theme);
        request.setAttribute("searchType", type);
        request.setAttribute("searchPriceModel", priceModel);
        request.setAttribute("searchTheme", theme);
        request.setAttribute("searchMinPrice", minPrice);
        request.setAttribute("searchMaxPrice", maxPrice);
        request.setAttribute("searchFurnishing", furnishing);
        request.setAttribute("searchBedrooms", bedrooms);
        
        // Forward to search results page
        request.getRequestDispatcher("/views/tenant/dashboard.jsp").forward(request, response);
    }
}
