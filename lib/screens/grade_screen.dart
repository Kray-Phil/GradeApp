import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:banzon_gradeapp/providers/auth_provider.dart';
import 'package:banzon_gradeapp/providers/grade_provider.dart';
import 'package:banzon_gradeapp/models/grade.dart';
import 'package:banzon_gradeapp/core/constants/app_colors.dart';
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

  Map<String, List<Grade>> _groupGrades(List<Grade> grades) {
    final Map<String, List<Grade>> grouped = {};
    for (var g in grades) {
      final key = "${g.academicYear} | ${g.semester == 1 ? '1st' : g.semester == 2 ? '2nd' : '${g.semester}th'} Semester";
      if (!grouped.containsKey(key)) {
        grouped[key] = [];
      }
      grouped[key]!.add(g);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('College Grading System'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
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
              child: Text("No academic records found."),
            );
          }

          final totalGwa = _calculateGWA(gradeProv.grades);
          final groupedGrades = _groupGrades(gradeProv.grades);

          return RefreshIndicator(
            onRefresh: _fetchGrades,
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildCumulativeGWACard(totalGwa),
                  ),
                ),
                ...groupedGrades.entries.map((entry) {
                  final semesterGwa = _calculateGWA(entry.value);
                  return SliverToBoxAdapter(
                    child: _buildSemesterSection(entry.key, entry.value, semesterGwa),
                  );
                }),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCumulativeGWACard(double gwa) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cumulative GWA',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                gwa.toStringAsFixed(4),
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _getGWAStatus(gwa),
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: 0.2, end: 0);
  }

  Widget _buildSemesterSection(String title, List<Grade> grades, double semesterGwa) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title.toUpperCase(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'GPA: ${semesterGwa.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black12.withOpacity(0.05)),
            ),
            child: Column(
              children: [
                _buildTableHeader(),
                const Divider(height: 1, color: Colors.black12),
                ...grades.asMap().entries.map((entry) {
                  return _buildGradeRow(entry.value, entry.key == grades.length - 1);
                }),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text('CODE', style: _headerStyle)),
          Expanded(flex: 4, child: Text('DESCRIPTION', style: _headerStyle)),
          Expanded(flex: 1, child: Text('UNITS', style: _headerStyle, textAlign: TextAlign.center)),
          Expanded(flex: 1, child: Text('GRADE', style: _headerStyle, textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildGradeRow(Grade grade, bool isLast) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  grade.code,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grade.subject,
                      style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  grade.units.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  grade.decimalGrade.toStringAsFixed(2),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _getGradeColor(grade.decimalGrade),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16, color: Colors.black12),
      ],
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppColors.textDisabled,
    letterSpacing: 0.5,
  );

  Color _getGradeColor(double decimalGrade) {
    if (decimalGrade <= 1.5) return AppColors.gradeExcellent;
    if (decimalGrade <= 2.0) return AppColors.gradeGood;
    if (decimalGrade <= 3.0) return AppColors.gradeNeedsImprovement;
    return AppColors.gradePoor;
  }

  String _getGWAStatus(double gwa) {
    if (gwa <= 1.25) return 'PRESIDENT\'S LISTER';
    if (gwa <= 1.5) return 'DEAN\'S LISTER';
    if (gwa <= 3.0) return 'GOOD STANDING';
    return 'SCHOLASTIC PROBATION';
  }
}

