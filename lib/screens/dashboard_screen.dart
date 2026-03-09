import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:banzon_gradeapp/providers/auth_provider.dart';
import 'package:banzon_gradeapp/providers/todo_provider.dart';
import 'package:banzon_gradeapp/core/constants/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final student = authProvider.currentStudent;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${student?.name.split(' ').first ?? 'Student'} 👋',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primaryLight,
                    child: Text(
                      student?.name.substring(0, 1).toUpperCase() ?? 'S',
                      style: const TextStyle(
                        fontSize: 24, 
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),

              const SizedBox(height: 32),

              // Interactive Cards Setup
              Text(
                'Quick Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ).animate().fadeIn(delay: 100.ms),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _DashboardCard(
                      title: 'My Grades',
                      icon: Icons.analytics_outlined,
                      color: AppColors.primary,
                      onTap: () {
                        // Uses Bottom Nav in main.dart if setup that way, 
                        // or pushing manual routes here. For this structure, 
                        // we'll assume navigation is handled via pushing or a root indexed stack.
                      },
                    ).animate().scale(delay: 200.ms),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _DashboardCard(
                      title: 'Todo List',
                      icon: Icons.check_circle_outline,
                      color: AppColors.accent,
                      onTap: () {},
                    ).animate().scale(delay: 300.ms),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Text(
                "Today's Progress",
                style: Theme.of(context).textTheme.titleLarge,
              ).animate().fadeIn(delay: 400.ms),
              
              const SizedBox(height: 16),

              Consumer<TodoProvider>(
                builder: (context, todoProv, _) {
                  final totalTasks = todoProv.tasks.length;
                  final completedTasks = todoProv.completedTasks.length;
                  final progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.textDisabled.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Task Completion',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '$completedTasks/$totalTasks',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 12,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
