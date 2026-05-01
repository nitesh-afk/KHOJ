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

        if (user == null) {
            response.sendRedirect("views/auth/login.jsp");
            return;
        }

        String propertyIdStr = request.getParameter("propertyId");
        if (propertyIdStr != null) {
            int propertyId = Integer.parseInt(propertyIdStr);
            boolean success = appDAO.applyForProperty(user.getId(), propertyId);

            if (success) {
                response.sendRedirect("search?msg=applied");
            } else {
                response.sendRedirect("property-detail?id=" + propertyId + "&error=failed");
            }
        } else {
            response.sendRedirect("search");
        }
    }
}
