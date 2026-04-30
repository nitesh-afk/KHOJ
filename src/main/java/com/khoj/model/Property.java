package com.khoj.model;

import java.util.ArrayList;
import java.util.List;

/**
 * Property Data Transfer Object (DTO)
 * Acts as the single model for properties, carrying both core and joined relational data.
 */
public class Property {
    // Core Property Fields
    private int propertyId;
    private int landlordId;
    private int neighborhoodId;
    private int typeId;
    private String title;
    private String description;
    private double price;
    private String priceModel; // ENUM: 'Monthly', 'Daily'
    private String furnishingStatus;
    private boolean isVerified;
    private String createdAt;

    // Relational Strings (Fetched via SQL JOINs)
    private String neighborhoodName;
    private String cityName;
    private String themeName;
    private String propertyType;
    private String landlordName;

    // 1-to-Many Relational Data
    private List<String> amenities;
    private List<String> imageUrls;

    // --- Constructors ---
    
    public Property() {
        this.amenities = new ArrayList<>();
        this.imageUrls = new ArrayList<>();
    }

    public Property(int propertyId, int landlordId, String title, String description, 
                    double price, String priceModel, String furnishingStatus, boolean isVerified, 
                    String createdAt, String neighborhoodName, String cityName, String themeName, 
                    String propertyType, String landlordName) {
        this.propertyId = propertyId;
        this.landlordId = landlordId;
        this.title = title;
        this.description = description;
        this.price = price;
        this.priceModel = priceModel;
        this.furnishingStatus = furnishingStatus;
        this.isVerified = isVerified;
        this.createdAt = createdAt;
        this.neighborhoodName = neighborhoodName;
        this.cityName = cityName;
        this.themeName = themeName;
        this.propertyType = propertyType;
        this.landlordName = landlordName;
        this.amenities = new ArrayList<>();
        this.imageUrls = new ArrayList<>();
    }

    // --- Getters and Setters ---

    public int getPropertyId() { return propertyId; }
    public void setPropertyId(int propertyId) { this.propertyId = propertyId; }

    public int getLandlordId() { return landlordId; }
    public void setLandlordId(int landlordId) { this.landlordId = landlordId; }

    public int getNeighborhoodId() { return neighborhoodId; }
    public void setNeighborhoodId(int neighborhoodId) { this.neighborhoodId = neighborhoodId; }

    public int getTypeId() { return typeId; }
    public void setTypeId(int typeId) { this.typeId = typeId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getPriceModel() { return priceModel; }
    public void setPriceModel(String priceModel) { this.priceModel = priceModel; }

    public String getFurnishingStatus() { return furnishingStatus; }
    public void setFurnishingStatus(String furnishingStatus) { this.furnishingStatus = furnishingStatus; }

    public boolean isVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getNeighborhoodName() { return neighborhoodName; }
    public void setNeighborhoodName(String neighborhoodName) { this.neighborhoodName = neighborhoodName; }

    public String getCityName() { return cityName; }
    public void setCityName(String cityName) { this.cityName = cityName; }

    public String getThemeName() { return themeName; }
    public void setThemeName(String themeName) { this.themeName = themeName; }

    public String getPropertyType() { return propertyType; }
    public void setPropertyType(String propertyType) { this.propertyType = propertyType; }

    public String getLandlordName() { return landlordName; }
    public void setLandlordName(String landlordName) { this.landlordName = landlordName; }

    public List<String> getAmenities() { return amenities; }
    public void setAmenities(List<String> amenities) { this.amenities = amenities; }

    public List<String> getImageUrls() { return imageUrls; }
    public void setImageUrls(List<String> imageUrls) { this.imageUrls = imageUrls; }

    // Helper methods
    public void addAmenity(String amenity) { this.amenities.add(amenity); }
    public void addImageUrl(String imageUrl) { this.imageUrls.add(imageUrl); }
}