package com.khoj.controller;

import com.khoj.model.User;
import com.khoj.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Capture Form Data
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // 2. Server-Side Validation (Audit Requirement)
        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            response.sendRedirect("views/auth/register.jsp?error=invalid_email");
            return;
        }
        if (password == null || password.length() < 6) {
            response.sendRedirect("views/auth/register.jsp?error=weak_password");
            return;
        }

        // 3. Check if email already exists (Business Logic)
        if (userService.isEmailTaken(email)) {
            response.sendRedirect("views/auth/register.jsp?error=email_taken");
            return;
        }

        // 4. Create User Model Object (Note: Service will hash the password)
        User newUser = new User(fullName, email, password, role, "ACTIVE");

        // 5. Use Service to save to Database
        try {
            boolean success = userService.registerUser(newUser);
            if (success) {
                response.sendRedirect("views/auth/login.jsp?msg=success");
            } else {
                response.sendRedirect("views/auth/register.jsp?error=failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("views/auth/register.jsp?error=exception");
        }
    }
}