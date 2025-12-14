<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>${product.name} - IIT Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/shared/navbar.jsp" />

    <div class="container mt-4">
        <a href="products" class="btn btn-outline-secondary mb-3">← Back to Products</a>

        <div class="row">
            <div class="col-md-6">
                <img src="${product.imageUrl}" class="img-fluid rounded" alt="${product.name}">
            </div>
            <div class="col-md-6">
                <h2>${product.name}</h2>
                <p class="lead">$${product.price}</p>

                <div class="mb-3">
                    <span class="badge bg-info">${categoryName}</span>
                    <c:if test="${product.stockQuantity > 0}">
                        <span class="badge bg-success">In Stock (${product.stockQuantity})</span>
                    </c:if>
                    <c:if test="${product.stockQuantity <= 0}">
                        <span class="badge bg-danger">Out of Stock</span>
                    </c:if>
                </div>

                <p>${product.description}</p>

                <c:if test="${product.stockQuantity > 0}">
                    <form action="cart/add" method="post" class="mb-3">
                        <input type="hidden" name="productId" value="${product.id}">
                        <div class="row g-3 align-items-center">
                            <div class="col-auto">
                                <label for="quantity" class="col-form-label">Quantity:</label>
                            </div>
                            <div class="col-auto">
                                <input type="number" id="quantity" name="quantity" value="1"
                                       min="1" max="${product.stockQuantity}" class="form-control">
                            </div>
                            <div class="col-auto">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="bi bi-cart-plus"></i> Add to Cart
                                </button>
                            </div>
                        </div>
                    </form>
                </c:if>

                <c:if test="${product.stockQuantity <= 0}">
                    <div class="alert alert-warning">
                        This product is currently out of stock. Please check back later.
                    </div>
                </c:if>

                <div class="mt-4">
                    <h5>Product Details</h5>
                    <ul>
                        <li>Category: ${categoryName}</li>
                        <li>Available Quantity: ${product.stockQuantity}</li>
                        <li>Product ID: ${product.id}</li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>