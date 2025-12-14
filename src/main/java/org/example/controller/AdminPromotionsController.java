package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.model.User;
import org.example.service.CategoryService;
import org.example.service.ProductService;
import org.example.service.PromotionService;
import java.io.IOException;

@WebServlet("/admin/promotion")
public class AdminPromotionsController extends HttpServlet {
    private PromotionService promotionService;
    private ProductService productService;
    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        super.init();
        promotionService = new PromotionService();
        productService = new ProductService();
        categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.setAttribute("promotions", promotionService.getAllPromotions());
        request.setAttribute("products", productService.getAllProducts());
        request.setAttribute("categories", categoryService.getAllCategories());
        request.getRequestDispatcher("/admin/promotion.jsp").forward(request, response);
    }
}