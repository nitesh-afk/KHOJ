package com.khoj.model;

public class PropertyType {
    private int typeId;
    private String name;
    private String description;

    public PropertyType() {}

    public PropertyType(int typeId, String name, String description) {
        this.typeId = typeId;
        this.name = name;
        this.description = description;
    }

    public int getTypeId() { return typeId; }
    public void setTypeId(int typeId) { this.typeId = typeId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
