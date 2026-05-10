package com.khoj.controller;

import com.khoj.dao.MessageDAO;
import com.khoj.dao.PropertyDAO;
import com.khoj.model.Message;
import com.khoj.model.Property;
import com.khoj.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/messages")
public class MessageServlet extends HttpServlet {
    private final MessageDAO messageDAO = new MessageDAO();
    private final PropertyDAO propertyDAO = new PropertyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/LoginServlet");
            return;
        }

        String otherUserIdStr = request.getParameter("with");
        String propertyIdStr = request.getParameter("property");

        try {
            if (otherUserIdStr != null && propertyIdStr != null) {
                int otherUserId = Integer.parseInt(otherUserIdStr);
                int propertyId = Integer.parseInt(propertyIdStr);
                
                // Fetch conversation
                List<Message> chat = messageDAO.getConversation(user.getId(), otherUserId, propertyId);
                
                // Mark as read
                messageDAO.markMessagesAsRead(user.getId(), propertyId);
                
                // Get property details for context
                Property property = propertyDAO.getPropertyById(propertyId);
                
                request.setAttribute("chat", chat);
                request.setAttribute("property", property);
                request.setAttribute("otherUserId", otherUserId);
            }
            
            // Always fetch inbox for the sidebar
            List<Message> inbox = messageDAO.getInbox(user.getId());
            request.setAttribute("inbox", inbox);
            
            request.getRequestDispatcher("/views/messages.jsp").forward(request, response);
            
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home?error=MessageError");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String receiverIdStr = request.getParameter("receiverId");
        String propertyIdStr = request.getParameter("propertyId");
        String content = request.getParameter("content");

        if (receiverIdStr != null && propertyIdStr != null && content != null && !content.trim().isEmpty()) {
            try {
                int receiverId = Integer.parseInt(receiverIdStr);
                int propertyId = Integer.parseInt(propertyIdStr);
                
                Message msg = new Message();
                msg.setSenderId(user.getId());
                msg.setReceiverId(receiverId);
                msg.setPropertyId(propertyId);
                msg.setContent(content.trim());
                
                boolean sent = messageDAO.sendMessage(msg);
                
                if (sent) {
                    response.sendRedirect(request.getContextPath() + "/messages?with=" + receiverId + "&property=" + propertyId);
                } else {
                    response.sendRedirect(request.getContextPath() + "/messages?error=NoApplicationFound");
                }
            } catch (SQLException | NumberFormatException e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/messages?error=SendFailed");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/messages");
        }
    }
}
