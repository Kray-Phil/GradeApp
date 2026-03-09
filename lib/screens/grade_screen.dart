import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:banzon_gradeapp/providers/auth_provider.dart';
import 'package:banzon_gradeapp/providers/grade_provider.dart';
import 'package:banzon_gradeapp/core/constants/app_colors.dart';
import 'package:banzon_gradeapp/widgets/grade_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({super.key});

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => _fetchGrades());
  }

  Future<void> _fetchGrades() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    if (authProv.currentStudent != null) {
      await Provider.of<GradeProvider>(context, listen: false)
          .fetchGrades(authProv.currentStudent!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Grades'),
      ),
      body: Consumer<GradeProvider>(
        builder: (context, gradeProv, _) {
          if (gradeProv.isLoading && gradeProv.grades.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (gradeProv.errorMessage != null && gradeProv.grades.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    gradeProv.errorMessage!,
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _fetchGrades,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ).animate().fadeIn();
          }

          if (gradeProv.grades.isEmpty) {
            return const Center(
              child: Text("No records found."),
            );
          }

          return RefreshIndicator(
            onRefresh: _fetchGrades,
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: gradeProv.grades.length,
              itemBuilder: (context, index) {
                final grade = gradeProv.grades[index];
                return GradeCard(
                  grade: grade,
                  index: index,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
