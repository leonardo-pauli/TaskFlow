import 'package:taskflow/features/tasks/domain/entity/task_entity.dart';

class TaskModel extends TaskEntity{
  const TaskModel({
    
  required super.createdAt, 
  required super.id, 
  required super.priority, 
  required super.status, 
  required super.title,
  required super.description,
  });

  Map<String, dynamic> toMap(){
   return {
    'id': id,
    'title': title,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
    'status': status.name,
    'priority': priority.name,
   };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map){
    return TaskModel(
      createdAt: DateTime.parse(map['createdAt']), 
      id: map['id'].toString(), 
      priority: TaskPriority.values.firstWhere((e) => e.name == map['priority']), 
      status: TaskStatus.values.firstWhere((e) => e.name == map['status']), 
      title: map['title'], 
      description: map['description'],
      );
    
  }
}