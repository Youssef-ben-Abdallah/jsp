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

@WebServlet(name = "CategoryController", urlPatterns = {"/categories", "/categories/*"})
public class CategoryController extends HttpServlet {
    private CategoryService categoryService;
    private ProductService productService;

    @Override
    public void init() throws ServletException {
        super.init();
        categoryService = new CategoryService();
        productService = new ProductService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("admin".equals(action)) {
            request.setAttribute("categories", categoryService.getAllCategories());
            request.getRequestDispatcher("/admin/category.jsp").forward(request, response);
            return;
        }
        if ("view".equals(action)) {
            String categoryId = request.getParameter("id");
            request.setAttribute("selectedCategory", categoryId);
            request.setAttribute("categories", categoryService.getAllCategories());
            List<Product> products = productService.getProductsByCategory(categoryId);
            products = productService.applyPromotions(products);

            request.setAttribute("featuredProducts", products);

            categoryService.getAllCategories().forEach(cat -> {
                if (cat.getId().equals(categoryId)) {
                    request.setAttribute("selectedCategoryName", cat.getName());
                }
            });
            request.getRequestDispatcher("/products.jsp").forward(request, response);
            return;
        }
        request.setAttribute("categories", categoryService.getAllCategories());
        request.getRequestDispatcher("/categories.jsp").forward(request, response);
    }



    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        org.example.model.User user = (org.example.model.User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                addCategory(request);
            } else if ("update".equals(action)) {
                updateCategory(request);
            } else if ("delete".equals(action)) {
                deleteCategory(request);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        System.out.println("=== Redirecting with cache prevention ===");
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("Expires", "0");
        response.sendRedirect(request.getContextPath() + "/categories?action=admin");
    }

    private void addCategory(HttpServletRequest request) {
        org.example.model.Category category = new org.example.model.Category(
                UUID.randomUUID().toString(),
                request.getParameter("name"),
                request.getParameter("description")
        );

        categoryService.addCategory(category);
        System.out.println("Category added successfully");
    }

    private void updateCategory(HttpServletRequest request) {
        org.example.model.Category category = new org.example.model.Category(
                request.getParameter("id"),
                request.getParameter("name"),
                request.getParameter("description")
        );

        categoryService.updateCategory(category);
        System.out.println("Category updated successfully");
    }

    private void deleteCategory(HttpServletRequest request) {
        String categoryId = request.getParameter("id");
        categoryService.deleteCategory(categoryId);
        System.out.println("Category deleted successfully");
    }
}