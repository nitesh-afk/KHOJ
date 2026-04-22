package com.khoj.controller;

import com.khoj.dao.UserDAO;
import com.khoj.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.loginUser(email, password);

        if (user != null) {
            // Create Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Role-based Redirection
            String role = user.getRole();
            if ("ADMIN".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/AdminServlet");
            } else if ("LANDLORD".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/LandlordDashboard");
            } else if ("TENANT".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/search");
            } else {
                response.sendRedirect("index.jsp");
            }
        } else {
            // Login failed
            response.sendRedirect("views/auth/login.jsp?error=invalid");
        }
    }
}
