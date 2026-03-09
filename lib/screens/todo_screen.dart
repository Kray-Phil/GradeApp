import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:banzon_gradeapp/providers/todo_provider.dart';
import 'package:banzon_gradeapp/core/constants/app_colors.dart';
import 'package:banzon_gradeapp/widgets/task_tile.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    DateTime? selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Add New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      hintText: 'Task Title',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setState(() => selectedDate = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate == null 
                                ? 'Select Due Date' 
                                : DateFormat('MMM dd, yyyy').format(selectedDate!),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: selectedDate == null ? AppColors.textDisabled : AppColors.textPrimary,
                            ),
                          ),
                          const Icon(Icons.calendar_today_outlined, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.trim().isNotEmpty && selectedDate != null) {
                      Provider.of<TodoProvider>(context, listen: false)
                          .addTask(titleController.text.trim(), selectedDate!);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Tasks'),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProv, _) {
          if (todoProv.tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.network(
                    'https://assets9.lottiefiles.com/packages/lf20_y0doy1d0.json', // Sample empty state animation
                    width: 250,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.task_alt,
                      size: 100,
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'All caught up!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a new task below to get started',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms).scale(begin: const Offset(0.9, 0.9)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: todoProv.tasks.length,
            itemBuilder: (context, index) {
              final task = todoProv.tasks[index];
              return TaskTile(
                task: task,
                onToggle: () => todoProv.toggleTaskStatus(task.id),
                onDelete: () => todoProv.removeTask(task.id),
              ).animate()
                .fadeIn(delay: (50 * index).ms)
                .slideX(begin: 0.1, end: 0);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ).animate().scale(delay: 400.ms),
    );
  }
}
