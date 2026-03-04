package com.juanlopezaranzazu.backend.repositories;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.juanlopezaranzazu.backend.entities.Task;
import com.juanlopezaranzazu.backend.entities.User;

import java.util.Optional;

@Repository
public interface TaskRepository extends JpaRepository<Task, Long> {
    Page<Task> findByUser(User user, Pageable pageable);
    Optional<Task> findByIdAndUser(Long id, User user);
    boolean existsByIdAndUser(Long id, User user);
}
