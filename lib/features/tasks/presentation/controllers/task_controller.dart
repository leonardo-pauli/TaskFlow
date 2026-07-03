import 'package:flutter/foundation.dart';
import 'package:taskflow/domain/task_entity.dart';
import 'package:taskflow/features/tasks/domain/usecases/delete_task_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/get_all_tasks_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/save_task_usecase.dart';
import 'package:taskflow/features/tasks/domain/usecases/update_task_usecase.dart';

class TaskController extends ChangeNotifier {
  final SaveTaskUseCase saveTaskUseCase;
  final UpdateTaskUseCase updateTaskuseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final GetAllTasksUseCase getAllTasksUseCase;
  bool isLoading = false;
  List<TaskEntity> _tasks = [];
  List<TaskEntity> get tasks => _tasks;

  TaskController({
    required this.saveTaskUseCase,
    required this.updateTaskuseCase,
    required this.deleteTaskUseCase,
    required this.getAllTasksUseCase,
  });

  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();
    _tasks = await getAllTasksUseCase();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(TaskEntity task) async {
    try {
      await saveTaskUseCase(task);
      await loadTasks();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      await updateTaskuseCase(task);
      await loadTasks();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await deleteTaskUseCase(id);
      await loadTasks();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
