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

@WebServlet({"/RoomServlet", "/my-rooms"})
public class RoomServlet extends HttpServlet {
    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security Check
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        // Fetch All Rooms for this Landlord
        List<Room> rooms = roomDAO.getRoomsByOwner(user.getId());
        request.setAttribute("rooms", rooms);
        
        // Forward to the Inventory View
        request.getRequestDispatcher("/views/landlord/my-rooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Security Check
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }

        // Capture Room Data
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String location = request.getParameter("location");
        double price = Double.parseDouble(request.getParameter("price"));
        String roomType = request.getParameter("roomType");
        String imageUrl = request.getParameter("imageUrl");

        // Create Model
        Room room = new Room();
        room.setOwnerId(user.getId());
        room.setTitle(title);
        room.setDescription(description);
        room.setLocation(location);
        room.setPrice(price);
        room.setRoomType(roomType);
        room.setImageUrl(imageUrl);
        room.setStatus("Available");

        // Save to DB
        boolean success = roomDAO.addRoom(room);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/LandlordDashboard?msg=room_added");
        } else {
            response.sendRedirect(request.getContextPath() + "/views/landlord/add-room.jsp?error=failed");
        }
    }
}
