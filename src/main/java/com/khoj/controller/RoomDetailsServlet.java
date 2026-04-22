package com.khoj.controller;

import com.khoj.dao.RoomDAO;
import com.khoj.model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/RoomDetails")
public class RoomDetailsServlet extends HttpServlet {
    private RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int roomId = Integer.parseInt(idParam);
            Room room = roomDAO.getRoomById(roomId);
            request.setAttribute("room", room);
            request.getRequestDispatcher("/views/tenant/room-details.jsp").forward(request, response);
        } else {
            response.sendRedirect("search");
        }
    }
}
