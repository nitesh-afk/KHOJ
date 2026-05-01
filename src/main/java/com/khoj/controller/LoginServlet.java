package com.khoj.controller;

import com.khoj.model.User;
import com.khoj.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userService.authenticate(email, password);

        if (user != null) {
            // 1. Status Check (RBAC requirement)
            if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
                response.sendRedirect("views/auth/login.jsp?error=account_deactivated");
                return;
            }

            // 2. Create Session
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // 3. Unified Routing (TENANTS go to the Premium Home Page)
            String role = user.getRole();
            if ("ADMIN".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/AdminServlet");
            } else if ("LANDLORD".equalsIgnoreCase(role)) {
                response.sendRedirect(request.getContextPath() + "/LandlordDashboard");
            } else if ("TENANT".equalsIgnoreCase(role)) {
                // Point to the servlet that fetches property discovery data
                response.sendRedirect(request.getContextPath() + "/search");
            } else {
                response.sendRedirect("search");
            }
        } else {
            response.sendRedirect("views/auth/login.jsp?error=invalid");
        }
    }
}
