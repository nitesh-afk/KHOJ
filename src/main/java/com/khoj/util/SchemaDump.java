package com.khoj.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;

public class SchemaDump {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            String[] tables = {"users", "properties", "roles", "applications", "neighborhoods"};
            
            for (String table : tables) {
                System.out.println("--- Table: " + table + " ---");
                try (ResultSet rs = metaData.getColumns(null, null, table, null)) {
                    while (rs.next()) {
                        System.out.println(rs.getString("COLUMN_NAME") + " (" + rs.getString("TYPE_NAME") + ")");
                    }
                }
                System.out.println();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
