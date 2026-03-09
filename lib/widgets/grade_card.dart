import 'package:flutter/material.dart';
import 'package:banzon_gradeapp/models/grade.dart';
import 'package:banzon_gradeapp/core/constants/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GradeCard extends StatelessWidget {
  final Grade grade;
  final int index;

  const GradeCard({
    super.key,
    required this.grade,
    required this.index,
  });

  Color _getGradeColor(int score) {
    if (score >= 90) return AppColors.gradeExcellent;
    if (score >= 80) return AppColors.gradeGood;
    if (score >= 70) return AppColors.gradeNeedsImprovement;
    return AppColors.gradePoor;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getGradeColor(grade.score);

    return Card(
      elevation: 2,
      shadowColor: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  grade.score.toString(),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    grade.subject,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      grade.status,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textDisabled),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1, end: 0);
  }
}
