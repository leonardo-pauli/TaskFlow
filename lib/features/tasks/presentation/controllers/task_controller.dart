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
  String _searchQuery = '';
  bool isLoading = false;
  List<TaskEntity> _tasks = [];
  List<TaskEntity> get tasks {
    if(_searchQuery.isEmpty){
      return _tasks;
    }
    return _tasks.where((task){
      return task.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  TaskController({
    required this.saveTaskUseCase,
    required this.updateTaskuseCase,
    required this.deleteTaskUseCase,
    required this.getAllTasksUseCase,
  });

  void setSearchQuery(String query){
    _searchQuery = query;
    notifyListeners();
  }

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
