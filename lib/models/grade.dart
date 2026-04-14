class Grade {
  final String code;
  final String subject; // This will act as the "Description" or "Name"
  final int score;
  final double units;
  final int semester;
  final String academicYear;

  Grade({
    required this.code,
    required this.subject,
    required this.score,
    required this.units,
    required this.semester,
    required this.academicYear,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      code: json['code'] ?? '',
      subject: json['subject'] ?? '',
      score: json['grade'] ?? 0,
      units: (json['units'] ?? 3.0).toDouble(),
      semester: json['semester'] ?? 1,
      academicYear: json['academic_year'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'subject': subject,
      'grade': score,
      'units': units,
      'semester': semester,
      'academic_year': academicYear,
    };
  }

  double get decimalGrade {
    if (score >= 97) return 1.0;
    if (score >= 94) return 1.25;
    if (score >= 91) return 1.5;
    if (score >= 88) return 1.75;
    if (score >= 85) return 2.0;
    if (score >= 83) return 2.25;
    if (score >= 80) return 2.5;
    if (score >= 77) return 2.75;
    if (score >= 75) return 3.0;
    return 5.0;
  }

  String get status {
    if (decimalGrade <= 1.0) return 'Excellent';
    if (decimalGrade <= 1.5) return 'Very Good';
    if (decimalGrade <= 2.0) return 'Good';
    if (decimalGrade <= 2.5) return 'Satisfactory';
    if (decimalGrade <= 2.75) return 'Fair';
    if (decimalGrade <= 3.0) return 'Passing';
    return 'Failed';
  }
}

