package com.khoj.util;

import com.khoj.dao.PropertyDAO;
import com.khoj.model.Property;
import java.util.List;

public class SearchDebug {
    public static void main(String[] args) {
        PropertyDAO dao = new PropertyDAO();
        // Mimic SearchServlet parameters
        String location = "Lumbini";
        String type = "";
        String priceModel = "Monthly";
        
        List<Property> results = dao.searchProperties(location, type, priceModel, null, null, null, null, 12, 0);
        int total = dao.getSearchTotalCount(location, type, priceModel, null, null, null, null);
        
        System.out.println("DEBUG RESULTS FOR LUMBINI:");
        System.out.println("Total Count: " + total);
        System.out.println("Results Size: " + results.size());
        for (Property p : results) {
            System.out.println("- " + p.getTitle() + " | City: " + p.getCityName());
        }
    }
}
