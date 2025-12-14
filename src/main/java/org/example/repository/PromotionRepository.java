package org.example.repository;

import org.example.model.Promotion;
import org.example.util.JsonFileManager;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class PromotionRepository {
    private final JsonFileManager<Promotion> jsonFileManager;
    private List<Promotion> promotions;

    public PromotionRepository() {
        this.jsonFileManager = new JsonFileManager<>(Promotion.class);
        loadPromotions();
    }

    private void loadPromotions() {
        promotions = jsonFileManager.readFromFile("promotions.json");
    }

    private void savePromotions() {
        jsonFileManager.writeToFile("promotions.json", promotions);
    }

    public List<Promotion> getAllPromotions() {
        return promotions;
    }

    public List<Promotion> getActivePromotions() {
        LocalDate today = LocalDate.now();
        return promotions.stream()
                .filter(promotion -> promotion.isActive())
                .collect(Collectors.toList());
    }

    public Optional<Promotion> getPromotionById(String id) {
        return promotions.stream()
                .filter(promotion -> promotion.getId().equals(id))
                .findFirst();
    }

    public void addPromotion(Promotion promotion) {
        promotions.add(promotion);
        savePromotions();
    }

    public void updatePromotion(Promotion updatedPromotion) {
        promotions = promotions.stream()
                .map(promotion -> promotion.getId().equals(updatedPromotion.getId()) ? updatedPromotion : promotion)
                .collect(Collectors.toList());
        savePromotions();
    }

    public void deletePromotion(String id) {
        promotions.removeIf(promotion -> promotion.getId().equals(id));
        savePromotions();
    }
}