package com.khoj.util;

import com.khoj.dao.PropertyDAO;
import com.khoj.model.Property;

public class DBInsertTest {
    public static void main(String[] args) {
        PropertyDAO dao = new PropertyDAO();
        
        System.out.println("Testing getOrCreateNeighborhood...");
        try {
            int neighborhoodId = dao.getOrCreateNeighborhood("Test Area");
            System.out.println("Neighborhood ID: " + neighborhoodId);
            
            Property p = new Property();
            p.setLandlordId(1); // Assuming 1 exists, let's check
            p.setNeighborhoodId(neighborhoodId);
            p.setTypeId(1); // Assuming 1 exists
            p.setTitle("Test Property");
            p.setDescription("Test Desc");
            p.setPrice(5000);
            p.setPriceModel("Monthly");
            p.setFurnishingStatus("Fully Furnished");
            
            System.out.println("Testing addProperty...");
            int propId = dao.addProperty(p);
            System.out.println("Property ID: " + propId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
