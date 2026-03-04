package com.juanlopezaranzazu.backend.controllers;

import com.juanlopezaranzazu.backend.dtos.request.CreateTaskRequest;
import com.juanlopezaranzazu.backend.dtos.request.UpdateTaskRequest;
import com.juanlopezaranzazu.backend.dtos.response.ApiResponse;
import com.juanlopezaranzazu.backend.dtos.response.PageResponse;
import com.juanlopezaranzazu.backend.dtos.response.TaskResponse;
import com.juanlopezaranzazu.backend.entities.User;
import com.juanlopezaranzazu.backend.services.TaskService;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/tasks")
@RequiredArgsConstructor
public class TaskController {

    private final TaskService taskService;

    @GetMapping
    public ResponseEntity<ApiResponse<PageResponse<TaskResponse>>> getAllTasks(
            @AuthenticationPrincipal User currentUser,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "createdAt") String sortBy,
            @RequestParam(defaultValue = "desc") String direction) {

        Sort sort = direction.equalsIgnoreCase("asc")
                ? Sort.by(sortBy).ascending()
                : Sort.by(sortBy).descending();
        Pageable pageable = PageRequest.of(page, size, sort);

        PageResponse<TaskResponse> tasks = taskService.getAllTasks(currentUser, pageable);
        return ResponseEntity.ok(ApiResponse.success(tasks));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<TaskResponse>> getTaskById(
            @AuthenticationPrincipal User currentUser,
            @PathVariable Long id) {
        TaskResponse task = taskService.getTaskById(currentUser, id);
        return ResponseEntity.ok(ApiResponse.success(task));
    }

    @PostMapping
    public ResponseEntity<ApiResponse<TaskResponse>> createTask(
            @AuthenticationPrincipal User currentUser,
            @Valid @RequestBody CreateTaskRequest request) {
        TaskResponse task = taskService.createTask(currentUser, request);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(ApiResponse.success("Task created successfully", task));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<TaskResponse>> updateTask(
            @AuthenticationPrincipal User currentUser,
            @PathVariable Long id,
            @Valid @RequestBody UpdateTaskRequest request) {
        TaskResponse task = taskService.updateTask(currentUser, id, request);
        return ResponseEntity.ok(ApiResponse.success("Task updated successfully", task));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteTask(
            @AuthenticationPrincipal User currentUser,
            @PathVariable Long id) {
        taskService.deleteTask(currentUser, id);
        return ResponseEntity.ok(ApiResponse.success("Task deleted successfully", null));
    }
}
