package com.juanlopezaranzazu.backend.dtos.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import com.juanlopezaranzazu.backend.entities.Task;

@Data
@Schema(description = "Update task status request payload")
public class UpdateTaskStatusRequest {

    @Schema(description = "Task status", example = "IN_PROGRESS",
            allowableValues = {"PENDING", "IN_PROGRESS", "COMPLETED", "CANCELLED"})
    private Task.Status status;
}
