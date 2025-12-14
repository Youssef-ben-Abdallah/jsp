package org.example.service;

import org.example.model.Category;
import org.example.repository.CategoryRepository;
import java.util.List;
import java.util.Optional;

public class CategoryService {
    private final CategoryRepository categoryRepository;

    public CategoryService() {
        this.categoryRepository = new CategoryRepository();
    }

    public List<Category> getAllCategories() {
        return categoryRepository.getAllCategories();
    }

    public Optional<Category> getCategoryById(String id) {
        return categoryRepository.getCategoryById(id);
    }

    public void addCategory(Category category) {
        categoryRepository.addCategory(category);
    }

    public void updateCategory(Category category) {
        categoryRepository.updateCategory(category);
    }

    public void deleteCategory(String id) {
        categoryRepository.deleteCategory(id);
    }
}