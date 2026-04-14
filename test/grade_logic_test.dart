import 'package:flutter_test/flutter_test.dart';
import 'package:banzon_gradeapp/models/grade.dart';

void main() {
  group('Grade Model Logic Tests', () {
    test('should map numeric scores to correct decimal grades', () {
      final grades = [
        Grade(code: 'M1', subject: 'Math', score: 98, units: 3.0, semester: 1, academicYear: '2024'),
        Grade(code: 'S1', subject: 'Science', score: 95, units: 3.0, semester: 1, academicYear: '2024'),
        Grade(code: 'H1', subject: 'History', score: 92, units: 3.0, semester: 1, academicYear: '2024'),
        Grade(code: 'E1', subject: 'English', score: 89, units: 3.0, semester: 1, academicYear: '2024'),
        Grade(code: 'P1', subject: 'PE', score: 86, units: 2.0, semester: 1, academicYear: '2024'),
        Grade(code: 'A1', subject: 'Art', score: 84, units: 3.0, semester: 1, academicYear: '2024'),
        Grade(code: 'C1', subject: 'CS', score: 81, units: 3.0, semester: 1, academicYear: '2024'),
        Grade(code: 'M2', subject: 'Music', score: 78, units: 3.0, semester: 1, academicYear: '2024'),
        Grade(code: 'E2', subject: 'Ethics', score: 76, units: 3.0, semester: 1, academicYear: '2024'),
        Grade(code: 'P2', subject: 'Physics', score: 70, units: 3.0, semester: 1, academicYear: '2024'),
      ];

      expect(grades[0].decimalGrade, 1.0);
      expect(grades[1].decimalGrade, 1.25);
      expect(grades[2].decimalGrade, 1.5);
      expect(grades[3].decimalGrade, 1.75);
      expect(grades[4].decimalGrade, 2.0);
      expect(grades[5].decimalGrade, 2.25);
      expect(grades[6].decimalGrade, 2.5);
      expect(grades[7].decimalGrade, 2.75);
      expect(grades[8].decimalGrade, 3.0);
      expect(grades[9].decimalGrade, 5.0);
    });

    test('should return correct status for decimal grades', () {
      expect(Grade(code: 'S1', subject: 'S1', score: 98, units: 3.0, semester: 1, academicYear: '2024').status, 'Excellent');
      expect(Grade(code: 'S2', subject: 'S2', score: 92, units: 3.0, semester: 1, academicYear: '2024').status, 'Very Good');
      expect(Grade(code: 'S3', subject: 'S3', score: 86, units: 3.0, semester: 1, academicYear: '2024').status, 'Good');
      expect(Grade(code: 'S4', subject: 'S4', score: 81, units: 3.0, semester: 1, academicYear: '2024').status, 'Satisfactory');
      expect(Grade(code: 'S5', subject: 'S5', score: 78, units: 3.0, semester: 1, academicYear: '2024').status, 'Fair');
      expect(Grade(code: 'S6', subject: 'S6', score: 76, units: 3.0, semester: 1, academicYear: '2024').status, 'Passing');
      expect(Grade(code: 'S7', subject: 'S7', score: 70, units: 3.0, semester: 1, academicYear: '2024').status, 'Failed');
    });

    test('should calculate correct GWA with different units', () {
      final grades = [
        Grade(code: 'M1', subject: 'Math', score: 95, units: 3.0, semester: 1, academicYear: '2024'),   // 1.25 * 3 = 3.75
        Grade(code: 'S1', subject: 'Science', score: 80, units: 5.0, semester: 1, academicYear: '2024'),// 2.5 * 5 = 12.5
      ];
      
      // Total units = 8.0
      // Total weighted = 3.75 + 12.5 = 16.25
      // GWA = 16.25 / 8.0 = 2.03125
      
      double totalWeighted = 0;
      double totalUnits = 0;
      for (var g in grades) {
        totalWeighted += (g.decimalGrade * g.units);
        totalUnits += g.units;
      }
      final gwa = totalWeighted / totalUnits;
      
      expect(gwa, closeTo(2.03, 0.01));
    });
  });
}
