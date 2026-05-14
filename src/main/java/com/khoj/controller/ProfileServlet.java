package com.khoj.controller;

import com.khoj.model.User;
import com.khoj.service.UserService;
import com.khoj.util.SecurityUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final String NAME_REGEX = "^[a-zA-Z '-]+$";
    private static final String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (sessionUser == null
                || (!"TENANT".equalsIgnoreCase(sessionUser.getRole())
                && !"LANDLORD".equalsIgnoreCase(sessionUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=unauthorized");
            return;
        }

        User profileUser = userService.getUserById(sessionUser.getId());
        
        if (profileUser == null) {
            // Check if we already have an error parameter to avoid redirect loops
            if (request.getParameter("error") == null) {
                response.sendRedirect(request.getContextPath() + "/profile?error=user_not_found");
            } else {
                // If we're already here with an error, don't redirect again.
                // Show the profile page with session data as fallback.
                request.setAttribute("profileUser", sessionUser);
                request.setAttribute("errorMessage", "Could not refresh profile data from database.");
                request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
            }
            return;
        }
        
        // Activity Summary Logic
        int activityCount = 0;
        if ("LANDLORD".equalsIgnoreCase(profileUser.getRole())) {
            com.khoj.dao.PropertyDAO propDAO = new com.khoj.dao.PropertyDAO();
            activityCount = propDAO.countPropertiesByLandlord(profileUser.getId());
            request.setAttribute("activityLabel", "Properties Listed");
        } else if ("TENANT".equalsIgnoreCase(profileUser.getRole())) {
            com.khoj.dao.ApplicationDAO appDAO = new com.khoj.dao.ApplicationDAO();
            activityCount = appDAO.countApplicationsByTenant(profileUser.getId());
            request.setAttribute("activityLabel", "Applications Sent");
        }
        
        request.setAttribute("activityCount", activityCount);
        request.setAttribute("profileUser", profileUser);
        request.getRequestDispatcher("/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User sessionUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (sessionUser == null
                || (!"TENANT".equalsIgnoreCase(sessionUser.getRole())
                && !"LANDLORD".equalsIgnoreCase(sessionUser.getRole()))) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=unauthorized");
            return;
        }

        String action = request.getParameter("action");
        int userId = sessionUser.getId();

        if ("updateProfile".equalsIgnoreCase(action)) {
            handleProfileUpdate(request, response, session, userId);
            return;
        }

        if ("updatePassword".equalsIgnoreCase(action)) {
            handlePasswordUpdate(request, response, session, userId);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/profile?error=invalid_action");
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            int userId) throws IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty() || !fullName.trim().matches(NAME_REGEX)) {
            response.sendRedirect(request.getContextPath() + "/profile?error=invalid_name");
            return;
        }

        if (email == null || !email.matches(EMAIL_REGEX)) {
            response.sendRedirect(request.getContextPath() + "/profile?error=invalid_email");
            return;
        }

        User existingUser = userService.getUserById(userId);
        if (existingUser == null) {
            response.sendRedirect(request.getContextPath() + "/profile?error=user_not_found");
            return;
        }

        boolean emailChanged = !email.equalsIgnoreCase(existingUser.getEmail());
        if (emailChanged && userService.isEmailTaken(email)) {
            response.sendRedirect(request.getContextPath() + "/profile?error=duplicate_email");
            return;
        }

        existingUser.setFullName(fullName.trim());
        existingUser.setEmail(email.trim());
        existingUser.setPhoneNumber(phone);
        // Profile image is kept as is for now, but ready for extension
        
        boolean updated = userService.updateUserProfile(existingUser);
        if (!updated) {
            response.sendRedirect(request.getContextPath() + "/profile?error=update_failed");
            return;
        }

        session.setAttribute("user", existingUser);
        response.sendRedirect(request.getContextPath() + "/profile?success=true");
    }

    private void handlePasswordUpdate(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            int userId) throws IOException {
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || !newPassword.equals(confirmPassword)) {
            response.sendRedirect(request.getContextPath() + "/profile?error=password_mismatch");
            return;
        }

        if (newPassword.length() < 8) {
            response.sendRedirect(request.getContextPath() + "/profile?error=password_too_short");
            return;
        }

        User existingUser = userService.getUserById(userId);
        if (existingUser == null) {
            response.sendRedirect(request.getContextPath() + "/profile?error=user_not_found");
            return;
        }

        if (!SecurityUtil.verifyPassword(currentPassword, existingUser.getPassword())) {
            response.sendRedirect(request.getContextPath() + "/profile?error=invalid_current_password");
            return;
        }

        String newHashedPassword = SecurityUtil.hashPassword(newPassword);
        boolean updated = userService.updatePassword(userId, newHashedPassword);
        if (!updated) {
            response.sendRedirect(request.getContextPath() + "/profile?error=update_failed");
            return;
        }

        User refreshedUser = userService.getUserById(userId);
        if (refreshedUser != null) {
            session.setAttribute("user", refreshedUser);
        }
        response.sendRedirect(request.getContextPath() + "/profile?success=true");
    }
}
