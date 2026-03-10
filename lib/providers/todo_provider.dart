import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:banzon_gradeapp/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TodoProvider extends ChangeNotifier {
  static const String _tasksKey = 'todo_tasks';
  List<TaskModel> _tasks = [];
  final _uuid = const Uuid();

  List<TaskModel> get tasks => _tasks;

  List<TaskModel> get incompleteOnlyTasks =>
      _tasks.where((task) => task.status == TaskStatus.incomplete).toList();

  List<TaskModel> get inProgressTasks =>
      _tasks.where((task) => task.status == TaskStatus.inProgress).toList();

  List<TaskModel> get completedTasks =>
      _tasks.where((task) => task.status == TaskStatus.complete).toList();

  TodoProvider() {
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList(_tasksKey);

    if (tasksJson != null) {
      _tasks = tasksJson.map((jsonStr) => TaskModel.fromJson(jsonStr)).toList();
      _sortTasks(); // Sort after loading
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => task.toJson()).toList();
    await prefs.setStringList(_tasksKey, tasksJson);
  }

  void addTask(
    String title,
    DateTime dueDate, {
    TaskStatus status = TaskStatus.incomplete,
  }) {
    if (title.isEmpty) return;

    final newTask = TaskModel(
      id: _uuid.v4(),
      title: title,
      dueDate: dueDate,
      status: status,
    );

    _tasks.add(newTask);
    _sortTasks();
    _saveTasks();
    notifyListeners();
  }

  void updateTaskStatus(String id, TaskStatus newStatus) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(status: newStatus);
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
    // Sort tasks: In Progress first, then Incomplete, then Complete
    // Within each status, sort by due date
    _tasks.sort((a, b) {
      if (a.status == b.status) {
        return a.dueDate.compareTo(b.dueDate);
      }

      // Status priority: inProgress (0) < incomplete (1) < complete (2)
      final priorityA = _getStatusPriority(a.status);
      final priorityB = _getStatusPriority(b.status);

      return priorityA.compareTo(priorityB);
    });
  }

  int _getStatusPriority(TaskStatus status) {
    switch (status) {
      case TaskStatus.inProgress:
        return 0;
      case TaskStatus.incomplete:
        return 1;
      case TaskStatus.complete:
        return 2;
    }
  }
}
