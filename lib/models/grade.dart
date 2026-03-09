class Grade {
  final String subject;
  final int score;

  Grade({
    required this.subject,
    required this.score,
  });

  factory Grade.fromJson(Map<String, dynamic> json) {
    return Grade(
      subject: json['subject'] ?? '',
      score: json['grade'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'grade': score,
    };
  }

  String get status {
    if (score >= 90) return 'Excellent';
    if (score >= 80) return 'Good';
    if (score >= 70) return 'Needs Improvement';
    return 'Poor';
  }
}
