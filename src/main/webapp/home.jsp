<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Home - IIT Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
        .category-card {
            transition: transform 0.3s;
            height: 100%;
        }
        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .product-card {
            transition: transform 0.3s;
            height: 100%;
        }
        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .product-img {
            height: 200px;
            object-fit: cover;
            width: 100%;
        }
        .promotion-card {
            border-left: 5px solid #28a745;
        }
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            color: white;
            padding: 60px 30px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>

    <jsp:include page="/shared/navbar.jsp" />

    <!-- Hero Section -->
    <div class="container mt-4">
        <div class="hero-section text-center">
            <h1 class="display-4 fw-bold">Welcome to IIT Store</h1>
            <p class="lead">Discover amazing products at great prices</p>
            <a href="/Test/products" class="btn btn-light btn-lg mt-3">
                <i class="bi bi-arrow-right"></i> Start Shopping
            </a>
        </div>
    </div>

    <!-- Promotions Section -->
    <c:if test="${not empty promotions}">
        <div class="container mt-4">
            <h2 class="mb-4"><i class="bi bi-megaphone text-success"></i> Current Promotions</h2>
            <div class="row">
                <c:forEach var="promotion" items="${promotions}">
                    <div class="col-md-6 mb-4">
                        <div class="card promotion-card h-100">
                            <div class="card-body">
                                <h5 class="card-title text-success">
                                    <i class="bi bi-percent"></i> ${promotion.title}
                                </h5>
                                <p class="card-text">${promotion.description}</p>
                                <div class="mb-3">
                                    <c:if test="${promotion.discountType == 'PERCENTAGE'}">
                                        <span class="badge bg-danger fs-6">${promotion.discountValue}% OFF</span>
                                    </c:if>
                                    <c:if test="${promotion.discountType == 'FIXED_AMOUNT'}">
                                        <span class="badge bg-danger fs-6">$${promotion.discountValue} OFF</span>
                                    </c:if>
                                </div>
                                <small class="text-muted">
                                    <i class="bi bi-calendar"></i> Valid until ${promotion.endDate}
                                </small>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </c:if>

    <!-- Featured Products Section -->
    <div class="container mt-5">
        <h2 class="mb-4"><i class="bi bi-star-fill text-warning"></i> Featured Products</h2>

        <c:choose>
            <c:when test="${not empty featuredProducts}">
                <div class="row">
                    <c:forEach var="product" items="${featuredProducts}" varStatus="status">
                        <c:if test="${status.index < 8}">
                            <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                                <div class="card product-card h-100">
                                    <img src="${product.imageUrl}"
                                         class="card-img-top product-img"
                                         alt="${product.name}"
                                         onerror="this.src='https://via.placeholder.com/300x200?text=Product+Image'">

                                    <div class="card-body d-flex flex-column">
                                        <h5 class="card-title">${product.name}</h5>
                                        <p class="card-text flex-grow-1 small">${product.description}</p>

                                        <div class="mt-auto">
                                            <p class="card-text">
                                                <strong class="text-primary fs-5">$${product.price}</strong>
                                                <c:if test="${product.stockQuantity > 0}">
                                                    <span class="badge bg-success float-end">In Stock</span>
                                                </c:if>
                                            </p>
                                        </div>
                                    </div>

                                    <div class="card-footer bg-transparent">
                                        <a href="/Test/products?action=view&id=${product.id}"
                                           class="btn btn-outline-primary w-100">
                                            View Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </c:forEach>
                </div>

                <div class="text-center mt-4">
                    <a href="/Test/products" class="btn btn-primary btn-lg">
                        <i class="bi bi-arrow-right"></i> View All Products
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info text-center py-5">
                    <h4>No featured products available</h4>
                    <p>Check back soon for new arrivals!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Browse by Category Section -->
    <div class="container mt-5 pt-5">
        <h2 class="mb-4"><i class="bi bi-compass text-primary"></i> Browse by Category</h2>
        <p class="text-muted mb-4">Explore our wide range of product categories</p>

        <div class="row">
            <c:forEach var="category" items="${categories}">
                <div class="col-md-3 col-6 mb-4">
                    <a href="/Test/products?category=${category.id}" class="text-decoration-none">
                        <div class="card category-card text-center h-100">
                            <div class="card-body">
                                <div class="mb-3">
                                    <div class="bg-primary bg-opacity-10 rounded-circle p-3 d-inline-block">
                                        <i class="bi bi-tag text-primary fs-4"></i>
                                    </div>
                                </div>
                                <h5 class="card-title">${category.name}</h5>
                                <p class="card-text text-muted small">${category.description}</p>
                                <span class="badge bg-primary">
                                    Browse Products
                                </span>
                            </div>
                        </div>
                    </a>
                </div>
            </c:forEach>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>