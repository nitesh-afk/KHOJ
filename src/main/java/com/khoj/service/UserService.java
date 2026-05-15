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

        return userDAO.registerUser(user);
    }

    /**
     * @return true if the phone number is already registered (non-blank values only).
     */
    public boolean isPhoneTaken(String phone) {
        return userDAO.isPhoneTaken(phone);
    }

    /**
     * Checks if an email is already registered.
     * @param email The email to check
     * @return true if email exists
     */
    public boolean isEmailTaken(String email) {
        return userDAO.getUserByEmail(email) != null;
    }

    public boolean isEmailTaken(String email, int excludeUserId) {
        return userDAO.isEmailTaken(email, excludeUserId);
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

    public boolean updateUserProfile(User user) {
        return userDAO.updateUserProfile(user);
    }

    public boolean updatePassword(int userId, String newHashedPassword) {
        return userDAO.updatePassword(userId, newHashedPassword);
    }

    public User getUserById(int userId) {
        return userDAO.getUserById(userId);
    }

    public User getUserByEmail(String email) {
        return userDAO.getUserByEmail(email);
    }

    /**
     * Loads the canonical user row for profile operations, using session id or email fallback.
     */
    public User getUserForProfile(User sessionUser) {
        if (sessionUser == null) {
            return null;
        }
        User fromDb = null;
        if (sessionUser.getId() > 0) {
            fromDb = userDAO.getUserById(sessionUser.getId());
        }
        if (fromDb == null && sessionUser.getEmail() != null && !sessionUser.getEmail().isBlank()) {
            fromDb = userDAO.getUserByEmail(sessionUser.getEmail().trim());
        }
        return fromDb;
    }
}
