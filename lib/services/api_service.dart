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
    
    // Simulate API JSON response with professional college grading system data
    final mockResponse = {
      "student": "John Doe",
      "grades": [
        // 1st Year, 1st Semester
        { "code": "ENG 101", "subject": "Speech and Oral Communication", "grade": 92, "units": 3.0, "semester": 1, "academic_year": "2024-2025" },
        { "code": "MATH 101", "subject": "College Algebra", "grade": 88, "units": 3.0, "semester": 1, "academic_year": "2024-2025" },
        { "code": "CS 101", "subject": "Introduction to Computing", "grade": 91, "units": 3.0, "semester": 1, "academic_year": "2024-2025" },
        { "code": "HIST 101", "subject": "Readings in Philippine History", "grade": 75, "units": 3.0, "semester": 1, "academic_year": "2024-2025" },
        { "code": "PE 101", "subject": "Physical Fitness", "grade": 100, "units": 2.0, "semester": 1, "academic_year": "2024-2025" },
        { "code": "PROG 101", "subject": "Programming Fundamentals 1", "grade": 85, "units": 3.0, "semester": 1, "academic_year": "2024-2025" },
        
        // 1st Year, 2nd Semester
        { "code": "ENG 102", "subject": "Purposive Communication", "grade": 94, "units": 3.0, "semester": 2, "academic_year": "2024-2025" },
        { "code": "MATH 102", "subject": "Trigonometry", "grade": 85, "units": 3.0, "semester": 2, "academic_year": "2024-2025" },
        { "code": "CS 102", "subject": "Computer Programming 2", "grade": 93, "units": 3.0, "semester": 2, "academic_year": "2024-2025" },
        { "code": "SOC 101", "subject": "Contemporary World", "grade": 82, "units": 3.0, "semester": 2, "academic_year": "2024-2025" },
        { "code": "PE 102", "subject": "Rhythmic Activities", "grade": 98, "units": 2.0, "semester": 2, "academic_year": "2024-2025" },
        { "code": "NSTP 1", "subject": "CWTS 1", "grade": 95, "units": 3.0, "semester": 2, "academic_year": "2024-2025" },
      ]
    };
    
    return mockResponse;
  }
}
