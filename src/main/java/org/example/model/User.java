package org.example.model;

public class User {
    private String id;
    private String email;
    private String password;
    private String fullname;
    private String role; // "USER" or "ADMIN"

    public User() {}

    public User(String id, String email, String password, String fullname, String role) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.fullname = fullname;
        this.role = role;
    }

    // Getters and setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public boolean isAdmin() {
        return "ADMIN".equals(role);
    }
}