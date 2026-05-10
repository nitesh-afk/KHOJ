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
public class ApplicationServlet extends HttpServlet {
    private final ApplicationDAO applicationDAO = new ApplicationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"TENANT".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet?error=Unauthorized");
            return;
        }

        String propertyIdStr = request.getParameter("propertyId");
        if (propertyIdStr != null) {
            try {
                int propertyId = Integer.parseInt(propertyIdStr);
                int result = applicationDAO.applyForProperty(user.getId(), propertyId);

                if (result == 1) {
                    request.getSession().setAttribute("successMsg", "Success! Application sent.");
                    response.sendRedirect(request.getContextPath() + "/tenant/dashboard");
                } else {
                    request.getSession().setAttribute("warningMsg", "Warning: You have already applied.");
                    response.sendRedirect(request.getContextPath() + "/property-detail?id=" + propertyId);
                }
            } catch (java.sql.SQLException e) {
                e.printStackTrace();
                request.getSession().setAttribute("errorMsg", "System busy. Please try again later.");
                response.sendRedirect(request.getContextPath() + "/home");
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/home?error=InvalidId");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }
}
