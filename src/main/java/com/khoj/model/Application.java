package com.khoj.model;

public class Application {
    private int appId;
    private int tenantId;
    private int roomId;
    private String status;

    // Extended fields for the Landlord/Student view (from JOIN)
    private String studentName;
    private String studentEmail;
    private String landlordName;
    private String landlordEmail;
    private String roomTitle;

    public Application() {}

    // Getters and Setters
    public int getAppId() { return appId; }
    public void setAppId(int appId) { this.appId = appId; }

    public int getTenantId() { return tenantId; }
    public void setTenantId(int tenantId) { this.tenantId = tenantId; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStudentEmail() { return studentEmail; }
    public void setStudentEmail(String studentEmail) { this.studentEmail = studentEmail; }

    public String getLandlordName() { return landlordName; }
    public void setLandlordName(String landlordName) { this.landlordName = landlordName; }

    public String getLandlordEmail() { return landlordEmail; }
    public void setLandlordEmail(String landlordEmail) { this.landlordEmail = landlordEmail; }

    public String getRoomTitle() { return roomTitle; }
    public void setRoomTitle(String roomTitle) { this.roomTitle = roomTitle; }
}
