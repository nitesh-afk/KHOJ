package com.khoj.util;

import com.khoj.dao.PropertyDAO;
import com.khoj.model.PropertyType;
import java.util.List;

public class TypeCheck {
    public static void main(String[] args) {
        PropertyDAO dao = new PropertyDAO();
        List<PropertyType> types = dao.getAllPropertyTypes();
        System.out.println("TYPES FOUND: " + types.size());
        for (PropertyType t : types) {
            System.out.println("- " + t.getTypeId() + ": " + t.getName());
        }
    }
}
