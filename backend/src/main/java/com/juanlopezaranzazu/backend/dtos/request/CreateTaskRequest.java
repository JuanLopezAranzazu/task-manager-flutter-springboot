package com.juanlopezaranzazu.backend.dtos.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.time.LocalDateTime;

import com.juanlopezaranzazu.backend.entities.Task;

@Data
public class CreateTaskRequest {

    @NotBlank(message = "Title is required")
    @Size(min = 1, max = 255, message = "Title must be between 1 and 255 characters")
    private String title;

    @Size(max = 2000, message = "Description must not exceed 2000 characters")
    private String description;

    private Task.Priority priority = Task.Priority.MEDIUM;

    private LocalDateTime dueDate;
}
