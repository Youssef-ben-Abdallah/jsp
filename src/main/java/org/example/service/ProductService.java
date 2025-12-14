package org.example.service;

import org.example.model.Product;
import org.example.model.Promotion;
import org.example.repository.ProductRepository;
import java.util.List;
import java.util.Optional;

public class ProductService {
    private final ProductRepository productRepository;
    private final PromotionService promotionService;

    public ProductService() {
        this.productRepository = new ProductRepository();
        this.promotionService = new PromotionService();
    }
    public List<Product> getAllProducts() {
        return productRepository.getAllProducts();
    }

    public List<Product> getProductsByCategory(String categoryId) {
        return getAllProducts()
                .stream()
                .filter(p -> p.getCategoryId().equals(categoryId) && p.isActive())
                .toList();
    }

    public List<Product> applyPromotions(List<Product> products) {
        List<Promotion> activePromotions = promotionService.getActivePromotions()
                .stream()
                .filter(promo -> promo.getProductId() != null) // skip null productId
                .toList();

        for (Product p : products) {
            for (Promotion promo : activePromotions) {
                if (promo.getProductId().equals(p.getId())) {
                    p.setPromotion(promo); // attach promotion to product
                    break; // one promotion per product
                }
            }
        }

        return products;
    }


    public Optional<Product> getProductById(String id) {
        return productRepository.getProductById(id);
    }

    public void addProduct(Product product) {
        productRepository.addProduct(product);
    }

    public void updateProduct(Product product) {
        productRepository.updateProduct(product);
    }

    public void deleteProduct(String id) {
        productRepository.deleteProduct(id);
    }

    public void reduceStock(String productId, int quantity) {
        productRepository.reduceStock(productId, quantity);
    }
}