package org.example.security.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.model.User;
import java.io.IOException;

@WebFilter(urlPatterns = {"/home", "/categories", "/products", "/cart/*", "/admin/*"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Allow public pages (including cart operations) without requiring login
        boolean isPublicPath = path.startsWith("/home")
                || path.startsWith("/products")
                || path.startsWith("/categories")
                || path.startsWith("/cart")
                || path.startsWith("/login")
                || path.equals("/");

        // Skip filter for JSP files and other static resources
        if (path.endsWith(".jsp") ||
                path.endsWith(".css") ||
                path.endsWith(".js") ||
                path.endsWith(".png") ||
                path.endsWith(".jpg")) {
            filterChain.doFilter(request, response);
            return;
        }

        User user = (User) req.getSession().getAttribute("user");

        // Public pages skip auth, admin routes stay protected
        if (isPublicPath) {
            filterChain.doFilter(request, response);
            return;
        }

        // Check if accessing admin routes
        if (path.contains("/admin/")) {
            if (user == null || !user.isAdmin()) {
                res.sendRedirect(req.getContextPath() + "/login");
                return;
            }
        } else {
            // For regular user routes
            if (user == null) {
                res.sendRedirect(req.getContextPath() + "/login");
                return;
            }
        }

        filterChain.doFilter(request, response);
    }
}