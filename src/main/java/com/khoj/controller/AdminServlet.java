package com.khoj.controller;

import com.khoj.model.User;
import com.khoj.service.AdminService;
import com.khoj.service.PropertyService;
import com.khoj.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet({"/AdminServlet", "/admin/rooms", "/admin/users"})
public class AdminServlet extends HttpServlet {
    private final AdminService adminService = new AdminService();
    private final UserService userService = new UserService();
    private final PropertyService propertyService = new PropertyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/views/auth/403-access-denied.jsp");
            return;
        }

        String path = request.getServletPath();

        if ("/admin/rooms".equals(path)) {
            request.setAttribute("rooms", propertyService.getAllProperties());
            request.getRequestDispatcher("/views/admin/rooms.jsp").forward(request, response);
            return;
        }

        if ("/admin/users".equals(path)) {
            request.setAttribute("users", userService.getAllUsers());
            request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
            return;
        }

        // Fetch Global Stats for Dashboard
        Map<String, Integer> summary = adminService.getSystemSummary();
        request.setAttribute("stats", summary);

        // Fetch User and Property tables
        request.setAttribute("users", userService.getAllUsers());
        request.setAttribute("properties", propertyService.getAllProperties());

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!checkAdmin(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = request.getParameter("action");
        if (action == null) return;

        switch (action) {
            case "deleteUser":
                int userId = Integer.parseInt(request.getParameter("userId"));
                userService.deleteUser(userId);
                break;
            
            case "verifyProperty":
                int propertyId = Integer.parseInt(request.getParameter("propertyId"));
                boolean verify = Boolean.parseBoolean(request.getParameter("verify"));
                adminService.verifyProperty(propertyId, verify);
                break;
                
            case "deactivateUser":
                int uId = Integer.parseInt(request.getParameter("userId"));
                userService.updateUserStatus(uId, "DEACTIVATED");
                break;
        }

        response.sendRedirect(request.getContextPath() + "/AdminServlet");
    }

    private boolean checkAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        return user != null && "ADMIN".equalsIgnoreCase(user.getRole());
    }
}
