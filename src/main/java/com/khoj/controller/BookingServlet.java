package com.khoj.controller;

import com.khoj.dao.ApplicationDAO;
import com.khoj.model.Application;
import com.khoj.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/BookingServlet", "/my-bookings"})
public class BookingServlet extends HttpServlet {
    private ApplicationDAO appDAO = new ApplicationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"TENANT".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        List<Application> myApplications = appDAO.getApplicationsByTenant(user.getId());
        request.setAttribute("myApplications", myApplications);
        
        request.getRequestDispatcher("/views/tenant/my-bookings.jsp").forward(request, response);
    }
}
