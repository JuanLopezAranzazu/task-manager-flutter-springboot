import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/task.dart';

// ─── AppTextField ─────────────────────────────────────────────────────────────

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscure;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextCapitalization capitalization;

  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscure = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffix,
    this.validator,
    this.maxLines = 1,
    this.capitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: capitalization,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        suffix: suffix,
      ),
    );
  }
}

// ─── AppButton ────────────────────────────────────────────────────────────────

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, size: 18),
                ],
              ],
            ),
    );
  }
}

// ─── StatusBadge ──────────────────────────────────────────────────────────────

class StatusBadge extends StatelessWidget {
  final TaskStatus status;

  const StatusBadge(this.status, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 12, color: status.color),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: status.color,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── PriorityDot ──────────────────────────────────────────────────────────────

class PriorityDot extends StatelessWidget {
  final TaskPriority priority;

  const PriorityDot(this.priority, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: priority.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        priority.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: priority.color,
        ),
      ),
    );
  }
}

// ─── ErrorBanner ──────────────────────────────────────────────────────────────

class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const ErrorBanner(this.message, {super.key, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.danger.withOpacity(0.1),
        border: Border.all(color: AppTheme.danger.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppTheme.danger, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: AppTheme.danger, fontSize: 13),
            ),
          ),
          if (onDismiss != null)
            GestureDetector(
              onTap: onDismiss,
              child:
                  Icon(Icons.close, size: 16, color: AppTheme.danger),
            ),
        ],
      ),
    );
  }
}

// ─── EmptyState ───────────────────────────────────────────────────────────────

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  size: 40, color: AppTheme.primary.withOpacity(0.5)),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}
