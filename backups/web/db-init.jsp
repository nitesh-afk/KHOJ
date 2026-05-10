<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.khoj.util.DBConnection" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%
    StringBuilder outStr = new StringBuilder();
    try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement()) {
        // Check property types
        ResultSet rs1 = s.executeQuery("SELECT COUNT(*) FROM property_types");
        rs1.next();
        if (rs1.getInt(1) == 0) {
            s.executeUpdate("INSERT INTO property_types (type_name, type_description) VALUES ('Apartment', 'Full apartment')");
            s.executeUpdate("INSERT INTO property_types (type_name, type_description) VALUES ('Hostel', 'Student hostel')");
            s.executeUpdate("INSERT INTO property_types (type_name, type_description) VALUES ('Hotel', 'Hotel room')");
            s.executeUpdate("INSERT INTO property_types (type_name, type_description) VALUES ('Villa', 'Luxury villa')");
            outStr.append("Inserted Property Types.\n");
        } else {
            outStr.append("Property Types already exist.\n");
        }
        
        // Check cities and neighborhoods
        ResultSet rs2 = s.executeQuery("SELECT COUNT(*) FROM cities");
        rs2.next();
        if (rs2.getInt(1) == 0) {
            // Need a theme first
            s.executeUpdate("INSERT INTO destination_themes (theme_name, theme_description) VALUES ('Urban', 'City vibes')");
            s.executeUpdate("INSERT INTO cities (city_name, theme_id) VALUES ('Kathmandu', 1)");
            s.executeUpdate("INSERT INTO neighborhoods (neighborhood_name, city_id) VALUES ('Thamel', 1)");
            s.executeUpdate("INSERT INTO neighborhoods (neighborhood_name, city_id) VALUES ('Koteshwor', 1)");
            outStr.append("Inserted Cities and Neighborhoods.\n");
        } else {
            outStr.append("Cities/Neighborhoods already exist.\n");
        }
        out.println("SUCCESS: " + outStr.toString());
    } catch(Exception e) {
        out.println("ERROR: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
