import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/providers.dart';
import '../widgets/app_widgets.dart';

class TaskFormScreen extends ConsumerStatefulWidget {
  final Task? task; // null = crear, non-null = editar

  const TaskFormScreen({super.key, this.task});

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.task?.title);
  late final _desc =
      TextEditingController(text: widget.task?.description ?? '');
  late TaskPriority _priority = widget.task?.priority ?? TaskPriority.medium;
  late TaskStatus? _status =
      widget.task?.status; // solo en edición
  late DateTime? _dueDate = widget.task?.dueDate;
  bool _loading = false;

  bool get isEditing => widget.task != null;

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);

    final notifier = ref.read(tasksProvider.notifier);
    bool ok;

    if (isEditing) {
      ok = await notifier.update(
        id: widget.task!.id,
        title: _title.text.trim(),
        description: _desc.text.trim(),
        status: _status ?? widget.task!.status,
        priority: _priority,
        dueDate: _dueDate,
      );
    } else {
      ok = await notifier.create(
        title: _title.text.trim(),
        description: _desc.text.trim(),
        priority: _priority,
        dueDate: _dueDate,
      );
    }

    setState(() => _loading = false);

    if (ok && mounted) {
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isEditing ? 'Tarea actualizada' : 'Tarea creada'),
        behavior: SnackBarBehavior.floating,
      ));
    } else if (mounted) {
      final error = ref.read(tasksProvider).error;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error ?? 'Ocurrió un error'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar tarea' : 'Nueva tarea'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              AppTextField(
                controller: _title,
                label: 'Título *',
                hint: '¿Qué hay que hacer?',
                capitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'El título es requerido';
                  if (v.length > 255) return 'Máximo 255 caracteres';
                  return null;
                },
              ),
              const Gap(16),

              // Descripción
              AppTextField(
                controller: _desc,
                label: 'Descripción',
                hint: 'Detalles opcionales...',
                maxLines: 4,
                capitalization: TextCapitalization.sentences,
                validator: (v) {
                  if (v != null && v.length > 2000) {
                    return 'Máximo 2000 caracteres';
                  }
                  return null;
                },
              ),
              const Gap(20),

              // Prioridad
              Text('Prioridad', style: theme.textTheme.titleSmall),
              const Gap(8),
              Wrap(
                spacing: 8,
                children: TaskPriority.values
                    .map((p) => ChoiceChip(
                          label: Text(p.label),
                          selected: _priority == p,
                          selectedColor: p.color.withOpacity(0.2),
                          labelStyle: TextStyle(
                            color: _priority == p ? p.color : Colors.grey,
                            fontWeight: _priority == p
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                          onSelected: (_) => setState(() => _priority = p),
                        ))
                    .toList(),
              ),

              // Estado (solo en edición)
              if (isEditing) ...[
                const Gap(16),
                Text('Estado', style: theme.textTheme.titleSmall),
                const Gap(8),
                Wrap(
                  spacing: 8,
                  children: TaskStatus.values
                      .map((s) => ChoiceChip(
                            label: Text(s.label),
                            selected: _status == s,
                            selectedColor: s.color.withOpacity(0.2),
                            labelStyle: TextStyle(
                              color: _status == s ? s.color : Colors.grey,
                              fontWeight: _status == s
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            onSelected: (_) => setState(() => _status = s),
                          ))
                      .toList(),
                ),
              ],
              const Gap(16),

              // Fecha límite
              Text('Fecha límite', style: theme.textTheme.titleSmall),
              const Gap(8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6FA),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 18, color: Colors.grey),
                      const Gap(12),
                      Expanded(
                        child: Text(
                          _dueDate != null
                              ? DateFormat('dd MMM yyyy').format(_dueDate!)
                              : 'Sin fecha límite',
                          style: TextStyle(
                            color: _dueDate != null
                                ? Colors.black87
                                : Colors.grey,
                          ),
                        ),
                      ),
                      if (_dueDate != null)
                        GestureDetector(
                          onTap: () => setState(() => _dueDate = null),
                          child: const Icon(Icons.close,
                              size: 16, color: Colors.grey),
                        ),
                    ],
                  ),
                ),
              ),
              const Gap(28),

              // Botón
              AppButton(
                label: isEditing ? 'Guardar cambios' : 'Crear tarea',
                onPressed: _submit,
                loading: _loading,
                icon: isEditing ? Icons.save_outlined : Icons.add,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
