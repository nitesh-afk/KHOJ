package com.khoj.model;

public class Theme {
    private int themeId;
    private String name;
    private String description;
    private String imageUrl;

    public Theme() {}

    public Theme(int themeId, String name, String description, String imageUrl) {
        this.themeId = themeId;
        this.name = name;
        this.description = description;
        this.imageUrl = imageUrl;
    }

    public int getThemeId() { return themeId; }
    public void setThemeId(int themeId) { this.themeId = themeId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
