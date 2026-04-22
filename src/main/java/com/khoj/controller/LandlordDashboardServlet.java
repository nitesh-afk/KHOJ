package com.khoj.controller;

import com.khoj.dao.RoomDAO;
import com.khoj.model.Room;
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
    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Security Check: Session and Role
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            // Unauthorized access: Redirect to login
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp?error=unauthorized");
            return;
        }

        // 2. Fetch Data: Room listings and Statistics for this Landlord
        int ownerId = user.getId();
        List<Room> rooms = roomDAO.getRoomsByOwner(ownerId);
        int totalRooms = roomDAO.getRoomCount(ownerId, null);
        int activeRooms = roomDAO.getRoomCount(ownerId, "Available");

        // 3. Attach Data to Request Object
        request.setAttribute("rooms", rooms);
        request.setAttribute("totalRooms", totalRooms);
        request.setAttribute("activeRooms", activeRooms);

        // 4. Route to the Landlord Home JSP
        request.getRequestDispatcher("/views/landlord/home.jsp").forward(request, response);
    }
}
