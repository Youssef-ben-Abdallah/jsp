package org.example.model;

import java.time.LocalDate;

public class Promotion {
    private String id;
    private String title;
    private String description;
    private double discountValue;
    private String discountType; // "PERCENTAGE" or "FIXED_AMOUNT"
    private LocalDate startDate;
    private LocalDate endDate;
    private String productId; // null if promotion applies to all products
    private String categoryId; // null if promotion applies to all categories
    private boolean active;

    public Promotion() {}

    public Promotion(String id, String title, String description, double discountValue,
                     String discountType, LocalDate startDate, LocalDate endDate) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.discountValue = discountValue;
        this.discountType = discountType;
        this.startDate = startDate;
        this.endDate = endDate;
        this.active = true;
    }

    // Getters and setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public LocalDate getStartDate() { return startDate; }
    public void setStartDate(LocalDate startDate) { this.startDate = startDate; }

    public LocalDate getEndDate() { return endDate; }
    public void setEndDate(LocalDate endDate) { this.endDate = endDate; }

    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }

    public String getCategoryId() { return categoryId; }
    public void setCategoryId(String categoryId) { this.categoryId = categoryId; }

    public boolean isActive() {
        LocalDate today = LocalDate.now();
        return active && !today.isBefore(startDate) && !today.isAfter(endDate);
    }
    public void setActive(boolean active) { this.active = active; }

    public double applyDiscount(double originalPrice) {
        if (!isActive()) return originalPrice;

        if ("PERCENTAGE".equals(discountType)) {
            return originalPrice * (1 - discountValue / 100);
        } else if ("FIXED_AMOUNT".equals(discountType)) {
            return Math.max(0, originalPrice - discountValue);
        }
        return originalPrice;
    }
}