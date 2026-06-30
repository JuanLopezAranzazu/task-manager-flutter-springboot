import 'package:flutter/material.dart';
import '../config/app_config.dart';

enum TaskStatus { pending, inProgress, completed, cancelled }

enum TaskPriority { low, medium, high, urgent }

extension TaskStatusExt on TaskStatus {
  String get apiValue => switch (this) {
        TaskStatus.pending => 'PENDING',
        TaskStatus.inProgress => 'IN_PROGRESS',
        TaskStatus.completed => 'COMPLETED',
        TaskStatus.cancelled => 'CANCELLED',
      };

  String get label => switch (this) {
        TaskStatus.pending => 'Pending',
        TaskStatus.inProgress => 'In Progress',
        TaskStatus.completed => 'Completed',
        TaskStatus.cancelled => 'Cancelled',
      };

  Color get color => switch (this) {
        TaskStatus.pending => AppTheme.warning,
        TaskStatus.inProgress => AppTheme.info,
        TaskStatus.completed => AppTheme.success,
        TaskStatus.cancelled => Colors.grey,
      };

  IconData get icon => switch (this) {
        TaskStatus.pending => Icons.radio_button_unchecked,
        TaskStatus.inProgress => Icons.pending_outlined,
        TaskStatus.completed => Icons.check_circle_outline,
        TaskStatus.cancelled => Icons.cancel_outlined,
      };

  static TaskStatus fromApi(String value) => switch (value.toUpperCase()) {
        'IN_PROGRESS' => TaskStatus.inProgress,
        'COMPLETED' => TaskStatus.completed,
        'CANCELLED' => TaskStatus.cancelled,
        _ => TaskStatus.pending,
      };
}

extension TaskPriorityExt on TaskPriority {
  String get apiValue => switch (this) {
        TaskPriority.low => 'LOW',
        TaskPriority.medium => 'MEDIUM',
        TaskPriority.high => 'HIGH',
        TaskPriority.urgent => 'URGENT',
      };

  String get label => switch (this) {
        TaskPriority.low => 'Low',
        TaskPriority.medium => 'Medium',
        TaskPriority.high => 'High',
        TaskPriority.urgent => 'Urgent',
      };

  Color get color => switch (this) {
        TaskPriority.low => AppTheme.success,
        TaskPriority.medium => AppTheme.warning,
        TaskPriority.high => AppTheme.danger,
        TaskPriority.urgent => const Color(0xFF7B1FA2),
      };

  static TaskPriority fromApi(String value) => switch (value.toUpperCase()) {
        'LOW' => TaskPriority.low,
        'HIGH' => TaskPriority.high,
        'URGENT' => TaskPriority.urgent,
        _ => TaskPriority.medium,
      };
}

class Task {
  final int id;
  final String title;
  final String? description;
  final TaskStatus status;
  final TaskPriority priority;
  final DateTime? dueDate;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
    this.dueDate,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] as int,
        title: json['title'] as String,
        description: json['description'] as String?,
        status: TaskStatusExt.fromApi(json['status'] as String? ?? 'PENDING'),
        priority:
            TaskPriorityExt.fromApi(json['priority'] as String? ?? 'MEDIUM'),
        dueDate: json['dueDate'] != null
            ? DateTime.parse(json['dueDate'] as String)
            : null,
        userId: json['userId'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  Task copyWith({
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? dueDate,
  }) =>
      Task(
        id: id,
        title: title ?? this.title,
        description: description ?? this.description,
        status: status ?? this.status,
        priority: priority ?? this.priority,
        dueDate: dueDate ?? this.dueDate,
        userId: userId,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );

  bool get isOverdue =>
      dueDate != null &&
      dueDate!.isBefore(DateTime.now()) &&
      status != TaskStatus.completed &&
      status != TaskStatus.cancelled;
}
