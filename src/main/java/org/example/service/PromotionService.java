package org.example.service;

import org.example.model.Promotion;
import org.example.model.Product;
import org.example.repository.PromotionRepository;
import org.example.repository.ProductRepository;
import java.util.List;

public class PromotionService {
    private final PromotionRepository promotionRepository;
    private final ProductRepository productRepository;

    public PromotionService() {
        this.promotionRepository = new PromotionRepository();
        this.productRepository = new ProductRepository();
    }

    public List<Promotion> getAllPromotions() {
        return promotionRepository.getAllPromotions();
    }

    public List<Promotion> getActivePromotions() {
        return promotionRepository.getAllPromotions()
                .stream()
                .filter(Promotion::isActive)
                .toList();
    }
    public Promotion getPromotionById(String id) {
        return promotionRepository.getPromotionById(id).orElse(null);
    }

    public void addPromotion(Promotion promotion) {
        promotionRepository.addPromotion(promotion);
    }

    public void updatePromotion(Promotion promotion) {
        promotionRepository.updatePromotion(promotion);
    }

    public void deletePromotion(String id) {
        promotionRepository.deletePromotion(id);
    }

    public double getDiscountedPrice(Product product) {
        List<Promotion> activePromotions = getActivePromotions();
        double price = product.getPrice();

        for (Promotion promotion : activePromotions) {
            if (promotion.getProductId() != null && promotion.getProductId().equals(product.getId())) {
                price = promotion.applyDiscount(price);
            }
            else if (promotion.getCategoryId() != null && promotion.getCategoryId().equals(product.getCategoryId())) {
                price = promotion.applyDiscount(price);
            }
            else if (promotion.getProductId() == null && promotion.getCategoryId() == null) {
                price = promotion.applyDiscount(price);
            }
        }

        return price;
    }
}