package com.juanlopezaranzazu.backend.dtos.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

import com.juanlopezaranzazu.backend.entities.Task;

@Data
@Schema(description = "Create task request payload")
public class CreateTaskRequest {

    @NotBlank(message = "Title is required")
    @Size(min = 1, max = 255, message = "Title must be between 1 and 255 characters")
    @Schema(description = "Task title", example = "Implement login feature")
    private String title;

    @Size(max = 2000, message = "Description must not exceed 2000 characters")
    @Schema(description = "Task description", example = "Implement JWT-based login endpoint")
    private String description;

    @Schema(description = "Task priority", example = "HIGH", allowableValues = {"LOW", "MEDIUM", "HIGH", "URGENT"})
    private Task.Priority priority = Task.Priority.MEDIUM;

    @Schema(description = "Task due date", example = "2024-12-31T23:59:59")
    private LocalDateTime dueDate;
}
