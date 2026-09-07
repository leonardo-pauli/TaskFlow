import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:taskflow/core/di/injection_container.dart';
import 'package:taskflow/domain/task_entity.dart';
import 'package:taskflow/features/tasks/presentation/controllers/task_controller.dart';

class PomodoroController extends ChangeNotifier {
  Timer? _timer;
  TaskEntity? _currentTask;
  TaskEntity? get currentTask => _currentTask;

  static const int focusTime = 2 * 60;
  static const int breakTime = 1 * 60;

  int _remainingSeconds = focusTime;
  bool _isRunning = false;
  bool _isFocusMode = true;
  int _completedCycles = 0;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isFocusMode => _isFocusMode;
  int get completedCycles => _completedCycles;

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void setCurrentTask(TaskEntity? task) {
    _currentTask = task;
    _completedCycles = 0;
    notifyListeners();
  }

  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _switchMode();
      }
    });
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void resetTimer() {
    _timer?.cancel();
    _isRunning = false;
    _remainingSeconds = _isFocusMode ? focusTime : breakTime;
    notifyListeners();
  }

  void _switchMode() {
    _timer?.cancel();
    _isRunning = false;

    // Incrementa ciclos ao sair do foco (transição foco → pausa)
    if (_isFocusMode) {
      _completedCycles++;
    }

    _isFocusMode = !_isFocusMode;
    _remainingSeconds = _isFocusMode ? focusTime : breakTime;
    notifyListeners();
  }

  /// Atualiza o status da tarefa vinculada via TaskController (getIt).
  /// Retorna `true` se a atualização foi bem-sucedida.
  Future<bool> updateTaskStatus(TaskStatus newStatus) async {
    if (_currentTask == null) return false;

    try {
      final taskController = getIt<TaskController>();
      final updatedTask = _currentTask!.copyWith(status: newStatus);

      await taskController.updateTask(updatedTask);
      _currentTask = updatedTask;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}