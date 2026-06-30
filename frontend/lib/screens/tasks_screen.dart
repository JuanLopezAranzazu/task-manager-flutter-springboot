import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';
import '../models/task.dart';
import '../widgets/app_widgets.dart';
import '../widgets/task_card.dart';
import '../widgets/stats_bar.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  final _scroll = ScrollController();
  TaskStatus? _filter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(tasksProvider.notifier).load(),
    );
    _scroll.addListener(() {
      if (_scroll.position.pixels >=
          _scroll.position.maxScrollExtent - 150) {
        ref.read(tasksProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  List<Task> _filtered(List<Task> tasks) =>
      _filter == null ? tasks : tasks.where((t) => t.status == _filter).toList();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final tasks = ref.watch(tasksProvider);
    final filtered = _filtered(tasks.tasks);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hola, ${auth.user?.name.split(' ').first ?? ''}',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const Text('Mis tareas'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 17,
              backgroundColor: const Color(0xFF5C6BC0).withOpacity(0.15),
              child: Text(
                auth.user?.initials ?? '?',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5C6BC0),
                ),
              ),
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: const [
                    Icon(Icons.logout, size: 18, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Cerrar sesión',
                        style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
            onSelected: (_) => ref.read(authProvider.notifier).logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(tasksProvider.notifier).load(refresh: true),
        child: CustomScrollView(
          controller: _scroll,
          slivers: [
            // Stats
            if (tasks.tasks.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: StatsBar(state: tasks),
                ),
              ),

            // Filtros
            SliverToBoxAdapter(
              child: _FilterRow(
                active: _filter,
                onChanged: (v) => setState(
                  () => _filter = _filter == v ? null : v,
                ),
              ),
            ),

            // Error
            if (tasks.error != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: ErrorBanner(
                    tasks.error!,
                    onDismiss: () =>
                        ref.read(tasksProvider.notifier).clearError(),
                  ),
                ),
              ),

            // Loading inicial
            if (tasks.isLoading && tasks.tasks.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )

            // Lista vacía
            else if (filtered.isEmpty)
              SliverFillRemaining(
                child: EmptyState(
                  icon: Icons.task_alt_outlined,
                  title: _filter != null
                      ? 'Sin tareas con ese filtro'
                      : 'No tienes tareas',
                  subtitle: _filter != null
                      ? 'Prueba otro filtro'
                      : 'Crea tu primera tarea con el botón +',
                ),
              )

            // Lista
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (ctx, i) {
                      if (i == filtered.length) {
                        return tasks.hasMore
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                    child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TaskCard(task: filtered[i]),
                      );
                    },
                    childCount: filtered.length + 1,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tasks/new'),
        icon: const Icon(Icons.add),
        label: const Text('Nueva tarea'),
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  final TaskStatus? active;
  final void Function(TaskStatus) onChanged;

  const _FilterRow({required this.active, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: TaskStatus.values
            .map((s) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => onChanged(s),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: active == s
                            ? s.color
                            : s.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active == s ? Colors.white : s.color,
                        ),
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
