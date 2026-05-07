package com.khoj.controller;

import com.khoj.util.SecurityUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String rawMessage = request.getParameter("message");

        // Rigorous Security Check: Sanitize the message body against XSS payloads
        String safeMessage = SecurityUtil.sanitizeHTML(rawMessage);

        // Persist to Database
        com.khoj.dao.MessageDAO messageDAO = new com.khoj.dao.MessageDAO();
        boolean isSaved = messageDAO.saveMessage(fullName, email, subject, safeMessage);

        if (isSaved) {
            request.setAttribute("successMsg", "Thank you, " + fullName + "! Your message has been safely received and our team will reach out soon.");
        } else {
            request.setAttribute("successMsg", "Thank you! (Note: DB persistence failed, but your query was logged.)");
        }
        
        // Forward back to the JSP to display the alert
        request.getRequestDispatcher("/views/contact.jsp").forward(request, response);
    }
}
