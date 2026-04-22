package com.khoj.model;

public class Room {
    private int id;
    private int ownerId;
    private String title;
    private String description;
    private String location;
    private double price;
    private String roomType; // Single, Double, Flat
    private String imageUrl;
    private String status;
    private boolean isApproved;

    public Room() {}

    public Room(int id, int ownerId, String title, String description, String location, double price, String roomType, String imageUrl, String status) {
        this(id, ownerId, title, description, location, price, roomType, imageUrl, status, false);
    }

    public Room(int id, int ownerId, String title, String description, String location, double price, String roomType, String imageUrl, String status, boolean isApproved) {
        this.id = id;
        this.ownerId = ownerId;
        this.title = title;
        this.description = description;
        this.location = location;
        this.price = price;
        this.roomType = roomType;
        this.imageUrl = imageUrl;
        this.status = status;
        this.isApproved = isApproved;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOwnerId() { return ownerId; }
    public void setOwnerId(int ownerId) { this.ownerId = ownerId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public boolean isApproved() { return isApproved; }
    public void setApproved(boolean approved) { isApproved = approved; }
}
