import 'package:flutter/material.dart';
import 'package:banzon_gradeapp/models/task_model.dart';
import 'package:banzon_gradeapp/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
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
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    // Check if task is overdue
    final isOverdue = !task.isCompleted && 
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
          side: task.isCompleted
            ? BorderSide(color: AppColors.success.withOpacity(0.5))
            : BorderSide.none,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: task.isCompleted ? AppColors.success : Colors.transparent,
                border: Border.all(
                  color: task.isCompleted ? AppColors.success : AppColors.textDisabled,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: task.isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ),
          title: Text(
            task.title,
            style: theme.textTheme.titleMedium?.copyWith(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? AppColors.textDisabled : AppColors.textPrimary,
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
                    color: isOverdue ? AppColors.error : AppColors.textSecondary,
                    fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
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
