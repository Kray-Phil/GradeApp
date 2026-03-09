import 'package:flutter/material.dart';
import 'package:banzon_gradeapp/models/student.dart';
import 'package:banzon_gradeapp/services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Student? _currentStudent;
  bool _isLoading = false;
  String? _errorMessage;

  Student? get currentStudent => _currentStudent;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentStudent != null;

  Future<bool> login(String studentId, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentStudent = await _apiService.login(studentId, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentStudent = null;
    notifyListeners();
  }
}
