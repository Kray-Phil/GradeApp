class Grade {
  final String subject;
  final int score;
  final double units;

  Grade({
    required this.subject,
    required this.score,
    this.units = 3.0,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      subject: json['subject'] ?? '',
      score: json['grade'] ?? 0,
      units: (json['units'] ?? 3.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'grade': score,
      'units': units,
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

