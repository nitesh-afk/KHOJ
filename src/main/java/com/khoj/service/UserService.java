package com.khoj.service;

import com.khoj.dao.UserDAO;
import com.khoj.model.User;
import com.khoj.util.SecurityUtil;
import java.util.List;

/**
 * Service class for handling User-related business logic.
 * This layer sits between the Controller (Servlet) and the Data Access Object (DAO).
 */
public class UserService { // Abhiyan
    private final UserDAO userDAO = new UserDAO();

    /**
     * Authenticates a user based on email and password.
     * @param email The user's email
     * @param password The raw password
     * @return The User object if authenticated, null otherwise.
     */
    public User authenticate(String email, String password) {
        User user = userDAO.getUserByEmail(email);
        if (user != null && SecurityUtil.verifyPassword(password, user.getPassword())) {
            return user;
        }
        return null;
    }

    /**
     * Registers a new user with a hashed password.
     * @param user The user to register
     * @return true if registration was successful
     */
    public boolean registerUser(User user) {
        // Hash the password before saving (Business Logic)
        String hashedPassword = SecurityUtil.hashPassword(user.getPassword());
        user.setPassword(hashedPassword);
        
        // Ensure status is ACTIVE by default
        if (user.getStatus() == null || user.getStatus().isEmpty()) {
            user.setStatus("ACTIVE");
        }
        
        return userDAO.registerUser(user);
    }

    /**
     * Checks if an email is already registered.
     * @param email The email to check
     * @return true if email exists
     */
    public boolean isEmailTaken(String email) {
        return userDAO.getUserByEmail(email) != null;
    }

    public List<User> getAllUsers() {
        return userDAO.getAllUsers();
    }

    public boolean deleteUser(int userId) {
        return userDAO.deleteUser(userId);
    }

    public boolean updateUserStatus(int userId, String status) {
        return userDAO.updateUserStatus(userId, status);
    }
}
