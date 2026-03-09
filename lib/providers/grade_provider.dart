import 'package:flutter/material.dart';
import 'package:banzon_gradeapp/models/grade.dart';
import 'package:banzon_gradeapp/services/api_service.dart';

class GradeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Grade> _grades = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _studentName = '';

  List<Grade> get grades => _grades;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get studentName => _studentName;

  Future<void> fetchGrades(String studentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.fetchGrades(studentId);
      
      _studentName = response['student'];
      
      final List<dynamic> gradesData = response['grades'];
      _grades = gradesData.map((data) => Grade.fromJson(data)).toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to load grades. Please try again later.";
      _isLoading = false;
      notifyListeners();
    }
  }
}
