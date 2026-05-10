package com.khoj.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class DBSchema {
    public static void main(String[] args) {
        try (Connection c = DBConnection.getConnection(); Statement s = c.createStatement()) {
            ResultSet rs = s.executeQuery("SELECT * FROM properties LIMIT 1");
            ResultSetMetaData meta = rs.getMetaData();
            for (int i=1; i<=meta.getColumnCount(); i++) {
                System.out.println("Column: " + meta.getColumnName(i) + " Type: " + meta.getColumnTypeName(i) + " Size: " + meta.getColumnDisplaySize(i));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
