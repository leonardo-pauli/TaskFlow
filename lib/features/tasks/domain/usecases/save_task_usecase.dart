import 'package:taskflow/domain/task_entity.dart';

import 'package:taskflow/features/tasks/domain/repositories/itask_repository.dart';

class SaveTaskUseCase {
  final ITaskRepository repository;

  SaveTaskUseCase({required this.repository});

  Future<void> call(TaskEntity task) async {
    await repository.saveTask(task);
  }
}
