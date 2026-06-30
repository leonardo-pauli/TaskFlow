import 'package:taskflow/features/tasks/domain/entity/task_entity.dart';
import 'package:taskflow/features/tasks/domain/repositories/itask_repository.dart';

class TaskRepositoryImpl implements ITaskRepository{
 final dynamic box;

 TaskRepositoryImpl({required this.box});

  @override
  Future<void> deleteTask(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<TaskEntity>> getAllTasks() {
    throw UnimplementedError();
  }

  @override
  Future<void> saveTask(TaskEntity task) {
    throw UnimplementedError();
  }

  @override
  Future<void> updateTask(TaskEntity task) {
    throw UnimplementedError();
  }
}