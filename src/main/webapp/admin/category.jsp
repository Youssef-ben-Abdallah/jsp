<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Categories</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="../shared/navbar.jsp" />

    <div class="container mt-4">
        <h2>Manage Categories</h2>

        <!-- Debug info -->
        <div class="alert alert-info">
            <p>Categories loaded: ${not empty categories ? categories.size() : 0}</p>
        </div>

        <!-- Add Category Form -->
        <div class="card mb-4">
            <div class="card-header">
                <h5>Add New Category</h5>
            </div>
            <div class="card-body">
                <form action="${pageContext.request.contextPath}/categories" method="post">
                    <input type="hidden" name="action" value="add">
                    <div class="row">
                        <div class="col-md-4">
                            <input type="text" name="name" class="form-control" placeholder="Category Name" required>
                        </div>
                        <div class="col-md-6">
                            <input type="text" name="description" class="form-control" placeholder="Description" required>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">Add</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Categories Table -->
        <div class="card">
            <div class="card-header">
                <h5>All Categories
                    <c:choose>
                        <c:when test="${not empty categories}">
                            (${categories.size()})
                        </c:when>
                        <c:otherwise>
                            (0)
                        </c:otherwise>
                    </c:choose>
                </h5>
            </div>
            <div class="card-body">
                <c:choose>
                    <c:when test="${not empty categories}">
                        <table class="table table-striped">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="category" items="${categories}">
                                    <tr>
                                        <td>${category.id}</td>
                                        <td>${category.name}</td>
                                        <td>${category.description}</td>
                                        <td>
                                            <!-- Edit Button -->
                                            <button class="btn btn-sm btn-warning" data-bs-toggle="modal"
                                                    data-bs-target="#editModal${category.id}">Edit</button>

                                            <!-- Delete Form -->
                                            <form action="${pageContext.request.contextPath}/categories" method="post"
                                                  style="display:inline;" onsubmit="return confirm('Delete this category?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${category.id}">
                                                <button type="submit" class="btn btn-sm btn-danger">Delete</button>
                                            </form>

                                            <!-- Edit Modal -->
                                            <div class="modal fade" id="editModal${category.id}" tabindex="-1">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <form action="${pageContext.request.contextPath}/categories" method="post">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="id" value="${category.id}">
                                                            <div class="modal-header">
                                                                <h5 class="modal-title">Edit Category</h5>
                                                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                                            </div>
                                                            <div class="modal-body">
                                                                <div class="mb-3">
                                                                    <label>Name</label>
                                                                    <input type="text" name="name" value="${category.name}"
                                                                           class="form-control" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label>Description</label>
                                                                    <input type="text" name="description" value="${category.description}"
                                                                           class="form-control" required>
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
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning">
                            No categories found. Add your first category above.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
    console.log("=== DEBUG: Script loading ===");

    // Wait for full page load
    window.onload = function() {
        console.log("=== DEBUG: Page fully loaded ===");

        // Get all forms
        var forms = document.querySelectorAll('form');
        console.log("Found " + forms.length + " forms on page");

        // Add submit handler to each form
        forms.forEach(function(form, index) {
            console.log("Form " + index + " action: " + form.action);

            form.addEventListener('submit', function(event) {
                console.log("=== Form " + index + " submitting ===");
                console.log("Form action: " + this.action);
                console.log("Form method: " + this.method);

                // Show what data is being submitted
                var formData = new FormData(this);
                for (var pair of formData.entries()) {
                    console.log(pair[0] + ': ' + pair[1]);
                }

                // Set a flag in sessionStorage to indicate we need to reload
                sessionStorage.setItem('shouldReload', 'true');

                // Continue with normal submission
                // The page will redirect, then we'll check the flag
            });
        });
    };

    // Check if we should reload when page loads
    if (sessionStorage.getItem('shouldReload') === 'true') {
        console.log("=== Should reload page ===");
        sessionStorage.removeItem('shouldReload'); // Clear flag

        // Wait a bit then reload
        setTimeout(function() {
            console.log("=== Reloading page now ===");
            window.location.reload(true); // Force reload from server
        }, 500);
    }
    </script>

    <!-- Add this to see if page is being called -->
    <div id="debugInfo" style="display: none;"></div>
    <script>
    document.getElementById('debugInfo').textContent = "Page loaded at: " + new Date().toLocaleTimeString();
    console.log("Debug timestamp: " + new Date().toLocaleTimeString());
    </script>
</body>
</html>