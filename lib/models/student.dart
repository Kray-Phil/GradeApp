class Student {
  final String id;
  final String name;
  final String course;
  final String profileImageUrl;

  Student({
    required this.id,
    required this.name,
    required this.course,
    this.profileImageUrl = '',
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      course: json['course'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'course': course,
      'profileImageUrl': profileImageUrl,
    };
  }
}
