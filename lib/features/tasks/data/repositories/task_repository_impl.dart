import 'package:hive/hive.dart';
import 'package:taskflow/domain/task_entity.dart';
import 'package:taskflow/features/tasks/data/models/task_model.dart';
import 'package:taskflow/features/tasks/domain/repositories/itask_repository.dart';

class TaskRepositoryImpl implements ITaskRepository {
  final Box box;

  TaskRepositoryImpl({required this.box});

  @override
  Future<void> deleteTask(String id) async {
    await box.delete(id);
  }

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    final results = box.values;
    return results
        .map((e) => TaskModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  Future<void> saveTask(TaskEntity task) async {
    final boxModel = TaskModel(
      createdAt: task.createdAt,
      id: task.id,
      priority: task.priority,
      status: task.status,
      title: task.title,
      description: task.description,
    );
    await box.put(task.id, boxModel.toMap());
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final boxModel = TaskModel(
      createdAt: task.createdAt,
      id: task.id,
      priority: task.priority,
      status: task.status,
      title: task.title,
      description: task.description,
    );
    await box.put(task.id, boxModel.toMap());
  }
}
