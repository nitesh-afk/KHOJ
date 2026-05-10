package com.khoj.filter;

import com.khoj.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class SessionFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Allow public resources and auth pages
        if (path.startsWith("/resources/") || path.startsWith("/views/auth/") || 
            path.equals("/login") || path.equals("/LoginServlet") || 
            path.equals("/register") || path.equals("/RegisterServlet") || 
            path.equals("/home") || path.equals("/about") || path.equals("/contact") || 
            path.equals("/") || path.equals("/property-detail")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login?error=SessionExpired");
            return;
        }

        // Role-based Journey Box enforcement
        if (path.startsWith("/admin") && !"ADMIN".equalsIgnoreCase(user.getRole())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home?error=UnauthorizedAdmin");
            return;
        }
        if (path.startsWith("/landlord") && !"LANDLORD".equalsIgnoreCase(user.getRole())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home?error=UnauthorizedLandlord");
            return;
        }
        if (path.startsWith("/tenant") && !"TENANT".equalsIgnoreCase(user.getRole())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/home?error=UnauthorizedTenant");
            return;
        }

        chain.doFilter(request, response);
    }
}
