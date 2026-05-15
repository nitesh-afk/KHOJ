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
    private static final String NAME_REGEX = "^[A-Za-z .'-]+$";
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

        User profileUser = userService.getUserForProfile(sessionUser);
        if (profileUser == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=unauthorized");
            return;
        }
        session.setAttribute("user", profileUser);

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

        if ("updateProfile".equalsIgnoreCase(action)) {
            handleProfileUpdate(request, response, session, sessionUser);
            return;
        }

        if ("updatePassword".equalsIgnoreCase(action)) {
            handlePasswordUpdate(request, response, session, sessionUser);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/profile?error=invalid_action");
    }

    private void handleProfileUpdate(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            User sessionUser) throws IOException {
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

        User existingUser = userService.getUserForProfile(sessionUser);
        if (existingUser == null) {
            response.sendRedirect(request.getContextPath() + "/profile?error=user_not_found");
            return;
        }

        String trimmedEmail = email.trim();
        if (userService.isEmailTaken(trimmedEmail, existingUser.getId())) {
            response.sendRedirect(request.getContextPath() + "/profile?error=duplicate_email");
            return;
        }

        existingUser.setFullName(fullName.trim());
        existingUser.setEmail(trimmedEmail);
        existingUser.setPhoneNumber(phone);
        // Profile image is kept as is for now, but ready for extension
        
        boolean updated = userService.updateUserProfile(existingUser);
        if (!updated) {
            response.sendRedirect(request.getContextPath() + "/profile?error=update_failed");
            return;
        }

        User refreshedUser = userService.getUserForProfile(existingUser);
        session.setAttribute("user", refreshedUser != null ? refreshedUser : existingUser);
        response.sendRedirect(request.getContextPath() + "/profile?success=true");
    }

    private void handlePasswordUpdate(HttpServletRequest request, HttpServletResponse response, HttpSession session,
            User sessionUser) throws IOException {
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

        User existingUser = userService.getUserForProfile(sessionUser);
        if (existingUser == null) {
            response.sendRedirect(request.getContextPath() + "/profile?error=user_not_found");
            return;
        }

        if (!SecurityUtil.verifyPassword(currentPassword, existingUser.getPassword())) {
            response.sendRedirect(request.getContextPath() + "/profile?error=invalid_current_password");
            return;
        }

        String newHashedPassword = SecurityUtil.hashPassword(newPassword);
        boolean updated = userService.updatePassword(existingUser.getId(), newHashedPassword);
        if (!updated) {
            response.sendRedirect(request.getContextPath() + "/profile?error=update_failed");
            return;
        }

        User refreshedUser = userService.getUserForProfile(sessionUser);
        if (refreshedUser != null) {
            session.setAttribute("user", refreshedUser);
        }
        response.sendRedirect(request.getContextPath() + "/profile?success=true");
    }
}
