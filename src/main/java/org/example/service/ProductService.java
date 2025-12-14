package org.example.service;

import org.example.model.Product;
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
        products.forEach(promotionService::applyPromotionToProduct);
        return products;
    }


    public Optional<Product> getProductById(String id) {
        return productRepository.getProductById(id);
    }

    public Optional<Product> getProductWithPromotion(String id) {
        Optional<Product> product = productRepository.getProductById(id);
        product.ifPresent(promotionService::applyPromotionToProduct);
        return product;
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