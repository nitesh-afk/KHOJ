package com.khoj.dao;

import com.khoj.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class ContactDAO {

    public boolean saveInquiry(String name, String email, String subject, String message) {
        String query = "INSERT INTO contact_inquiries (full_name, email, subject, message) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pst = conn.prepareStatement(query)) {
            pst.setString(1, name);
            pst.setString(2, email);
            pst.setString(3, subject);
            pst.setString(4, message);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
