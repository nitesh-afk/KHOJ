package com.khoj.controller;

import com.khoj.dao.AdminDAO;
import com.khoj.dao.RoomDAO;
import com.khoj.dao.UserDAO;
import com.khoj.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

/* Admin servlet*/

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private AdminDAO adminDAO = new AdminDAO();
    private UserDAO userDAO = new UserDAO();
    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // RBAC: Check if ADMIN
        if (!checkAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/views/auth/403-access-denied.jsp");
            return;
        }

        System.out.println("LOG: Admin access confirmed. Generating dashboard summary.");

        // Fetch Stats
        Map<String, Integer> summary = adminDAO.getSystemSummary();
        request.setAttribute("stats", summary);

        // Fetch User and Room tables
        request.setAttribute("users", userDAO.getAllUsers());
        request.setAttribute("rooms", roomDAO.getAllRooms());

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

        System.out.println("LOG: Admin action triggered: " + action);

        switch (action) {
            case "deleteUser":
                int userId = Integer.parseInt(request.getParameter("userId"));
                userDAO.deleteUser(userId);
                break;
            
            case "approveRoom":
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                boolean approve = Boolean.parseBoolean(request.getParameter("approve"));
                adminDAO.updateRoomStatus(roomId, approve);
                break;
                
            case "deactivateUser":
                int uId = Integer.parseInt(request.getParameter("userId"));
                userDAO.updateUserStatus(uId, "DEACTIVATED");
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
