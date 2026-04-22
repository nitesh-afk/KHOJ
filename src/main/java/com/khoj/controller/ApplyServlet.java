package com.khoj.controller;

import com.khoj.dao.ApplicationDAO;
import com.khoj.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ApplyServlet")
public class ApplyServlet extends HttpServlet {
    private ApplicationDAO appDAO = new ApplicationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"TENANT".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        int roomId = Integer.parseInt(request.getParameter("roomId"));
        boolean success = appDAO.applyForRoom(user.getId(), roomId);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/search?msg=applied");
        } else {
            response.sendRedirect(request.getContextPath() + "/RoomDetails?id=" + roomId + "&error=failed");
        }
    }
}
