package com.juanlopezaranzazu.backend.dtos.response;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

import com.juanlopezaranzazu.backend.entities.Task;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Schema(description = "Task information response")
public class TaskResponse {

    @Schema(description = "Task ID", example = "1")
    private Long id;

    @Schema(description = "Task title", example = "Implement login feature")
    private String title;

    @Schema(description = "Task description")
    private String description;

    @Schema(description = "Task status", example = "PENDING")
    private Task.Status status;

    @Schema(description = "Task priority", example = "HIGH")
    private Task.Priority priority;

    @Schema(description = "Task due date")
    private LocalDateTime dueDate;

    @Schema(description = "Owner user ID")
    private Long userId;

    @Schema(description = "Task creation timestamp")
    private LocalDateTime createdAt;

    @Schema(description = "Task last update timestamp")
    private LocalDateTime updatedAt;

    public static TaskResponse fromTask(Task task) {
        return TaskResponse.builder()
                .id(task.getId())
                .title(task.getTitle())
                .description(task.getDescription())
                .status(task.getStatus())
                .priority(task.getPriority())
                .dueDate(task.getDueDate())
                .userId(task.getUser().getId())
                .createdAt(task.getCreatedAt())
                .updatedAt(task.getUpdatedAt())
                .build();
    }
}
