import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskflow/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:taskflow/features/tasks/domain/repositories/itask_repository.dart';
import 'package:taskflow/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/get_all_tasks_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/save_task_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/update_task_usecase.dart';
import 'package:taskflow/features/tasks/presentation/controllers/task_controller.dart';

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
  getIt.registerLazySingleton<DeleteTaskUseCase>(
    () => DeleteTaskUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<GetAllTasksUseCase>(
    () => GetAllTasksUseCase(repository: getIt()),
  );
  getIt.registerLazySingleton<UpdateTaskUseCase>(
    () => UpdateTaskUseCase(repository: getIt()),
  );
  //controller
  getIt.registerFactory<TaskController>(() => TaskController(
    saveTaskUseCase:getIt(), 
    updateTaskuseCase: getIt(), 
    deleteTaskUseCase: getIt(), 
    getAllTasksUseCase: getIt(),
    ));
}
