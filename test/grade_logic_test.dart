import 'package:flutter_test/flutter_test.dart';
import 'package:banzon_gradeapp/models/grade.dart';

void main() {
  group('Grade Model Logic Tests', () {
    test('should map numeric scores to correct decimal grades', () {
      final grades = [
        Grade(subject: 'Math', score: 98),   // 1.0
        Grade(subject: 'Science', score: 95),// 1.25
        Grade(subject: 'History', score: 92),// 1.5
        Grade(subject: 'English', score: 89),// 1.75
        Grade(subject: 'PE', score: 86),     // 2.0
        Grade(subject: 'Art', score: 84),    // 2.25
        Grade(subject: 'CS', score: 81),     // 2.5
        Grade(subject: 'Music', score: 78),  // 2.75
        Grade(subject: 'Ethics', score: 76), // 3.0
        Grade(subject: 'Physics', score: 70),// 5.0
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
      expect(Grade(subject: 'S1', score: 98).status, 'Excellent');
      expect(Grade(subject: 'S2', score: 92).status, 'Very Good');
      expect(Grade(subject: 'S3', score: 86).status, 'Good');
      expect(Grade(subject: 'S4', score: 81).status, 'Satisfactory');
      expect(Grade(subject: 'S5', score: 78).status, 'Fair');
      expect(Grade(subject: 'S6', score: 76).status, 'Passing');
      expect(Grade(subject: 'S7', score: 70).status, 'Failed');
    });

    test('should calculate correct GWA with different units', () {
      final grades = [
        Grade(subject: 'Math', score: 95, units: 3.0),   // 1.25 * 3 = 3.75
        Grade(subject: 'Science', score: 80, units: 5.0),// 2.5 * 5 = 12.5
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
