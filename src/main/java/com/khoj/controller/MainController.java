package com.khoj.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/admin/dashboard", "/landlord/dashboard", "/tenant/dashboard", "/tenant/applications", "/admin/property-verification", "/admin/user-approval", "/landlord/inbound-applications", "/admin/messages", "/admin/message-detail", "/admin/analytics", "/ViewApplications"})
public class MainController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();

        switch (path) {
            case "/admin/dashboard":
                com.khoj.dao.AdminDAO adminDAO = new com.khoj.dao.AdminDAO();
                request.setAttribute("stats", adminDAO.getSystemSummary());
                request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
                break;
            case "/admin/property-verification":
                com.khoj.dao.AdminDAO adminDAOVerify = new com.khoj.dao.AdminDAO();
                request.setAttribute("rooms", adminDAOVerify.getUnverifiedProperties());
                request.getRequestDispatcher("/views/admin/rooms.jsp").forward(request, response);
                break;
            case "/admin/user-approval":
                com.khoj.dao.AdminDAO adminDAOUsers = new com.khoj.dao.AdminDAO();
                request.setAttribute("landlords", adminDAOUsers.getPendingLandlords());
                request.getRequestDispatcher("/views/admin/users.jsp").forward(request, response);
                break;
            case "/admin/messages":
                com.khoj.dao.AdminDAO adminDAOMsg = new com.khoj.dao.AdminDAO();
                request.setAttribute("messages", adminDAOMsg.getAllMessages());
                request.getRequestDispatcher("/views/admin/messages.jsp").forward(request, response);
                break;
            case "/admin/message-detail":
                int messageId = Integer.parseInt(request.getParameter("id"));
                com.khoj.dao.AdminDAO adminDAODetail = new com.khoj.dao.AdminDAO();
                adminDAODetail.markAsReadIfNew(messageId);
                request.setAttribute("message", adminDAODetail.getMessageById(messageId));
                request.getRequestDispatcher("/views/admin/message-detail.jsp").forward(request, response);
                break;
            case "/admin/analytics":
                com.khoj.service.AdminService adminService = new com.khoj.service.AdminService();
                request.setAttribute("topProperties", adminService.getTopProperties(5));
                request.setAttribute("statusBreakdown", adminService.getApplicationStatusBreakdown());
                request.setAttribute("monthlyUsers", adminService.getMonthlyUserRegistrations());
                request.setAttribute("pendingLandlords", adminService.getPendingLandlords());
                request.getRequestDispatcher("/views/admin/analytics.jsp").forward(request, response);
                break;
            case "/landlord/dashboard":
                com.khoj.model.User landlord = (com.khoj.model.User) request.getSession().getAttribute("user");
                com.khoj.dao.PropertyDAO propDAO = new com.khoj.dao.PropertyDAO();
                request.setAttribute("properties", propDAO.getPropertiesByLandlord(landlord.getId()));
                request.setAttribute("stats", propDAO.getPropertyCountByStatus(landlord.getId()));
                com.khoj.dao.MessageDAO msgDAO = new com.khoj.dao.MessageDAO();
                try {
                    request.setAttribute("unreadMessages", msgDAO.getTotalUnreadCount(landlord.getId()));
                } catch (Exception e) { e.printStackTrace(); }
                request.getRequestDispatcher("/views/landlord/dashboard.jsp").forward(request, response);
                break;
            case "/landlord/inbound-applications":
                com.khoj.model.User landlordApps = (com.khoj.model.User) request.getSession().getAttribute("user");
                com.khoj.dao.ApplicationDAO appDAO = new com.khoj.dao.ApplicationDAO();
                request.setAttribute("applications", appDAO.getApplicationsByLandlord(landlordApps.getId()));
                request.getRequestDispatcher("/views/landlord/applications.jsp").forward(request, response);
                break;
            case "/tenant/dashboard":
                com.khoj.model.User tenant = (com.khoj.model.User) request.getSession().getAttribute("user");
                com.khoj.dao.NotificationDAO notifDAO = new com.khoj.dao.NotificationDAO();
                request.setAttribute("notifications", notifDAO.getNotificationsByUser(tenant.getId()));
                com.khoj.dao.MessageDAO tenantMsgDAO = new com.khoj.dao.MessageDAO();
                try {
                    request.setAttribute("unreadMessages", tenantMsgDAO.getTotalUnreadCount(tenant.getId()));
                } catch (Exception e) { e.printStackTrace(); }
                
                // CRITICAL FIX: Fetch property types for the search filter
                com.khoj.service.PropertyService ps = new com.khoj.service.PropertyService();
                request.setAttribute("propertyTypes", ps.getAllPropertyTypes());
                
                request.getRequestDispatcher("/views/tenant/dashboard.jsp").forward(request, response);
                break;
            case "/ViewApplications":
            case "/tenant/applications":
                com.khoj.model.User tenantApps = (com.khoj.model.User) request.getSession().getAttribute("user");
                com.khoj.dao.ApplicationDAO tenantAppDAO = new com.khoj.dao.ApplicationDAO();
                request.setAttribute("myApplications", tenantAppDAO.getApplicationsByTenant(tenantApps.getId()));
                request.getRequestDispatcher("/views/tenant/my-bookings.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/home");
                break;
        }
    }
}
