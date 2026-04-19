package com.khoj.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Change 'khoj_db' to whatever you named your database in XAMPP
    private static final String URL = "jdbc:mysql://localhost:3306/khoj_db";
    private static final String USER = "root";
    private static final String PASSWORD = "12345678"; // Default XAMPP password is empty

    public static Connection getConnection() throws SQLException, ClassNotFoundException {
        // Load MySQL Driver
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}