<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <title>Login - IIT Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            padding: 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            margin: 0 auto 20px;
            display: block;
        }
    </style>
</head>
<body>
    <div class="login-container">
        <img src="${contextPath}/assets/img/avatar.png" alt="Avatar" class="avatar" onerror="this.src='https://via.placeholder.com/100'">
        <h2 class="text-center mb-4">Login to IIT Store</h2>

        <%-- Display error message if login failed --%>
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${requestScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <form action="${contextPath}/login" method="post">
            <div class="mb-3">
                <label for="email" class="form-label">Email Address</label>
                <input type="email" class="form-control" id="email" name="email"
                       placeholder="Enter your email" required>
            </div>

            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password"
                       placeholder="Enter your password" required>
            </div>

            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="remember" name="remember">
                <label class="form-check-label" for="remember">Remember me</label>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary" onclick="window.location.href='${contextPath}/home'">Login</button>
                <button type="button" class="btn btn-secondary">Cancel</button>
            </div>

            <div class="mt-3 text-center">
                <a href="#" class="text-decoration-none">Forgot password?</a>
            </div>
        </form>

        <hr class="my-4">

        <div class="text-center">
            <p class="mb-0">Don't have an account?</p>
            <a href="#" class="btn btn-outline-success btn-sm">Sign up</a>
        </div>

        <%-- Debug info (remove in production) --%>
        <div class="mt-3 text-center small text-muted">
            <p>Test Accounts:</p>
            <p>Admin: admin@example.com / admin123</p>
            <p>User: user@example.com / user123</p>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>