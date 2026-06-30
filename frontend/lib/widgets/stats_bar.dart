import 'package:flutter/material.dart';
import '../providers/providers.dart';
import '../config/app_config.dart';

class StatsBar extends StatelessWidget {
  final TasksState state;

  const StatsBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final done = state.completed;
    final total = state.total;
    final progress = total > 0 ? done / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primary, AppTheme.primary.withBlue(200)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _Stat('Total', state.total, Colors.white),
              _Divider(),
              _Stat('Pendientes', state.pending, AppTheme.warning),
              _Divider(),
              _Stat('En progreso', state.inProgress, AppTheme.info),
              _Divider(),
              _Stat('Completadas', state.completed, AppTheme.success),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${(progress * 100).toInt()}%',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _Stat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$value',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 2),
        Text(label,
            style:
                const TextStyle(fontSize: 10, color: Colors.white70)),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 30, color: Colors.white24);
}
