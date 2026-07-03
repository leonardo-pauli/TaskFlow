import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskflow/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:taskflow/features/tasks/domain/repositories/itask_repository.dart';
import 'package:taskflow/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/get_all_tasks_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/save_task_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/update_task_usecase.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  //banco
  await Hive.initFlutter();
  final box = await Hive.openBox('taskbox');
  getIt.registerLazySingleton<Box>(() => box);

  //repositorio
  getIt.registerLazySingleton<ITaskRepository>(
    () => TaskRepositoryImpl(box: getIt()),
  );
  //casos de uso
  getIt.registerLazySingleton<SaveTaskUseCase>(
    () => SaveTaskUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<DeleteTaskUsecase>(
    () => DeleteTaskUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetAllTasksUsecase>(
    () => GetAllTasksUsecase(repository: getIt()),
  );
  getIt.registerLazySingleton<UpdateTaskUsecase>(
    () => UpdateTaskUsecase(repository: getIt()),
  );
  //controller
}
