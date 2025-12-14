package org.example.repository;

import org.example.model.Product;
import org.example.util.JsonFileManager;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class ProductRepository {
    private final JsonFileManager<Product> jsonFileManager;
    private List<Product> products;

    public ProductRepository() {
        this.jsonFileManager = new JsonFileManager<>(Product.class);
        loadProducts();
    }

    private void loadProducts() {
        products = jsonFileManager.readFromFile("products.json");

        // Debug: Print each product
        for (Product product : products) {
            System.out.println("Product: " + product.getName() +
                    " (ID: " + product.getId() +
                    ", Price: " + product.getPrice() +
                    ", Category: " + product.getCategoryId() +
                    ", Active: " + product.isActive() + ")");
        }
    }

    private void saveProducts() {
        jsonFileManager.writeToFile("products.json", products);
    }

    public List<Product> getAllProducts() {
        return products.stream()
                .filter(Product::isActive)
                .collect(Collectors.toList());
    }

    public List<Product> getProductsByCategory(String categoryId) {
        return products.stream()
                .filter(product -> product.getCategoryId().equals(categoryId) && product.isActive())
                .collect(Collectors.toList());
    }

    public Optional<Product> getProductById(String id) {
        return products.stream()
                .filter(product -> product.getId().equals(id))
                .findFirst();
    }

    public void addProduct(Product product) {
        products.add(product);
        saveProducts();
    }

    public void updateProduct(Product updatedProduct) {
        products = products.stream()
                .map(product -> product.getId().equals(updatedProduct.getId()) ? updatedProduct : product)
                .collect(Collectors.toList());
        saveProducts();
    }

    public void deleteProduct(String id) {
        // Soft delete
        products.stream()
                .filter(product -> product.getId().equals(id))
                .findFirst()
                .ifPresent(product -> product.setActive(false));
        saveProducts();
    }

    public void reduceStock(String productId, int quantity) {
        products.stream()
                .filter(product -> product.getId().equals(productId))
                .findFirst()
                .ifPresent(product -> {
                    int newStock = product.getStockQuantity() - quantity;
                    product.setStockQuantity(Math.max(0, newStock));
                });
        saveProducts();
    }
}