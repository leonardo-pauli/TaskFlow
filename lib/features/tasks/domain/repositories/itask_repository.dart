import 'package:taskflow/features/tasks/domain/entity/task_entity.dart';

abstract class ITaskRepository {
  Future<List<TaskEntity>> getAllTasks();
  Future<void> saveTask(TaskEntity task);
  Future<void> updateTask(TaskEntity task);
  Future<void> deleteTask(String id);
}