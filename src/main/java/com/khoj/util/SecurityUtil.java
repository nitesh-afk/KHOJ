package com.khoj.util;

import org.mindrot.jbcrypt.BCrypt;

public class SecurityUtil {

    /**
     * Hashes a plain text password using BCrypt.
     * @param password The plain text password.
     * @return The hashed password.
     */
    public static String hashPassword(String password) {
        return BCrypt.hashpw(password, BCrypt.gensalt(12));
    }

    /**
     * Verifies a plain text password against a hashed password.
     * @param plainPassword The plain text password.
     * @param hashedPassword The hashed password to check against.
     * @return true if the password matches, false otherwise.
     */
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
}
