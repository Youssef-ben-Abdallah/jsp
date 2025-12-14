<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Products - IIT Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
    <style>
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
        .category-dropdown {
            max-width: 300px;
        }
        .filter-info {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .stock-badge {
            font-size: 0.8rem;
            padding: 4px 8px;
        }
    </style>
</head>
<body>
    <jsp:include page="/shared/navbar.jsp" />

    <!-- Main Content -->
    <div class="container mt-4">
        <!-- Category Filter Section -->
        <div class="row mb-4 align-items-center">
            <div class="col-md-8">
                <div class="d-flex align-items-center">
                    <i class="bi bi-filter-circle fs-4 text-primary me-3"></i>
                    <div class="me-3">
                        <h5 class="mb-0">Filter Products by Category</h5>
                        <small class="text-muted">Select a category to view specific products</small>
                    </div>

                    <!-- Category Dropdown -->
                    <div class="dropdown">
                        <button class="btn btn-outline-primary dropdown-toggle" type="button"
                                id="categoryDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                            <i class="bi bi-tags me-2"></i>
                            <c:choose>
                                <c:when test="${selectedCategory == 'all'}">
                                    All Categories
                                </c:when>
                                <c:otherwise>
                                    ${selectedCategoryName}
                                </c:otherwise>
                            </c:choose>
                        </button>
                        <ul class="dropdown-menu category-dropdown" aria-labelledby="categoryDropdown">
                            <li>
                                <a class="dropdown-item ${selectedCategory == 'all' ? 'active' : ''}"
                                   href="products?category=all">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span>All Categories</span>
                                    </div>
                                </a>
                            </li>
                            <li><hr class="dropdown-divider"></li>
                            <c:forEach var="category" items="${categories}">
                                <li>
                                    <a class="dropdown-item ${selectedCategory == category.id ? 'active' : ''}"
                                       href="products?category=${category.id}">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span>${category.name}</span>
                                        </div>
                                        <small class="text-muted d-block mt-1">${category.description}</small>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>

                    <!-- Clear Filter Button -->
                    <c:if test="${selectedCategory != 'all'}">
                        <a href="products?category=all" class="btn btn-outline-secondary ms-3">
                            <i class="bi bi-x-circle"></i> Clear Filter
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- Filter Info Card -->
        <div class="filter-info mb-4">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h6 class="mb-0">
                        <i class="bi bi-info-circle text-primary me-2"></i>
                        <c:choose>
                            <c:when test="${selectedCategory == 'all'}">
                                Showing <strong>all ${totalProducts} products</strong> from all categories
                            </c:when>
                            <c:otherwise>
                                Showing <strong>${featuredProducts.size()} products</strong> from
                                <strong class="text-primary">${selectedCategoryName}</strong>
                            </c:otherwise>
                        </c:choose>
                    </h6>
                </div>
            </div>
        </div>

        <!-- Products Grid -->
        <h2 class="mb-4">
            <c:choose>
                <c:when test="${selectedCategory == 'all'}">
                    <i class="bi bi-star-fill text-warning"></i> All Products
                </c:when>
                <c:otherwise>
                    <i class="bi bi-tag-fill text-primary"></i> ${selectedCategoryName}
                </c:otherwise>
            </c:choose>
        </h2>

        <c:choose>
            <c:when test="${not empty featuredProducts}">
                <div class="row" id="productsGrid">
                    <c:forEach var="product" items="${featuredProducts}">
                        <div class="col-lg-3 col-md-4 col-sm-6 mb-4">
                            <div class="card product-card h-100">
                                <!-- Product Image -->
                                <div class="position-relative">
                                    <img src="${product.imageUrl}"
                                         class="card-img-top product-img"
                                         alt="${product.name}"
                                         onerror="this.src='https://via.placeholder.com/300x200?text=Product+Image'">

                                    <!-- Category Badge -->
                                    <div class="position-absolute top-0 start-0 m-2">
                                        <c:forEach var="cat" items="${categories}">
                                            <c:if test="${cat.id == product.categoryId}">
                                                <span class="badge bg-dark opacity-75">${cat.name}</span>
                                            </c:if>
                                        </c:forEach>
                                    </div>

                                    <!-- Stock Status Badge -->
                                    <div class="position-absolute top-0 end-0 m-2">
                                        <c:if test="${product.hasPromotion()}">
                                            <div class="badge bg-danger position-absolute top-0 end-0 m-2" style="right: 0; top: 40px;">
                                                ${product.promotionName} - ${product.discountPercent}% Off
                                            </div>
                                        </c:if>
                                        <c:choose>
                                            <c:when test="${product.stockQuantity > 10}">
                                                <span class="badge bg-success stock-badge">In Stock</span>
                                            </c:when>
                                            <c:when test="${product.stockQuantity > 0 && product.stockQuantity <= 10}">
                                                <span class="badge bg-warning stock-badge">Low Stock</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger stock-badge">Out of Stock</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Product Body -->
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title" style="height: 48px; overflow: hidden;">
                                        ${product.name}
                                    </h5>
                                    <p class="card-text text-muted small flex-grow-1"
                                       style="height: 60px; overflow: hidden;">
                                        ${product.description}
                                    </p>

                                    <div class="mt-auto">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <div>
                                                <c:choose>
                                                    <c:when test="${product.hasPromotion()}">
                                                        <span class="text-danger fs-5 fw-bold">
                                                            $${product.discountedPrice}
                                                        </span>
                                                        <br>
                                                        <small class="text-muted text-decoration-line-through">
                                                            $${product.price}
                                                        </small>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-primary fs-4 fw-bold">
                                                            $${product.price}
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                                <c:if test="${product.stockQuantity <= 10 && product.stockQuantity > 0}">
                                                    <small class="text-warning d-block">
                                                        <i class="bi bi-exclamation-triangle"></i> Only ${product.stockQuantity} left!
                                                    </small>
                                                </c:if>
                                            </div>
                                            <c:if test="${product.stockQuantity > 0}">
                                                <form action="${pageContext.request.contextPath}/cart/add" method="post" class="d-inline">
                                                    <input type="hidden" name="productId" value="${product.id}">
                                                    <input type="hidden" name="quantity" value="1">
                                                    <button type="submit" class="btn btn-primary btn-sm">
                                                        <i class="bi bi-cart-plus"></i> Add
                                                    </button>
                                                </form>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>

                                <!-- Card Footer -->
                                <div class="card-footer bg-transparent border-top-0 pt-0">
                                    <div class="d-grid gap-2">
                                        <a href="/Test/products?action=view&id=${product.id}"
                                           class="btn btn-outline-secondary">
                                            <i class="bi bi-eye"></i> View Details
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

            </c:when>
            <c:otherwise>
                <!-- No Products Found -->
                <div class="text-center py-5">
                    <div class="mb-4">
                        <i class="bi bi-search display-1 text-muted"></i>
                    </div>
                    <h4 class="mb-3">No products found</h4>
                    <p class="text-muted mb-4">
                        <c:choose>
                            <c:when test="${selectedCategory == 'all'}">
                                There are no products available at the moment. Please check back later.
                            </c:when>
                            <c:otherwise>
                                No products found in the "${selectedCategoryName}" category.
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <div class="d-flex justify-content-center gap-3">
                        <a href="products?category=all" class="btn btn-primary">
                            <i class="bi bi-house-door"></i> View All Products
                        </a>
                        <a href="/Test/categories" class="btn btn-outline-primary">
                            <i class="bi bi-tags"></i> Browse Categories
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- JavaScript for Interactive Features -->
    <script>
        // Update dropdown button text
        document.addEventListener('DOMContentLoaded', function() {
            const dropdownButton = document.getElementById('categoryDropdown');
            const activeItem = document.querySelector('.dropdown-item.active');

            if (activeItem) {
                const activeText = activeItem.querySelector('span:first-child').textContent;
                const icon = dropdownButton.querySelector('i');
                dropdownButton.innerHTML = icon.outerHTML + ' ' + activeText.trim();
            }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>