import 'dart:convert';

enum TaskStatus {
  incomplete,
  inProgress,
  complete;

  String toJson() => name;
  factory TaskStatus.fromJson(String json) => TaskStatus.values.byName(json);
}

class TaskModel {
  final String id;
  final String title;
  final DateTime dueDate;
  final TaskStatus status;

  TaskModel({
    required this.id,
    required this.title,
    required this.dueDate,
    this.status = TaskStatus.incomplete,
  });

  bool get isCompleted => status == TaskStatus.complete;

  TaskModel copyWith({
    String? id,
    String? title,
    DateTime? dueDate,
    TaskStatus? status,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'status': status.toJson(),
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] ?? 0),
      status: map['status'] != null
          ? TaskStatus.fromJson(map['status'])
          : (map['isCompleted'] == true
                ? TaskStatus.complete
                : TaskStatus.incomplete),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));
}
