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

  /// Cache filtrada para evitar recalcular em cada acesso ao getter.
  List<TaskEntity>? _filteredTasksCache;
  String _lastCacheQuery = '';

  List<TaskEntity> get tasks {
    if (_searchQuery.isEmpty) {
      return _tasks;
    }
    // Retorna cache se a query não mudou
    if (_filteredTasksCache != null && _lastCacheQuery == _searchQuery) {
      return _filteredTasksCache!;
    }
    final lowerQuery = _searchQuery.toLowerCase();
    _filteredTasksCache = _tasks.where((task) {
      return task.title.toLowerCase().contains(lowerQuery);
    }).toList();
    _lastCacheQuery = _searchQuery;
    return _filteredTasksCache!;
  }

  TaskController({
    required this.saveTaskUseCase,
    required this.updateTaskuseCase,
    required this.deleteTaskUseCase,
    required this.getAllTasksUseCase,
  });

  void setSearchQuery(String query) {
    _searchQuery = query;
    _invalidateFilterCache();
    notifyListeners();
  }

  Future<void> loadTasks() async {
    isLoading = true;
    notifyListeners();
    _tasks = await getAllTasksUseCase();
    _invalidateFilterCache();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(TaskEntity task) async {
    try {
      // Optimistic: adiciona na memória primeiro
      _tasks.add(task);
      _invalidateFilterCache();
      notifyListeners();

      // Persiste no Hive via UseCase
      await saveTaskUseCase(task);
    } catch (e) {
      // Rollback: recarrega do Hive se falhar
      await loadTasks();
      throw Exception(e.toString());
    }
  }

  Future<void> updateTask(TaskEntity task) async {
    try {
      // Optimistic: atualiza na memória primeiro para UI reagir instantaneamente
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        _invalidateFilterCache();
        notifyListeners();
      }

      // Persiste no Hive via UseCase (pontual, usando a chave do ID)
      await updateTaskuseCase(task);
    } catch (e) {
      // Rollback: recarrega do Hive se falhar
      await loadTasks();
      throw Exception(e.toString());
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      // Optimistic: remove da memória primeiro
      _tasks.removeWhere((t) => t.id == id);
      _invalidateFilterCache();
      notifyListeners();

      // Persiste no Hive via UseCase
      await deleteTaskUseCase(id);
    } catch (e) {
      // Rollback: recarrega do Hive se falhar
      await loadTasks();
      throw Exception(e.toString());
    }
  }

  /// Invalida a cache de filtro ao mudar _tasks ou _searchQuery.
  void _invalidateFilterCache() {
    _filteredTasksCache = null;
    _lastCacheQuery = '';
  }
}
