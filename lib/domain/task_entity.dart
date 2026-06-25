enum TaskStatus { todo, doing, done }

enum TaskPriority { urgent, important, normal }

class TaskEntity {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final TaskStatus status;
  final TaskPriority priority;

  const TaskEntity({
    required this.createdAt,
    required this.id,
    required this.priority,
    required this.status,
    required this.title, 
    this.description,
  });
  
  TaskEntity copyWith({String? id, String? title, String? description,
  DateTime? createdAt, TaskStatus? status, TaskPriority? priority}){
    return TaskEntity(
      createdAt: createdAt ?? this.createdAt, 
      description: description ?? this.description, 
      id: id ?? this.id, 
      priority: priority ?? this.priority, 
      status: status ?? this.status, 
      title: title ?? this.title,
      );  
  }
}