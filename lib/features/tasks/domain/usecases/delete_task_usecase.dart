import 'package:taskflow/features/tasks/domain/repositories/itask_repository.dart';

class DeleteTaskUseCase {
  final ITaskRepository repository;

  DeleteTaskUseCase({required this.repository});

  Future<void> call(String id) async {
    await repository.deleteTask(id);
  }
}
