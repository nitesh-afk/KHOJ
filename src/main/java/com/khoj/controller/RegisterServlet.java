package com.khoj.controller;

import com.khoj.dao.UserDAO;
import com.khoj.model.User;
import com.khoj.util.SecurityUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

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

        // 3. Secure the Password (Hashing)
        String hashedPassword = SecurityUtil.hashPassword(password);

        // 4. Create User Model Object
        User newUser = new User(fullName, email, hashedPassword, role, "ACTIVE");

        // 5. Use DAO to save to Database
        try {
            boolean success = userDAO.registerUser(newUser);
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