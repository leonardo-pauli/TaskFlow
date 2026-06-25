import 'package:taskflow/features/tasks/domain/entity/task_entity.dart';
import 'package:taskflow/features/tasks/domain/repositories/itask_repository.dart';

class UpdateTaskUsecase {
  final ITaskRepository repository;

  UpdateTaskUsecase({required this.repository});

  Future<void> call(TaskEntity task) async{
    await repository.updateTask(task);
  }
}