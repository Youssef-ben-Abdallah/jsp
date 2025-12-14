package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.model.CartItem;
import org.example.model.Product;
import org.example.service.ProductService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "CartController", urlPatterns = {"/cart/add", "/cart/view", "/cart/update", "/cart/remove", "/cart/clear"})
public class CartController extends HttpServlet {
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        super.init();
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/cart/view".equals(path)) {
            viewCart(request, response);
        } else if ("/cart/clear".equals(path)) {
            clearCart(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/cart/add".equals(path)) {
            addToCart(request, response);
        } else if ("/cart/update".equals(path)) {
            updateCart(request, response);
        } else if ("/cart/remove".equals(path)) {
            removeFromCart(request, response);
        }
    }

    private List<CartItem> getCart(HttpSession session) {
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private void addToCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String productId = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        int quantity = 1; // Default value

        if (quantityParam != null && !quantityParam.isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityParam);
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        Optional<Product> productOpt = productService.getProductById(productId);
        if (productOpt.isPresent()) {
            Product product = productOpt.get();
            List<CartItem> cart = getCart(request.getSession());
            Optional<CartItem> existingItem = cart.stream()
                    .filter(item -> item.getProductId().equals(productId))
                    .findFirst();

            if (existingItem.isPresent()) {
                // Update quantity
                CartItem item = existingItem.get();
                item.setQuantity(item.getQuantity() + quantity);
            } else {
                // Add new item
                CartItem newItem = new CartItem(
                        product.getId(),
                        product.getName(),
                        product.getPrice(),
                        quantity,
                        product.getImageUrl()
                );
                cart.add(newItem);
            }

            request.getSession().setAttribute("cart", cart);
        }

        response.sendRedirect(request.getContextPath() + "/cart/view");
    }

    private void viewCart(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<CartItem> cart = getCart(request.getSession());
        double total = cart.stream()
                .mapToDouble(CartItem::getTotalPrice)
                .sum();

        request.setAttribute("cartItems", cart);
        request.setAttribute("total", total);
        request.getRequestDispatcher("/cart/view.jsp").forward(request, response);
    }

    private void updateCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String productId = request.getParameter("productId");
        String quantityParam = request.getParameter("quantity");
        int quantity = 1;

        if (quantityParam != null && !quantityParam.isEmpty()) {
            try {
                quantity = Integer.parseInt(quantityParam);
            } catch (NumberFormatException e) {
                quantity = 1;
            }
        }

        List<CartItem> cart = getCart(request.getSession());
        for (int i = 0; i < cart.size(); i++) {
            CartItem item = cart.get(i);
            if (item.getProductId().equals(productId)) {
                if (quantity > 0) {
                    item.setQuantity(quantity);
                } else {
                    cart.remove(i);
                }
                break;
            }
        }

        response.sendRedirect(request.getContextPath() + "/cart/view");
    }

    private void removeFromCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String productId = request.getParameter("productId");
        List<CartItem> cart = getCart(request.getSession());
        cart.removeIf(item -> item.getProductId().equals(productId));
        response.sendRedirect(request.getContextPath() + "/cart/view");
    }

    private void clearCart(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.getSession().removeAttribute("cart");
        response.sendRedirect(request.getContextPath() + "/cart/view");
    }
}