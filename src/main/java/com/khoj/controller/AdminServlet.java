package com.khoj.controller;

import com.khoj.service.AdminService;
import com.khoj.service.PropertyService;
import com.khoj.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Map;

@WebServlet({"/AdminServlet", "/admin/rooms", "/admin/users", "/admin/messages", "/admin/message-detail"})
public class AdminServlet extends HttpServlet {
    private final AdminService adminService = new AdminService();
    private final UserService userService = new UserService();
    private final PropertyService propertyService = new PropertyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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

        if ("/admin/messages".equals(path)) {
            com.khoj.dao.AdminDAO adminDAO = new com.khoj.dao.AdminDAO();
            request.setAttribute("messages", adminDAO.getAllMessages());
            request.getRequestDispatcher("/views/admin/messages.jsp").forward(request, response);
            return;
        }

        if ("/admin/message-detail".equals(path)) {
            int messageId = Integer.parseInt(request.getParameter("id"));
            com.khoj.dao.AdminDAO adminDAO = new com.khoj.dao.AdminDAO();
            
            // 1. Mark as READ automatically if it's currently NEW
            adminDAO.markAsReadIfNew(messageId);
            
            // 2. Fetch the full message object
            com.khoj.model.Message message = adminDAO.getMessageById(messageId);
            request.setAttribute("message", message);
            
            request.getRequestDispatcher("/views/admin/message-detail.jsp").forward(request, response);
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
                
            case "updateMessageStatus":
                int messageId = Integer.parseInt(request.getParameter("messageId"));
                String status = request.getParameter("status");
                com.khoj.dao.AdminDAO adminDAO = new com.khoj.dao.AdminDAO();
                adminDAO.updateMessageStatus(messageId, status);
                response.sendRedirect(request.getContextPath() + "/admin/messages?msg=status_updated");
                return;
        }

        response.sendRedirect(request.getContextPath() + "/AdminServlet");
    }

}
