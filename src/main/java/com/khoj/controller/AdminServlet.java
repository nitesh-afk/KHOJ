package com.khoj.controller;

import java.io.IOException;
import java.util.Map;

import com.khoj.service.AdminService;
import com.khoj.service.PropertyService;
import com.khoj.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet({"/AdminServlet", "/admin/rooms", "/admin/users", "/admin/messages", "/admin/message-detail", "/admin/analytics"})
public class AdminServlet extends HttpServlet {
    private final AdminService adminService = new AdminService();
    private final UserService userService = new UserService();
    private final PropertyService propertyService = new PropertyService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security Check
        com.khoj.model.User user = (com.khoj.model.User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=Unauthorized");
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

        if ("/admin/analytics".equals(path)) {
            request.setAttribute("topProperties", adminService.getTopProperties(5));
            request.setAttribute("statusBreakdown", adminService.getApplicationStatusBreakdown());
            request.setAttribute("monthlyUsers", adminService.getMonthlyUserRegistrations());
            request.setAttribute("pendingLandlords", adminService.getPendingLandlords());
            request.getRequestDispatcher("/views/admin/analytics.jsp").forward(request, response);
            return;
        }

        // Fetch Global Stats for Dashboard
        Map<String, Integer> summary = adminService.getSystemSummary();
        request.setAttribute("stats", summary);

        // Fetch User and Property tables
        request.setAttribute("tenants", adminService.getTenants());
        request.setAttribute("landlords", adminService.getLandlords());
        request.setAttribute("rooms", propertyService.getAllProperties());
        request.setAttribute("pendingProperties", adminService.getPendingProperties());

        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security Check
        com.khoj.model.User user = (com.khoj.model.User) request.getSession().getAttribute("user");
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=Unauthorized");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) return;

        switch (action) {
            case "deactivateUser":
                int deId = Integer.parseInt(request.getParameter("userId"));
                String deRole = request.getParameter("userRole");
                adminService.deactivateUser(deId, deRole);
                break;

            case "reactivateUser":
                int reId = Integer.parseInt(request.getParameter("userId"));
                adminService.reactivateUser(reId);
                break;

            case "deleteUser":
                int delId = Integer.parseInt(request.getParameter("userId"));
                adminService.deleteUser(delId);
                break;

            case "verifyProperty":
            case "approveRoom":
            case "approveProperty":
                int propertyId = Integer.parseInt(request.getParameter("propertyId") != null ? 
                                    request.getParameter("propertyId") : request.getParameter("roomId"));
                adminService.approveProperty(propertyId);
                break;

            case "rejectProperty":
                int rejectPropId = Integer.parseInt(request.getParameter("propertyId"));
                adminService.rejectProperty(rejectPropId);
                break;
                
            case "approveLandlord":
                int approveId = Integer.parseInt(request.getParameter("userId"));
                adminService.approveLandlord(approveId);
                break;

            case "rejectLandlord":
                int rejectId = Integer.parseInt(request.getParameter("userId"));
                adminService.rejectLandlord(rejectId);
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
