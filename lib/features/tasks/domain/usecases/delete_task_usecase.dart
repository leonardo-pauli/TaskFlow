import 'package:taskflow/features/tasks/domain/repositories/itask_repository.dart';

class DeleteTaskUsecase {
  final ITaskRepository repository;

  DeleteTaskUsecase({required this.repository});

  Future<void> call(String id) async{
    await repository.deleteTask(id);
  }
}