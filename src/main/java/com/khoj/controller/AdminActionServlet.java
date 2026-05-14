package com.khoj.controller;

import com.khoj.dao.AdminDAO;
import com.khoj.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/admin/verify-property", "/admin/approve-landlord", "/admin/reject-landlord", "/admin/approve-tenant", "/admin/update-user-status", "/admin/deactivate-user", "/admin/reactivate-user", "/admin/delete-user", "/admin/delete-property", "/admin/update-message-status"})
public class AdminActionServlet extends HttpServlet {
    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login?error=Unauthorized");
            return;
        }

        String path = request.getServletPath();
        boolean success = false;

        try {
            switch (path) {
                case "/admin/verify-property":
                    int propId = Integer.parseInt(request.getParameter("propertyId"));
                    boolean verify = Boolean.parseBoolean(request.getParameter("verify"));
                    success = adminDAO.verifyProperty(propId, verify);
                    String returnPath = request.getParameter("returnPath");
                    if ("rooms".equals(returnPath)) {
                        response.sendRedirect(request.getContextPath() + "/admin/rooms?verified=" + success);
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/dashboard?verified=" + success);
                    }
                    break;

                case "/admin/delete-property":
                    int deletePropId = Integer.parseInt(request.getParameter("propertyId"));
                    success = adminDAO.deleteProperty(deletePropId);
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard?deleted=" + success);
                    break;

                case "/admin/approve-landlord":
                    int landlordIdApprove = Integer.parseInt(request.getParameter("userId"));
                    success = adminDAO.approveLandlord(landlordIdApprove);
                    response.sendRedirect(request.getContextPath() + "/admin/users?success=" + success);
                    break;

                case "/admin/reject-landlord":
                    int landlordIdReject = Integer.parseInt(request.getParameter("userId"));
                    success = adminDAO.rejectLandlord(landlordIdReject);
                    response.sendRedirect(request.getContextPath() + "/admin/users?success=" + success);
                    break;

                case "/admin/approve-tenant":
                    int tenantIdApprove = Integer.parseInt(request.getParameter("userId"));
                    success = adminDAO.approveTenant(tenantIdApprove);
                    response.sendRedirect(request.getContextPath() + "/admin/users?success=" + success);
                    break;

                case "/admin/update-user-status":
                    int userId = Integer.parseInt(request.getParameter("userId"));
                    String status = request.getParameter("status");
                    success = adminDAO.setUserStatus(userId, status);
                    response.sendRedirect(request.getContextPath() + "/admin/users?success=" + success);
                    break;
                case "/admin/deactivate-user":
                    int deId = Integer.parseInt(request.getParameter("userId"));
                    success = adminDAO.setUserStatus(deId, "INACTIVE");
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=" + success);
                    break;
                case "/admin/reactivate-user":
                    int reId = Integer.parseInt(request.getParameter("userId"));
                    success = adminDAO.setUserStatus(reId, "ACTIVE");
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=" + success);
                    break;
                case "/admin/delete-user":
                    int delId = Integer.parseInt(request.getParameter("userId"));
                    success = adminDAO.deleteUser(delId);
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard?success=" + success);
                    break;
                case "/admin/update-message-status":
                    int messageId = Integer.parseInt(request.getParameter("messageId"));
                    String statusStr = request.getParameter("status");
                    success = adminDAO.updateMessageStatus(messageId, statusStr);
                    response.sendRedirect(request.getContextPath() + "/admin/messages?success=" + success);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/dashboard?error=ActionFailed");
        }
    }
}
