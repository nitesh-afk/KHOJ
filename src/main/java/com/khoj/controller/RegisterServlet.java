package com.khoj.controller;

import com.khoj.model.User;
import com.khoj.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/RegisterServlet", "/register"})
public class RegisterServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ctx = request.getContextPath();

        // 1. Capture form data
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phoneNumber = request.getParameter("phoneNumber");
        String role = request.getParameter("role");

        // 2. Full name: letters and spaces only (server-side)
        if (fullName == null || !fullName.matches("^[A-Za-z ]+$")) {
            response.sendRedirect(ctx + "/register?error=invalid_name");
            return;
        }

        // 3. Email format
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            response.sendRedirect(ctx + "/register?error=invalid_email");
            return;
        }

        // 4. Password strength
        if (password == null || password.length() < 6) {
            response.sendRedirect(ctx + "/register?error=weak_password");
            return;
        }

        // 5. Phone required at registration + uniqueness
        if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
            response.sendRedirect(ctx + "/register?error=invalid_phone");
            return;
        }
        phoneNumber = phoneNumber.trim();
        if (userService.isPhoneTaken(phoneNumber)) {
            response.sendRedirect(ctx + "/register?error=phone_taken");
            return;
        }

        // 6. Email uniqueness
        if (userService.isEmailTaken(email)) {
            response.sendRedirect(ctx + "/register?error=email_taken");
            return;
        }

        // 7. Initial account status / landlord onboarding flags
        String initialStatus;
        String initialApproval;
        if ("TENANT".equalsIgnoreCase(role)) {
            initialStatus = "PENDING";
            initialApproval = "APPROVED";
        } else if ("LANDLORD".equalsIgnoreCase(role)) {
            initialStatus = "ACTIVE";
            initialApproval = "PENDING";
        } else {
            initialStatus = "ACTIVE";
            initialApproval = "APPROVED";
        }

        User newUser = new User(fullName.trim(), email.trim(), password, role, initialStatus);
        newUser.setPhoneNumber(phoneNumber);
        newUser.setApprovalStatus(initialApproval);

        try {
            boolean success = userService.registerUser(newUser);
            if (success) {
                response.sendRedirect(ctx + "/views/auth/login.jsp?msg=success");
            } else {
                response.sendRedirect(ctx + "/register?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(ctx + "/register?error=exception");
        }
    }
}
