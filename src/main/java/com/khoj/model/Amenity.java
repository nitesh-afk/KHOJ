package com.khoj.model;

public class Amenity {
    private int id;
    private String name;
    private String iconCode;

    public Amenity() {}

    public Amenity(int id, String name, String iconCode) {
        this.id = id;
        this.name = name;
        this.iconCode = iconCode;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getIconCode() { return iconCode; }
    public void setIconCode(String iconCode) { this.iconCode = iconCode; }
}
