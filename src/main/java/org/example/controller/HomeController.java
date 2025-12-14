package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.model.Category;
import org.example.model.Product;
import org.example.model.Promotion;
import org.example.service.CategoryService;
import org.example.service.ProductService;
import org.example.service.PromotionService;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeController", urlPatterns = {"/", "/home"})
public class HomeController extends HttpServlet {
    private CategoryService categoryService;
    private ProductService productService;
    private PromotionService promotionService;

    @Override
    public void init() throws ServletException {
        super.init();
        categoryService = new CategoryService();
        productService = new ProductService();
        promotionService = new PromotionService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== HomeController: Loading home page ===");

        try {
            List<Category> allCategories = categoryService.getAllCategories();
            List<Product> allProducts = productService.getAllProducts();
            productService.applyPromotions(allProducts);
            List<Product> featuredProducts = allProducts.size() > 8 ?
                    allProducts.subList(0, 8) : allProducts;
            List<Promotion> promotions = promotionService.getActivePromotions();
            request.setAttribute("categories", allCategories);
            request.setAttribute("featuredProducts", featuredProducts);
            request.setAttribute("promotions", promotions);
            request.setAttribute("totalProducts", allProducts.size());

            request.getRequestDispatcher("/home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading home page: " + e.getMessage());
        }
    }
}