package org.example.repository;

import org.example.model.User;
import org.example.util.JsonFileManager;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class UserRepository {
    private final JsonFileManager<User> jsonFileManager;
    private List<User> users;

    public UserRepository() {
        this.jsonFileManager = new JsonFileManager<>(User.class);
        loadUsers();
    }

    private void loadUsers() {
        users = jsonFileManager.readFromFile("users.json");
    }

    private void saveUsers() {
        jsonFileManager.writeToFile("users.json", users);
    }

    public Optional<User> findUserByEmailAndPassword(String email, String password) {
        return users.stream()
                .filter(user -> user.getEmail().equals(email) && user.getPassword().equals(password))
                .findFirst();
    }

    // Add this missing method
    public Optional<User> findUserById(String id) {
        return users.stream()
                .filter(user -> user.getId().equals(id))
                .findFirst();
    }

    public List<User> getAllUsers() {
        return users;
    }

    public void addUser(User user) {
        users.add(user);
        saveUsers();
    }

    public void updateUser(User updatedUser) {
        users = users.stream()
                .map(user -> user.getId().equals(updatedUser.getId()) ? updatedUser : user)
                .collect(Collectors.toList());
        saveUsers();
    }

    public void deleteUser(String id) {
        users.removeIf(user -> user.getId().equals(id));
        saveUsers();
    }
}