package com.khoj.model;

public class Application {
    private int appId;
    private int tenantId;
    private int propertyId;
    private String status;

    // Extended fields for the Landlord/Tenant view (from JOIN)
    private String tenantName;
    private String tenantEmail;
    private String landlordName;
    private String landlordEmail;
    private String propertyTitle;

    public Application() {}

    // Getters and Setters
    public int getAppId() { return appId; }
    public void setAppId(int appId) { this.appId = appId; }

    public int getTenantId() { return tenantId; }
    public void setTenantId(int tenantId) { this.tenantId = tenantId; }

    public int getPropertyId() { return propertyId; }
    public void setPropertyId(int propertyId) { this.propertyId = propertyId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getTenantName() { return tenantName; }
    public void setTenantName(String tenantName) { this.tenantName = tenantName; }

    public String getTenantEmail() { return tenantEmail; }
    public void setTenantEmail(String tenantEmail) { this.tenantEmail = tenantEmail; }

    public String getLandlordName() { return landlordName; }
    public void setLandlordName(String landlordName) { this.landlordName = landlordName; }

    public String getLandlordEmail() { return landlordEmail; }
    public void setLandlordEmail(String landlordEmail) { this.landlordEmail = landlordEmail; }

    public String getPropertyTitle() { return propertyTitle; }
    public void setPropertyTitle(String propertyTitle) { this.propertyTitle = propertyTitle; }
}
