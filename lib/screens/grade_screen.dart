import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:banzon_gradeapp/providers/auth_provider.dart';
import 'package:banzon_gradeapp/providers/grade_provider.dart';
import 'package:banzon_gradeapp/models/grade.dart';
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

  double _calculateGWA(List<Grade> grades) {
    if (grades.isEmpty) return 0.0;
    double totalWeightedGrades = 0;
    double totalUnits = 0;
    for (var g in grades) {
      totalWeightedGrades += (g.decimalGrade * g.units);
      totalUnits += g.units;
    }
    return totalUnits > 0 ? totalWeightedGrades / totalUnits : 0.0;
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

          final gwa = _calculateGWA(gradeProv.grades);

          return RefreshIndicator(
            onRefresh: _fetchGrades,
            color: AppColors.primary,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildGWACard(gwa),
                const SizedBox(height: 24),
                Text(
                  'Subject Grades',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                ),
                const SizedBox(height: 12),
                ...gradeProv.grades.asMap().entries.map((entry) {
                  return GradeCard(
                    grade: entry.value,
                    index: entry.key,
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGWACard(double gwa) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'General Weighted Average',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            gwa.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getGWAStatus(gwa),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale(delay: 200.ms);
  }

  String _getGWAStatus(double gwa) {
    if (gwa <= 1.25) return 'Presidents Lister';
    if (gwa <= 1.5) return 'Deans Lister';
    if (gwa <= 3.0) return 'Academic Standing: Good';
    return 'Academic Standing: Failing';
  }
}

