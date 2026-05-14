package com.khoj.controller;

import com.khoj.model.User;
import com.khoj.service.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet({"/LoginServlet", "/login"})
public class LoginServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("userEmail".equals(c.getName()) && c.getValue() != null && !c.getValue().isBlank()) {
                    request.setAttribute("prefillEmail", c.getValue());
                    break;
                }
            }
        }

        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String ctx = request.getContextPath();
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");

        User user = userService.authenticate(email, password);

        if (user == null) {
            response.sendRedirect(ctx + "/views/auth/login.jsp?error=invalid");
            return;
        }

        // Tenant accounts awaiting admin activation cannot sign in yet
        if ("PENDING".equalsIgnoreCase(user.getStatus())) {
            response.sendRedirect(ctx + "/views/auth/login.jsp?error=pending_approval");
            return;
        }

        if (!"ACTIVE".equalsIgnoreCase(user.getStatus())) {
            response.sendRedirect(ctx + "/views/auth/login.jsp?error=account_deactivated");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // Optional "remember me" cookie for email pre-fill (not an auth token)
        if ("on".equals(rememberMe) && email != null && !email.isBlank()) {
            Cookie userCookie = new Cookie("userEmail", email);
            userCookie.setMaxAge(7 * 24 * 60 * 60);
            String path = ctx == null || ctx.isEmpty() ? "/" : ctx;
            userCookie.setPath(path);
            userCookie.setHttpOnly(true);
            response.addCookie(userCookie);
        }

        String role = user.getRole();
        if ("ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(ctx + "/admin/dashboard");
        } else if ("LANDLORD".equalsIgnoreCase(role)) {
            response.sendRedirect(ctx + "/landlord/dashboard");
        } else {
            response.sendRedirect(ctx + "/tenant/dashboard");
        }
    }
}
