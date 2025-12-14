<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Products</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../shared/navbar.jsp" />

    <div class="container mt-4">
        <h2>Manage Products</h2>

        <!-- Debug info -->
        <div class="alert alert-info">
            <p>Products loaded: ${not empty products ? products.size() : 0}</p>
            <p>Categories loaded: ${not empty categories ? categories.size() : 0}</p>
        </div>

        <!-- Add Product Form -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Add New Product</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/products" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <input type="text" name="name" class="form-control" placeholder="Product Name" required>
                        </div>
                        <div class="col-md-6">
                            <input type="number" step="0.01" name="price" class="form-control" placeholder="Price" required>
                        </div>
                        <div class="col-md-12">
                            <textarea name="description" class="form-control" placeholder="Description" rows="2"></textarea>
                        </div>
                        <div class="col-md-4">
                            <select name="categoryId" class="form-select" required>
                                <option value="">Select Category</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}">${category.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <input type="text" name="imageUrl" class="form-control" placeholder="Image URL">
                        </div>
                        <div class="col-md-2">
                            <input type="number" name="stockQuantity" class="form-control" placeholder="Stock" value="0">
                        </div>
                        <div class="col-md-2">
                            <div class="form-check mt-2">
                                <input type="checkbox" name="active" class="form-check-input" checked>
                                <label class="form-check-label">Active</label>
                            </div>
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">Add Product</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Products Table -->
        <div class="card">
            <div class="card-header">
                <h5>All Products
                    <c:choose>
                        <c:when test="${not empty products}">
                            (${products.size()})
                        </c:when>
                        <c:otherwise>
                            (0)
                        </c:otherwise>
                    </c:choose>
                </h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty products}">
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Name</th>
                                        <th>Price</th>
                                        <th>Category</th>
                                        <th>Stock</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="product" items="${products}">
                                        <tr>
                                            <td>${product.id}</td>
                                            <td>
                                                <strong>${product.name}</strong>
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$"/>
                                            </td>
                                            <td>
                                                <c:forEach var="category" items="${categories}">
                                                    <c:if test="${category.id == product.categoryId}">
                                                        <span class="badge bg-info">${category.name}</span>
                                                    </c:if>
                                                </c:forEach>
                                            </td>
                                            <td>${product.stockQuantity}</td>
                                            <td>
                                                <span class="${product.active ? 'text-success' : 'text-secondary'}">
                                                    ${product.active ? 'Active' : 'Inactive'}
                                                </span>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <!-- Edit Button -->
                                                    <button class="btn btn-warning" data-bs-toggle="modal"
                                                            data-bs-target="#editProductModal${product.id}">
                                                        Edit
                                                    </button>

                                                    <!-- Delete Button -->
                                                    <form action="${pageContext.request.contextPath}/products" method="post"
                                                          style="display:inline;"
                                                          onsubmit="return confirm('Delete product: ${product.name}?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${product.id}">
                                                        <button type="submit" class="btn btn-danger">Delete</button>
                                                    </form>
                                                </div>

                                                <!-- Edit Product Modal -->
                                                <div class="modal fade" id="editProductModal${product.id}" tabindex="-1">
                                                    <div class="modal-dialog modal-lg">
                                                        <div class="modal-content">
                                                            <form action="${pageContext.request.contextPath}/products" method="post">
                                                                <input type="hidden" name="action" value="update">
                                                                <input type="hidden" name="id" value="${product.id}">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title">Edit Product: ${product.name}</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <div class="row g-3">
                                                                        <div class="col-md-6">
                                                                            <label>Product Name</label>
                                                                            <input type="text" name="name" value="${product.name}"
                                                                                   class="form-control" required>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label>Price</label>
                                                                            <input type="number" step="0.01" name="price"
                                                                                   value="${product.price}" class="form-control" required>
                                                                        </div>
                                                                        <div class="col-12">
                                                                            <label>Description</label>
                                                                            <textarea name="description" class="form-control"
                                                                                      rows="3">${product.description}</textarea>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label>Category</label>
                                                                            <select name="categoryId" class="form-select" required>
                                                                                <c:forEach var="category" items="${categories}">
                                                                                    <option value="${category.id}"
                                                                                            ${category.id == product.categoryId ? 'selected' : ''}>
                                                                                        ${category.name}
                                                                                    </option>
                                                                                </c:forEach>
                                                                            </select>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label>Image URL</label>
                                                                            <input type="text" name="imageUrl" value="${product.imageUrl}"
                                                                                   class="form-control">
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label>Stock Quantity</label>
                                                                            <input type="number" name="stockQuantity"
                                                                                   value="${product.stockQuantity}" class="form-control">
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <div class="form-check mt-4">
                                                                                <input type="checkbox" name="active"
                                                                                       class="form-check-input" ${product.active ? 'checked' : ''}>
                                                                                <label class="form-check-label">Active Product</label>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                                <div class="modal-footer">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    <button type="submit" class="btn btn-primary">Save Changes</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning">
                            No products found. Add your first product above.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>