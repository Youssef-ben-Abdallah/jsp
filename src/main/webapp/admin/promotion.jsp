<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Promotions</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../shared/navbar.jsp" />

    <div class="container mt-4">
        <h2>Manage Promotions</h2>

        <!-- Debug info -->
        <div class="alert alert-info">
            <p>Promotions loaded: ${not empty promotions ? promotions.size() : 0}</p>
            <p>Products loaded: ${not empty products ? products.size() : 0}</p>
            <p>Categories loaded: ${not empty categories ? categories.size() : 0}</p>
        </div>

        <!-- Add Promotion Form -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Create New Promotion</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/promotions" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <input type="text" name="title" class="form-control" placeholder="Promotion Title" required>
                        </div>
                        <div class="col-md-6">
                            <textarea name="description" class="form-control" placeholder="Description" rows="1"></textarea>
                        </div>
                        <div class="col-md-4">
                            <input type="number" step="0.01" name="discountValue" class="form-control" placeholder="Discount Value" required>
                        </div>
                        <div class="col-md-4">
                            <select name="discountType" class="form-select" required>
                                <option value="">Discount Type</option>
                                <option value="PERCENTAGE">Percentage (%)</option>
                                <option value="FIXED_AMOUNT">Fixed Amount ($)</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <div class="form-check mt-2">
                                <input type="checkbox" name="active" class="form-check-input" checked>
                                <label class="form-check-label">Active</label>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label>Start Date</label>
                            <input type="date" name="startDate" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>End Date</label>
                            <input type="date" name="endDate" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label>Apply to Product (Optional)</label>
                            <select name="productId" class="form-select">
                                <option value="">All Products</option>
                                <c:forEach var="product" items="${products}">
                                    <option value="${product.id}">${product.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label>Apply to Category (Optional)</label>
                            <select name="categoryId" class="form-select">
                                <option value="">All Categories</option>
                                <c:forEach var="category" items="${categories}">
                                    <option value="${category.id}">${category.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary">Create Promotion</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Promotions Table -->
        <div class="card">
            <div class="card-header">
                <h5>All Promotions
                    <c:choose>
                        <c:when test="${not empty promotions}">
                            (${promotions.size()})
                        </c:when>
                        <c:otherwise>
                            (0)
                        </c:otherwise>
                    </c:choose>
                </h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty promotions}">
                        <div class="table-responsive">
                            <table class="table table-striped">
                                <thead>
                                    <tr>
                                        <th>Title</th>
                                        <th>Discount</th>
                                        <th>Period</th>
                                        <th>Application</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="promotion" items="${promotions}">
                                        <tr>
                                            <td>
                                                <strong>${promotion.title}</strong>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">
                                                    <c:choose>
                                                        <c:when test="${promotion.discountType == 'PERCENTAGE'}">
                                                            ${promotion.discountValue}%
                                                        </c:when>
                                                        <c:when test="${promotion.discountType == 'FIXED_AMOUNT'}">
                                                            $${promotion.discountValue}
                                                        </c:when>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <small>
                                                    ${promotion.startDate} to ${promotion.endDate}
                                                </small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty promotion.productId}">
                                                        <span class="badge bg-primary">Product</span>
                                                    </c:when>
                                                    <c:when test="${not empty promotion.categoryId}">
                                                        <span class="badge bg-secondary">Category</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-light text-dark">All Products</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${promotion.active}">
                                                        <span class="badge bg-success">Active</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Inactive</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div class="btn-group btn-group-sm">
                                                    <!-- Edit Button -->
                                                    <button class="btn btn-warning" data-bs-toggle="modal"
                                                            data-bs-target="#editPromotionModal${promotion.id}">
                                                        Edit
                                                    </button>

                                                    <!-- Delete Button -->
                                                    <form action="${pageContext.request.contextPath}/promotions" method="post"
                                                          style="display:inline;"
                                                          onsubmit="return confirm('Delete promotion: ${promotion.title}?');">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${promotion.id}">
                                                        <button type="submit" class="btn btn-danger">Delete</button>
                                                    </form>
                                                </div>

                                                <!-- Edit Promotion Modal -->
                                                <div class="modal fade" id="editPromotionModal${promotion.id}" tabindex="-1">
                                                    <div class="modal-dialog modal-lg">
                                                        <div class="modal-content">
                                                            <form action="${pageContext.request.contextPath}/promotions" method="post">
                                                                <input type="hidden" name="action" value="update">
                                                                <input type="hidden" name="id" value="${promotion.id}">
                                                                <div class="modal-header">
                                                                    <h5 class="modal-title">Edit Promotion: ${promotion.title}</h5>
                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                                </div>
                                                                <div class="modal-body">
                                                                    <div class="row g-3">
                                                                        <div class="col-md-6">
                                                                            <label>Title</label>
                                                                            <input type="text" name="title" value="${promotion.title}"
                                                                                   class="form-control" required>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label>Description</label>
                                                                            <input type="text" name="description" value="${promotion.description}"
                                                                                   class="form-control">
                                                                        </div>
                                                                        <div class="col-md-4">
                                                                            <label>Discount Value</label>
                                                                            <input type="number" step="0.01" name="discountValue"
                                                                                   value="${promotion.discountValue}" class="form-control" required>
                                                                        </div>
                                                                        <div class="col-md-4">
                                                                            <label>Discount Type</label>
                                                                            <select name="discountType" class="form-select" required>
                                                                                <option value="PERCENTAGE" ${promotion.discountType == 'PERCENTAGE' ? 'selected' : ''}>
                                                                                    Percentage (%)
                                                                                </option>
                                                                                <option value="FIXED_AMOUNT" ${promotion.discountType == 'FIXED_AMOUNT' ? 'selected' : ''}>
                                                                                    Fixed Amount ($)
                                                                                </option>
                                                                            </select>
                                                                        </div>
                                                                        <div class="col-md-4">
                                                                            <div class="form-check mt-4">
                                                                                <input type="checkbox" name="active"
                                                                                       class="form-check-input" ${promotion.active ? 'checked' : ''}>
                                                                                <label class="form-check-label">Active</label>
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label>Start Date</label>
                                                                            <input type="date" name="startDate"
                                                                                   value="${promotion.startDate}" class="form-control" required>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label>End Date</label>
                                                                            <input type="date" name="endDate"
                                                                                   value="${promotion.endDate}" class="form-control" required>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label>Apply to Product</label>
                                                                            <select name="productId" class="form-select">
                                                                                <option value="">All Products</option>
                                                                                <c:forEach var="product" items="${products}">
                                                                                    <option value="${product.id}"
                                                                                            ${product.id == promotion.productId ? 'selected' : ''}>
                                                                                        ${product.name}
                                                                                    </option>
                                                                                </c:forEach>
                                                                            </select>
                                                                        </div>
                                                                        <div class="col-md-6">
                                                                            <label>Apply to Category</label>
                                                                            <select name="categoryId" class="form-select">
                                                                                <option value="">All Categories</option>
                                                                                <c:forEach var="category" items="${categories}">
                                                                                    <option value="${category.id}"
                                                                                            ${category.id == promotion.categoryId ? 'selected' : ''}>
                                                                                        ${category.name}
                                                                                    </option>
                                                                                </c:forEach>
                                                                            </select>
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
                            No promotions found. Create your first promotion above.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>