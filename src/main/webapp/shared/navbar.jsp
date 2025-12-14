<%-- /shared/navbar.jsp --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
    Object user = session.getAttribute("user");
    String fullname = null;
    boolean isAdmin = false;
    int cartCount = 0;

    Object cartCountObj = session.getAttribute("cartCount");
    if (cartCountObj instanceof Integer) {
        cartCount = (Integer) cartCountObj;
    }

    if (user != null) {
        try {
            Class<?> userClass = user.getClass();
            java.lang.reflect.Method getFullname = userClass.getMethod("getFullname");
            java.lang.reflect.Method isAdminMethod = userClass.getMethod("isAdmin");
            fullname = (String) getFullname.invoke(user);
            isAdmin = (Boolean) isAdminMethod.invoke(user);
        } catch (Exception e) {
            // Ignore
        }
    }

    // Check if we're on admin pages
    boolean onAdminPage = request.getRequestURI().contains("/admin/");
%>

<nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
        <a class="navbar-brand" href="<%= contextPath %>/home">
            <%= onAdminPage ? "Admin Panel" : "IIT Store" %>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <ul class="navbar-nav me-auto">
                <!-- Home - for all users -->
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().endsWith("/home") ? "active" : "" %>"
                       href="<%= contextPath %>/home">Home</a>
                </li>

                <!-- Products - for all users -->
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().contains("/products") && !onAdminPage ? "active" : "" %>"
                       href="<%= contextPath %>/products">Products</a>
                </li>

                <!-- Cart - for all users -->
                <li class="nav-item">
                    <a class="nav-link <%= request.getRequestURI().contains("/cart") ? "active" : "" %>"
                       href="<%= contextPath %>/cart/view">Cart
                        <% if (cartCount > 0) { %>
                            <span class="badge bg-primary"><%= cartCount %></span>
                        <% } %>
                    </a>
                </li>

                <!-- ADMIN ONLY: Links to admin CRUD pages -->
                <% if (isAdmin) { %>
                    <!-- Manage Categories CRUD -->
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("/admin/category") ? "active" : "" %>"
                           href="<%= contextPath %>/admin/category">Manage Categories</a>
                    </li>

                    <!-- Manage Products CRUD -->
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("/admin/product") ? "active" : "" %>"
                           href="<%= contextPath %>/admin/product">Manage Products</a>
                    </li>

                    <!-- Manage Promotions -->
                    <li class="nav-item">
                        <a class="nav-link <%= request.getRequestURI().contains("/admin/promotion") ? "active" : "" %>"
                           href="<%= contextPath %>/admin/promotion">Manage Promotions</a>
                    </li>
                <% } %>
            </ul>

            <div class="navbar-nav">
                <% if (fullname != null) { %>
                    <span class="navbar-text me-3">
                        <%= fullname %>
                    </span>
                    <a href="<%= contextPath %>/logout"
                       class="btn btn-outline-danger btn-sm">
                        Logout
                    </a>
                <% } else { %>
                    <a href="<%= contextPath %>/login"
                       class="btn btn-outline-primary btn-sm">
                        Login
                    </a>
                <% } %>
            </div>
        </div>
    </div>
</nav>