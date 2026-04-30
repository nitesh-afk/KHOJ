package com.khoj.controller;

import com.khoj.dao.PropertyDAO;
import com.khoj.model.Property;
import com.khoj.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/LandlordDashboard")
public class LandlordDashboardServlet extends HttpServlet {
    private PropertyDAO propertyDAO = new PropertyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=unauthorized");
            return;
        }

        int landlordId = user.getId();
        List<Property> properties = propertyDAO.getPropertiesByLandlord(landlordId);
        int totalProperties = propertyDAO.getPropertyCount(landlordId);

        request.setAttribute("properties", properties);
        request.setAttribute("totalProperties", totalProperties);

        request.getRequestDispatcher("/views/landlord/home.jsp").forward(request, response);
    }
}
