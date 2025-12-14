package org.example.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.example.model.Promotion;
import org.example.model.User;
import org.example.service.CategoryService;
import org.example.service.ProductService;
import org.example.service.PromotionService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.UUID;

@WebServlet(name = "PromotionController", urlPatterns = {"/promotions", "/promotions/*"})
public class PromotionController extends HttpServlet {

    private PromotionService promotionService;
    private ProductService productService;
    private CategoryService categoryService;

    @Override
    public void init() throws ServletException {
        promotionService = new PromotionService();
        productService = new ProductService();
        categoryService = new CategoryService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null || !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addPromotion(request);
        } else if ("update".equals(action)) {
            updatePromotion(request);
        } else if ("delete".equals(action)) {
            deletePromotion(request);
        }
        response.sendRedirect(request.getContextPath() + "/promotions?action=admin");
    }

    private void addPromotion(HttpServletRequest request) {

        Promotion promotion = new Promotion(
                UUID.randomUUID().toString(),
                request.getParameter("title"),
                request.getParameter("description"),
                Double.parseDouble(request.getParameter("discountValue")),
                request.getParameter("discountType"),
                LocalDate.parse(request.getParameter("startDate")),
                LocalDate.parse(request.getParameter("endDate"))
        );

        promotion.setProductId(normalizeNullable(request.getParameter("productId")));
        promotion.setCategoryId(normalizeNullable(request.getParameter("categoryId")));
        promotion.setActive(request.getParameter("active") != null);

        promotionService.addPromotion(promotion);
    }

    private void updatePromotion(HttpServletRequest request) {

        Promotion promotion = new Promotion(
                request.getParameter("id"),
                request.getParameter("title"),
                request.getParameter("description"),
                Double.parseDouble(request.getParameter("discountValue")),
                request.getParameter("discountType"),
                LocalDate.parse(request.getParameter("startDate")),
                LocalDate.parse(request.getParameter("endDate"))
        );

        promotion.setProductId(normalizeNullable(request.getParameter("productId")));
        promotion.setCategoryId(normalizeNullable(request.getParameter("categoryId")));
        boolean active = request.getParameter("active") != null;
        promotion.setActive(active);

        promotionService.updatePromotion(promotion);
    }

    private void deletePromotion(HttpServletRequest request) {
        promotionService.deletePromotion(request.getParameter("id"));
    }

    private String normalizeNullable(String value) {
        return (value == null || value.isBlank()) ? null : value;
    }
}
