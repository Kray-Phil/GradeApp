import 'package:banzon_gradeapp/models/student.dart';

class ApiService {
  // Simulate network delay using Future.delayed
  static const Duration _delay = Duration(seconds: 2);

  Future<Student> login(String studentId, String password) async {
    await Future.delayed(_delay);
    
    // Mock login validation
    if (studentId.isNotEmpty && password.isNotEmpty) {
      if (studentId == 'test' && password == 'password') {
        return Student(
          id: 'test',
          name: "Test User",
          course: "B.S. Information Technology",
        );
      } else if (password == 'password123') { // Simple mock condition
        return Student(
          id: studentId,
          name: "John Doe",
          course: "B.S. Computer Science",
        );
      } else {
        throw Exception("Invalid password. Try 'password123' or use 'test'/'password' account");
      }
    } else {
      throw Exception("Student ID and Password are required");
    }
  }

  Future<Map<String, dynamic>> fetchGrades(String studentId) async {
    await Future.delayed(_delay);
    
    // Simulate API JSON response
    final mockResponse = {
      "student": "John Doe",
      "grades": [
        { "subject": "Mathematics", "grade": 92 },
        { "subject": "Science", "grade": 88 },
        { "subject": "English", "grade": 91 },
        { "subject": "History", "grade": 75 },
        { "subject": "Physical Education", "grade": 100 },
        { "subject": "Programming", "grade": 65 }, // Test poor grade
      ]
    };
    
    return mockResponse;
  }
}
