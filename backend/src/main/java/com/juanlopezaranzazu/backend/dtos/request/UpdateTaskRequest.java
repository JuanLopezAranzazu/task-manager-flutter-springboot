package com.juanlopezaranzazu.backend.dtos.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

import com.juanlopezaranzazu.backend.entities.Task;

@Data
@Schema(description = "Update task request payload")
public class UpdateTaskRequest {

    @NotBlank(message = "Title is required")
    @Size(min = 1, max = 255, message = "Title must be between 1 and 255 characters")
    @Schema(description = "Task title", example = "Updated task title")
    private String title;

    @Size(max = 2000, message = "Description must not exceed 2000 characters")
    @Schema(description = "Task description", example = "Updated description")
    private String description;

    @Schema(description = "Task status", example = "IN_PROGRESS",
            allowableValues = {"PENDING", "IN_PROGRESS", "COMPLETED", "CANCELLED"})
    private Task.Status status;

    @Schema(description = "Task priority", example = "HIGH",
            allowableValues = {"LOW", "MEDIUM", "HIGH", "URGENT"})
    private Task.Priority priority;

    @Schema(description = "Task due date", example = "2024-12-31T23:59:59")
    private LocalDateTime dueDate;
}
