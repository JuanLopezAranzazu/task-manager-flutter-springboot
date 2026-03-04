package com.juanlopezaranzazu.backend.services;

import com.juanlopezaranzazu.backend.dtos.request.CreateTaskRequest;
import com.juanlopezaranzazu.backend.dtos.request.UpdateTaskRequest;
import com.juanlopezaranzazu.backend.dtos.response.PageResponse;
import com.juanlopezaranzazu.backend.dtos.response.TaskResponse;
import com.juanlopezaranzazu.backend.entities.User;

import org.springframework.data.domain.Pageable;

public interface TaskService {
    PageResponse<TaskResponse> getAllTasks(User user, Pageable pageable);
    TaskResponse getTaskById(User user, Long taskId);
    TaskResponse createTask(User user, CreateTaskRequest request);
    TaskResponse updateTask(User user, Long taskId, UpdateTaskRequest request);
    void deleteTask(User user, Long taskId);
}
