import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doneColor = theme.colorScheme.outline;
    final accent = theme.colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: onToggle,
            child: Container(
              margin: const EdgeInsets.only(top: 2, right: 12),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.done ? accent : Colors.transparent,
                border: Border.all(
                  color: task.done ? accent : theme.colorScheme.outline,
                  width: 1.5,
                ),
              ),
              child: task.done
                  ? Icon(Icons.check,
                      size: 12, color: theme.colorScheme.onPrimary)
                  : null,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onToggle,
              child: Text(
                task.text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: task.done ? doneColor : theme.colorScheme.onSurface,
                  decoration: task.done ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onDelete,
            child: Padding(
              padding: const EdgeInsets.only(left: 8, top: 2),
              child:
                  Icon(Icons.close, size: 18, color: theme.colorScheme.outline),
            ),
          ),
        ],
      ),
    );
  }
}
