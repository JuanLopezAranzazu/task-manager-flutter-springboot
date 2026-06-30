import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/providers.dart';
import 'app_widgets.dart';

class TaskCard extends ConsumerWidget {
  final Task task;

  const TaskCard({super.key, required this.task});

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Eliminar tarea'),
        content: Text('¿Eliminar "${task.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (ok == true) {
      ref.read(tasksProvider.notifier).delete(task.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCompleted = task.status == TaskStatus.completed;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/tasks/edit/${task.id}', extra: task),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título + acciones
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Checkbox de completado rápido
                      GestureDetector(
                        onTap: () {
                          final next = isCompleted
                              ? TaskStatus.pending
                              : TaskStatus.completed;
                          ref
                              .read(tasksProvider.notifier)
                              .changeStatus(task.id, next);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(top: 2, right: 10),
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? TaskStatus.completed.color
                                : Colors.transparent,
                            border: Border.all(
                              color: task.status.color,
                              width: 2,
                            ),
                          ),
                          child: isCompleted
                              ? const Icon(Icons.check,
                                  size: 14, color: Colors.white)
                              : null,
                        ),
                      ),
                      // Título
                      Expanded(
                        child: Text(
                          task.title,
                          style:
                              Theme.of(context).textTheme.titleSmall?.copyWith(
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: isCompleted ? Colors.grey : null,
                                  ),
                        ),
                      ),
                      // Menú
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert,
                              size: 18, color: Colors.grey),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          itemBuilder: (_) => [
                            const PopupMenuItem(
                                value: 'edit',
                                child: Row(children: [
                                  Icon(Icons.edit_outlined, size: 16),
                                  SizedBox(width: 8),
                                  Text('Editar'),
                                ])),
                            const PopupMenuItem(
                                value: 'delete',
                                child: Row(children: [
                                  Icon(Icons.delete_outline,
                                      size: 16, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Eliminar',
                                      style: TextStyle(color: Colors.red)),
                                ])),
                          ],
                          onSelected: (v) {
                            if (v == 'edit') {
                              context.push(
                                  '/tasks/edit/${task.id}',
                                  extra: task);
                            } else {
                              _confirmDelete(context, ref);
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  // Descripción
                  if (task.description?.isNotEmpty == true) ...[
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: Text(
                        task.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),

                  // Chips + fecha
                  Row(
                    children: [
                      const SizedBox(width: 32),
                      StatusBadge(task.status),
                      const SizedBox(width: 6),
                      PriorityDot(task.priority),
                      const Spacer(),
                      if (task.dueDate != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 13,
                              color:
                                  task.isOverdue ? Colors.red : Colors.grey,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              DateFormat('dd MMM').format(task.dueDate!),
                              style: TextStyle(
                                fontSize: 11,
                                color: task.isOverdue
                                    ? Colors.red
                                    : Colors.grey,
                                fontWeight: task.isOverdue
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
