package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.model.Product;
import org.example.service.CategoryService;
import org.example.service.ProductService;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "ProductController", urlPatterns = {"/products", "/products/*"})
public class ProductController extends HttpServlet {

    private ProductService productService;
    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        productService = new ProductService();
        categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("admin".equals(action)) {
            request.setAttribute("products", productService.getAllProducts());
            request.setAttribute("categories", categoryService.getAllCategories());
            request.getRequestDispatcher("/admin/product.jsp").forward(request, response);
            return;
        }

        String categoryId = request.getParameter("category");
        request.setAttribute("categories", categoryService.getAllCategories());

        String selectedCategory = "all";
        String selectedCategoryName = "All Categories";

        List<Product> products;

        if (categoryId != null && !"all".equals(categoryId)) {
            products = productService.getProductsByCategory(categoryId);
        } else {
            products = productService.getAllProducts();
        }

        products = productService.applyPromotions(products);
        request.setAttribute("featuredProducts", products);
        request.setAttribute("selectedCategory", selectedCategory);
        request.setAttribute("selectedCategoryName", selectedCategoryName);
        request.setAttribute("totalProducts", products.size());

        request.getRequestDispatcher("/products.jsp").forward(request, response);

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addProduct(request);
        } else if ("update".equals(action)) {
            updateProduct(request);
        } else if ("delete".equals(action)) {
            deleteProduct(request);
        }

        response.sendRedirect(request.getContextPath() + "/products?action=admin");
    }

    private void addProduct(HttpServletRequest request) {
        Product product = new Product(
                UUID.randomUUID().toString(),
                request.getParameter("name"),
                Double.parseDouble(request.getParameter("price")),
                request.getParameter("description"),
                request.getParameter("categoryId"),
                request.getParameter("imageUrl"),
                Integer.parseInt(request.getParameter("stockQuantity"))
        );

        product.setActive(request.getParameter("active") != null);
        productService.addProduct(product);
    }


    private void updateProduct(HttpServletRequest request) {
        Product product = new Product(
                request.getParameter("id"),
                request.getParameter("name"),
                Double.parseDouble(request.getParameter("price")),
                request.getParameter("description"),
                request.getParameter("categoryId"),
                request.getParameter("imageUrl"),
                Integer.parseInt(request.getParameter("stockQuantity"))
        );

        product.setActive(request.getParameter("active") != null);
        productService.updateProduct(product);
    }


    private void deleteProduct(HttpServletRequest request) {
        productService.deleteProduct(request.getParameter("id"));
    }
}
