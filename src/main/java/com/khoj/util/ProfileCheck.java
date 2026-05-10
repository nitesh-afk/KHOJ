package com.khoj.util;

import com.khoj.dao.UserDAO;
import com.khoj.model.User;

public class ProfileCheck {
    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        // Assuming user ID 1 or 2 exists from context
        User u = dao.getUserById(1);
        if (u != null) {
            System.out.println("USER FOUND: " + u.getFullName() + " | Role: " + u.getRole() + " | Img: " + u.getProfileImg());
        } else {
            System.out.println("USER NOT FOUND");
        }
    }
}
