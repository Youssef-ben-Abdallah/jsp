<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html>
<head>
    <title>${category.name} - IIT Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/shared/navbar.jsp" />

    <div class="container mt-4">

        <h2>${category.name}</h2>
        <p class="lead">${category.description}</p>

        <div class="row">
            <c:forEach var="product" items="${products}">
                <div class="col-md-3 mb-4">
                    <div class="card h-100">
                        <img src="${product.imageUrl}" class="card-img-top" alt="${product.name}"
                             style="height: 150px; object-fit: cover;">
                        <div class="card-body">
                            <h5 class="card-title">${product.name}</h5>
                            <p class="card-text">$${product.price}</p>
                            <form action="cart/add" method="post" class="d-inline">
                                <input type="hidden" name="productId" value="${product.id}">
                                <input type="number" name="quantity" value="1" min="1"
                                       max="${product.stockQuantity}" class="form-control mb-2">
                                <button type="submit" class="btn btn-primary btn-sm">Add to Cart</button>
                            </form>
                            <a href="products?action=view&id=${product.id}" class="btn btn-outline-secondary btn-sm">
                                Details
                            </a>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <c:if test="${empty products}">
            <div class="alert alert-info">
                No products available in this category.
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>