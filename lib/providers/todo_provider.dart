import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:banzon_gradeapp/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  static const String _tasksKey = 'todo_tasks';
  List<TaskModel> _tasks = [];
  final _uuid = const Uuid();

  List<TaskModel> get tasks => _tasks;
  
  List<TaskModel> get incompleteTasks => 
      _tasks.where((task) => !task.isCompleted).toList();
      
  List<TaskModel> get completedTasks => 
      _tasks.where((task) => task.isCompleted).toList();

  TodoProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey);
    
    if (tasksJson != null) {
      _tasks = tasksJson.map((jsonStr) => TaskModel.fromJson(jsonStr)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => task.toJson()).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  void addTask(String title, DateTime dueDate) {
    if (title.isEmpty) return;
    
    final newTask = TaskModel(
      id: _uuid.v4(),
      title: title,
      dueDate: dueDate,
    );
    
    _tasks.add(newTask);
    _sortTasks();
    _saveTasks();
    notifyListeners();
  }

  void toggleTaskStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted
      );
      _sortTasks();
      _saveTasks();
      notifyListeners();
    }
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasks();
    notifyListeners();
  }
  
  void _sortTasks() {
    // Sort tasks: incomplete first, then by due date
    _tasks.sort((a, b) {
      if (a.isCompleted == b.isCompleted) {
        return a.dueDate.compareTo(b.dueDate);
      }
      return a.isCompleted ? 1 : -1;
    });
  }
}
