import 'package:taskflow/domain/task_entity.dart';
import 'package:taskflow/features/tasks/domain/repositories/itask_repository.dart';

class GetAllTasksUsecase {
  final ITaskRepository repository;

  GetAllTasksUsecase({required this.repository});

  Future<List<TaskEntity>> call() async {
    return await repository.getAllTasks();
  }
}
