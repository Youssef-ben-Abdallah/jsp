package org.example.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.CollectionType;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class JsonFileManager<T> {
    private final ObjectMapper objectMapper;
    private final Class<T> type;

    public JsonFileManager(Class<T> type) {
        this.objectMapper = new ObjectMapper();
        this.type = type;
        objectMapper.findAndRegisterModules();
    }

    public List<T> readFromFile(String filename) {
        try {
            System.out.println("=== Trying to load: " + filename + " ===");

            // Try 1: Load from classpath (for deployed app)
            InputStream inputStream = getClass().getClassLoader().getResourceAsStream("data/" + filename);
            if (inputStream != null) {
                System.out.println("Found file in classpath: data/" + filename);
                CollectionType listType = objectMapper.getTypeFactory()
                        .constructCollectionType(List.class, type);
                List<T> data = objectMapper.readValue(inputStream, listType);
                inputStream.close();
                System.out.println("Successfully loaded " + data.size() + " items from classpath");
                return data;
            }

            // Try 2: Load from src/main/resources
            File resourcesFile = new File("src/main/resources/data/" + filename);
            if (resourcesFile.exists()) {
                System.out.println("Found file at: " + resourcesFile.getAbsolutePath());
                CollectionType listType = objectMapper.getTypeFactory()
                        .constructCollectionType(List.class, type);
                return objectMapper.readValue(resourcesFile, listType);
            }

            // Try 3: Load from current directory
            File currentDirFile = new File("data/" + filename);
            if (currentDirFile.exists()) {
                System.out.println("Found file at: " + currentDirFile.getAbsolutePath());
                CollectionType listType = objectMapper.getTypeFactory()
                        .constructCollectionType(List.class, type);
                return objectMapper.readValue(currentDirFile, listType);
            }

            // Try 4: Try absolute path
            File absoluteFile = new File(System.getProperty("user.dir") + "/src/main/resources/data/" + filename);
            if (absoluteFile.exists()) {
                System.out.println("Found file at: " + absoluteFile.getAbsolutePath());
                CollectionType listType = objectMapper.getTypeFactory()
                        .constructCollectionType(List.class, type);
                return objectMapper.readValue(absoluteFile, listType);
            }

            System.out.println("File not found anywhere: " + filename);
            return new ArrayList<>();

        } catch (IOException e) {
            System.err.println("Error reading file " + filename + ": " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void writeToFile(String filename, List<T> data) {
        try {
            // Always write to src/main/resources for consistency
            File file = new File("src/main/resources/data/" + filename);
            file.getParentFile().mkdirs(); // Create directory if it doesn't exist

            System.out.println("Writing to: " + file.getAbsolutePath());
            objectMapper.writerWithDefaultPrettyPrinter().writeValue(file, data);
            System.out.println("Successfully wrote " + data.size() + " items to " + filename);

        } catch (IOException e) {
            System.err.println("Error writing file " + filename + ": " + e.getMessage());
            e.printStackTrace();
        }
    }
}