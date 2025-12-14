<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
    <title>Shopping Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/shared/navbar.jsp" />

    <div class="container mt-4">
        <h2>Shopping Cart</h2>

        <c:if test="${empty cartItems}">
            <div class="alert alert-info">
                Your cart is empty. <a href="${contextPath}/products">Continue shopping</a>
            </div>
        </c:if>

        <c:if test="${not empty cartItems}">
            <table class="table">
                <thead>
                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Quantity</th>
                        <th>Total</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td>
                                <img src="${item.imageUrl}" alt="${item.productName}" width="50" height="50">
                                ${item.productName}
                            </td>
                            <td>$${item.price}</td>
                            <td>
                                <form action="${contextPath}/cart/update" method="post" class="d-inline">
                                    <input type="hidden" name="productId" value="${item.productId}">
                                    <input type="number" name="quantity" value="${item.quantity}" min="1" class="form-control" style="width: 80px;" onchange="this.form.submit()">
                                </form>
                            </td>
                            <td>$${item.totalPrice}</td>
                            <td>
                                <form action="${contextPath}/cart/remove" method="post" class="d-inline">
                                    <input type="hidden" name="productId" value="${item.productId}">
                                    <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="3" class="text-end"><strong>Total:</strong></td>
                        <td><strong>$${total}</strong></td>
                        <td></td>
                    </tr>
                </tfoot>
            </table>

            <div class="d-flex justify-content-between">
                <a href="${contextPath}/products" class="btn btn-secondary">Continue Shopping</a>
                <a href="${contextPath}/cart/clear" class="btn btn-warning">Clear Cart</a>
                <a href="${contextPath}/checkout" class="btn btn-success">Proceed to Checkout</a>
            </div>
        </c:if>
    </div>
</body>
</html>