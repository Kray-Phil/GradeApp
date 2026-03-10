import 'package:flutter/material.dart';
import 'package:banzon_gradeapp/models/task_model.dart';
import 'package:banzon_gradeapp/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final Function(TaskStatus) onStatusChange;
  final VoidCallback onDelete;

  const TaskTile({
    super.key,
    required this.task,
    required this.onStatusChange,
    required this.onDelete,
  });

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return AppColors.warning;
      case TaskStatus.complete:
        return AppColors.success;
      case TaskStatus.incomplete:
        return AppColors.textDisabled;
    }
  }

  IconData _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return Icons.rotate_right_rounded;
      case TaskStatus.complete:
        return Icons.check_circle_rounded;
      case TaskStatus.incomplete:
        return Icons.radio_button_unchecked_rounded;
    }
  }

  String _getStatusText(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.complete:
        return 'Complete';
      case TaskStatus.incomplete:
        return 'Incomplete';
    }
  }

  void _cycleStatus() {
    switch (task.status) {
      case TaskStatus.incomplete:
        onStatusChange(TaskStatus.inProgress);
        break;
      case TaskStatus.inProgress:
        onStatusChange(TaskStatus.complete);
        break;
      case TaskStatus.complete:
        onStatusChange(TaskStatus.incomplete);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    final isCompleted = task.status == TaskStatus.complete;
    final isOverdue =
        !isCompleted &&
        task.dueDate.isBefore(DateTime.now().subtract(const Duration(days: 1)));

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isCompleted
              ? BorderSide(color: AppColors.success.withOpacity(0.5))
              : BorderSide.none,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: GestureDetector(
            onTap: _cycleStatus,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getStatusColor(task.status).withOpacity(0.1),
                border: Border.all(
                  color: _getStatusColor(task.status),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getStatusIcon(task.status),
                size: 20,
                color: _getStatusColor(task.status),
              ),
            ),
          ),
          title: Text(
            task.title,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted
                  ? AppColors.textDisabled
                  : AppColors.textPrimary,
              fontWeight: task.status == TaskStatus.inProgress
                  ? FontWeight.bold
                  : null,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: isOverdue ? AppColors.error : AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  dateFormat.format(task.dueDate),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isOverdue
                        ? AppColors.error
                        : AppColors.textSecondary,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(task.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _getStatusText(task.status),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(task.status),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
