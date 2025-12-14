package org.example.model;

public class Product {
    private String id;
    private String name;
    private double price;
    private Double discountedPrice;
    private double discountPercent;
    private String promotionName;
    private String description;
    private String categoryId;
    private String imageUrl;
    private int stockQuantity;
    private boolean active;
    private Promotion promotion; // add getter and setter

    public Promotion getPromotion() { return promotion; }
    public void setPromotion(Promotion promotion) { this.promotion = promotion; }

    public Product() {}

    public Product(String id, String name, double price, String description,
                   String categoryId, String imageUrl, int stockQuantity) {
        this.id = id;
        this.name = name;
        this.price = price;
        this.description = description;
        this.categoryId = categoryId;
        this.imageUrl = imageUrl;
        this.stockQuantity = stockQuantity;
        this.active = true;
    }

    // Getters and setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategoryId() { return categoryId; }
    public void setCategoryId(String categoryId) { this.categoryId = categoryId; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public boolean hasPromotion() {
        return discountedPrice != null;
    }
}