package org.example.repository;

import org.example.model.Category;
import org.example.util.JsonFileManager;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class CategoryRepository {
    private final JsonFileManager<Category> jsonFileManager;
    private List<Category> categories;

    public CategoryRepository() {
        this.jsonFileManager = new JsonFileManager<>(Category.class);
        loadCategories();
    }

    private void loadCategories() {
        categories = jsonFileManager.readFromFile("categories.json");

        // Debug: Print each category
        for (Category category : categories) {
            System.out.println("Category: " + category.getName() +
                    " (ID: " + category.getId() +
                    ", Desc: " + category.getDescription() +
                    ", Products: " + (category.getProducts() != null ? category.getProducts().size() : 0) + ")");
        }
    }

    private void saveCategories() {
        jsonFileManager.writeToFile("categories.json", categories);
    }

    public List<Category> getAllCategories() {
        return categories;
    }

    public Optional<Category> getCategoryById(String id) {
        return categories.stream()
                .filter(category -> category.getId().equals(id))
                .findFirst();
    }

    public void addCategory(Category category) {
        categories.add(category);
        saveCategories();
    }

    public void updateCategory(Category updatedCategory) {
        categories = categories.stream()
                .map(category -> category.getId().equals(updatedCategory.getId()) ? updatedCategory : category)
                .collect(Collectors.toList());
        saveCategories();
    }

    public void deleteCategory(String id) {
        categories.removeIf(category -> category.getId().equals(id));
        saveCategories();
    }
}