package com.khoj.controller;

import com.khoj.model.Application;
import com.khoj.model.User;
import com.khoj.service.ApplicationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet({"/ApplicationServlet", "/applications"})
public class ApplicationServlet extends HttpServlet {
    private final ApplicationService appService = new ApplicationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        List<Application> apps = appService.getApplicationsByLandlord(user.getId());
        request.setAttribute("applications", apps);
        
        request.getRequestDispatcher("/views/landlord/applications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int appId = Integer.parseInt(request.getParameter("appId"));
        String status = request.getParameter("status"); // ACCEPTED or REJECTED

        boolean success = appService.updateApplicationStatus(appId, status);
        
        if (success) {
            response.sendRedirect(request.getContextPath() + "/applications?msg=status_updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/applications?error=update_failed");
        }
    }
}
