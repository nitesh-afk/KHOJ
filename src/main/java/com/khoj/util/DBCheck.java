package com.khoj.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class DBCheck {
    public static void main(String[] args) {
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement()) {
            System.out.println("Checking property_types table...");
            try {
                ResultSet rs = s.executeQuery("SELECT count(*) FROM property_types");
                if (rs.next()) {
                    System.out.println("Count: " + rs.getInt(1));
                    if (rs.getInt(1) == 0) {
                        s.executeUpdate(
                                "INSERT INTO property_types (type_name, type_description) VALUES ('Apartment', 'Full apartment')");
                        s.executeUpdate(
                                "INSERT INTO property_types (type_name, type_description) VALUES ('Hostel', 'Student hostel')");
                        s.executeUpdate(
                                "INSERT INTO property_types (type_name, type_description) VALUES ('Hotel', 'Hotel room')");
                        s.executeUpdate(
                                "INSERT INTO property_types (type_name, type_description) VALUES ('Villa', 'Luxury villa')");
                        System.out.println("Inserted defaults.");
                    }
                }
            } catch (Exception ex) {
                System.out.println("Error reading property_types: " + ex.getMessage());
                // Create table
                s.executeUpdate(
                        "CREATE TABLE property_types (type_id INT AUTO_INCREMENT PRIMARY KEY, type_name VARCHAR(100), type_description VARCHAR(255))");
                System.out.println("Created table property_types.");
                s.executeUpdate(
                        "INSERT INTO property_types (type_name, type_description) VALUES ('Apartment', 'Full apartment')");
                s.executeUpdate(
                        "INSERT INTO property_types (type_name, type_description) VALUES ('Hostel', 'Student hostel')");
                s.executeUpdate(
                        "INSERT INTO property_types (type_name, type_description) VALUES ('Hotel', 'Hotel room')");
                s.executeUpdate(
                        "INSERT INTO property_types (type_name, type_description) VALUES ('Villa', 'Luxury villa')");
            }

            System.out.println("Checking neighborhoods table...");
            try {
                s.executeQuery("SELECT count(*) FROM neighborhoods");
            } catch (Exception ex) {
                System.out.println("Error reading neighborhoods: " + ex.getMessage());
                s.executeUpdate(
                        "CREATE TABLE cities (city_id INT AUTO_INCREMENT PRIMARY KEY, city_name VARCHAR(100), theme_id INT)");
                s.executeUpdate(
                        "CREATE TABLE neighborhoods (neighborhood_id INT AUTO_INCREMENT PRIMARY KEY, neighborhood_name VARCHAR(100), city_id INT)");
                s.executeUpdate(
                        "CREATE TABLE destination_themes (theme_id INT AUTO_INCREMENT PRIMARY KEY, theme_name VARCHAR(100), theme_description VARCHAR(255))");
                System.out.println("Created neighborhood tables.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
