package com.khoj.controller;

import com.khoj.dao.RoomDAO;
import com.khoj.model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet({"/SearchServlet", "/search"})
public class SearchServlet extends HttpServlet {
    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String query = request.getParameter("query");
        List<Room> rooms;

        if (query == null || query.trim().isEmpty()) {
            rooms = roomDAO.searchRooms(""); // Fetch all available rooms
        } else {
            rooms = roomDAO.searchRooms(query);
        }

        request.setAttribute("rooms", rooms);
        request.setAttribute("searchQuery", query);
        
        request.getRequestDispatcher("/views/tenant/dashboard.jsp").forward(request, response);
    }
}
