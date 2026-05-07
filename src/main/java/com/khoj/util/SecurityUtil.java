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

    /**
     * Strips <script> tags and escapes dangerous HTML characters to prevent XSS.
     */
    public static String sanitizeHTML(String input) {
        if (input == null) return null;
        
        // 1. Strip script tags entirely (case-insensitive)
        String sanitized = input.replaceAll("(?i)<script.*?>.*?</script.*?>", "");
        
        // 2. Strip inline event handlers (e.g., onerror=, onload=)
        sanitized = sanitized.replaceAll("(?i)\\b(on[a-z]+)\\s*=", "");
        
        // 3. Strip 'javascript:' pseudo-protocols
        sanitized = sanitized.replaceAll("(?i)javascript:", "");
        
        // 4. Escape fundamental HTML entities
        sanitized = sanitized.replace("&", "&amp;")
                             .replace("<", "&lt;")
                             .replace(">", "&gt;")
                             .replace("\"", "&quot;")
                             .replace("'", "&#x27;");
                             
        return sanitized;
    }
}
