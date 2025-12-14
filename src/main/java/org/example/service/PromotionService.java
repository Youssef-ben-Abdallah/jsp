package org.example.service;

import org.example.model.Product;
import org.example.model.Promotion;
import org.example.repository.PromotionRepository;
import java.util.List;

public class PromotionService {
    private final PromotionRepository promotionRepository;

    public PromotionService() {
        this.promotionRepository = new PromotionRepository();
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
        applyPromotionToProduct(product);
        return product.hasPromotion() ? product.getDiscountedPrice() : product.getPrice();
    }

    public void applyPromotionToProduct(Product product) {
        Promotion bestPromotion = null;
        double bestPrice = product.getPrice();

        for (Promotion promotion : getActivePromotions()) {
            if (isPromotionApplicable(promotion, product)) {
                double discounted = promotion.applyDiscount(product.getPrice());
                if (discounted < bestPrice) {
                    bestPrice = discounted;
                    bestPromotion = promotion;
                }
            }
        }

        if (bestPromotion != null && bestPrice < product.getPrice()) {
            product.setPromotion(bestPromotion);
            product.setPromotionName(bestPromotion.getTitle());
            product.setDiscountedPrice(bestPrice);
            double discountPercent = product.getPrice() > 0
                    ? (product.getPrice() - bestPrice) / product.getPrice() * 100
                    : 0;
            product.setDiscountPercent(discountPercent);
        } else {
            product.setPromotion(null);
            product.setPromotionName(null);
            product.setDiscountedPrice(null);
            product.setDiscountPercent(0);
        }
    }

    private boolean isPromotionApplicable(Promotion promotion, Product product) {
        if (!promotion.isActive()) {
            return false;
        }

        String promotionProductId = promotion.getProductId();
        String promotionCategoryId = promotion.getCategoryId();

        boolean hasProductId = promotionProductId != null && !promotionProductId.isBlank();
        boolean hasCategoryId = promotionCategoryId != null && !promotionCategoryId.isBlank();

        if (hasProductId) {
            return promotionProductId.equals(product.getId());
        }
        if (hasCategoryId) {
            return promotionCategoryId.equals(product.getCategoryId());
        }
        return true; // global promotion
    }
}