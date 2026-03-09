import 'dart:convert';

class TaskModel {
  final String id;
  final String title;
  final DateTime dueDate;
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] ?? 0),
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) => TaskModel.fromMap(json.decode(source));
}
