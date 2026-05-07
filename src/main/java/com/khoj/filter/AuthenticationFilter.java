package com.khoj.filter;

import com.khoj.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Central Security Filter for KHOJ.
 * Handles Authentication and Role-Based Access Control (RBAC) globally.
 */
@WebFilter(urlPatterns = {"/admin/*", "/landlord/*", "/tenant/*", "/AdminServlet", "/LandlordDashboard"})
public class AuthenticationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();

        // 1. Authentication Check: Is the user logged in?
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            // Not logged in -> Redirect to login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/views/auth/login.jsp?error=session_expired");
            return;
        }

        // 2. Authorization Check: Does the user have the right role for this path?
        String role = user.getRole();

        boolean isAuthorized = true;
        
        if (requestURI.contains("/admin") || requestURI.contains("/AdminServlet")) {
            if (!"ADMIN".equalsIgnoreCase(role)) isAuthorized = false;
        } 
        else if (requestURI.contains("/landlord") || requestURI.contains("/LandlordDashboard")) {
            if (!"LANDLORD".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) isAuthorized = false;
        } 
        else if (requestURI.contains("/tenant")) {
            if (!"TENANT".equalsIgnoreCase(role) && !"ADMIN".equalsIgnoreCase(role)) isAuthorized = false;
        }

        if (!isAuthorized) {
            // Logged in but unauthorized -> 403 Access Denied
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/views/auth/403-access-denied.jsp");
            return;
        }

        // 3. All checks passed -> Proceed to next filter or servlet
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
