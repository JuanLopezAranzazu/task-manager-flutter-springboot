package com.juanlopezaranzazu.backend.services.impl;

import com.juanlopezaranzazu.backend.repositories.TaskRepository;
import com.juanlopezaranzazu.backend.services.TaskService;
import com.juanlopezaranzazu.backend.dtos.request.CreateTaskRequest;
import com.juanlopezaranzazu.backend.dtos.request.UpdateTaskRequest;
import com.juanlopezaranzazu.backend.dtos.response.PageResponse;
import com.juanlopezaranzazu.backend.dtos.response.TaskResponse;
import com.juanlopezaranzazu.backend.entities.Task;
import com.juanlopezaranzazu.backend.entities.User;
import com.juanlopezaranzazu.backend.exceptions.ResourceNotFoundException;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Slf4j
public class TaskServiceImpl implements TaskService {

    private final TaskRepository taskRepository;

    @Override
    public PageResponse<TaskResponse> getAllTasks(User user, Pageable pageable) {
        Page<Task> tasks = taskRepository.findByUser(user, pageable);
        Page<TaskResponse> taskResponses = tasks.map(TaskResponse::fromTask);
        return PageResponse.from(taskResponses);
    }

    @Override
    public TaskResponse getTaskById(User user, Long taskId) {
        Task task = taskRepository.findByIdAndUser(taskId, user)
                .orElseThrow(() -> new ResourceNotFoundException("Task", taskId));
        return TaskResponse.fromTask(task);
    }

    @Override
    @Transactional
    public TaskResponse createTask(User user, CreateTaskRequest request) {
        Task task = Task.builder()
                .title(request.getTitle())
                .description(request.getDescription())
                .priority(request.getPriority() != null ? request.getPriority() : Task.Priority.MEDIUM)
                .status(Task.Status.PENDING)
                .dueDate(request.getDueDate())
                .user(user)
                .build();

        Task saved = taskRepository.save(task);
        log.info("Task created with id={} by user={}", saved.getId(), user.getEmail());
        return TaskResponse.fromTask(saved);
    }

    @Override
    @Transactional
    public TaskResponse updateTask(User user, Long taskId, UpdateTaskRequest request) {
        Task task = taskRepository.findByIdAndUser(taskId, user)
                .orElseThrow(() -> new ResourceNotFoundException("Task", taskId));

        task.setTitle(request.getTitle());
        task.setDescription(request.getDescription());
        if (request.getStatus() != null) task.setStatus(request.getStatus());
        if (request.getPriority() != null) task.setPriority(request.getPriority());
        task.setDueDate(request.getDueDate());

        Task saved = taskRepository.save(task);
        log.info("Task updated with id={} by user={}", saved.getId(), user.getEmail());
        return TaskResponse.fromTask(saved);
    }

    @Override
    @Transactional
    public void deleteTask(User user, Long taskId) {
        Task task = taskRepository.findByIdAndUser(taskId, user)
                .orElseThrow(() -> new ResourceNotFoundException("Task", taskId));

        taskRepository.delete(task);
        log.info("Task deleted with id={} by user={}", taskId, user.getEmail());
    }
}
