import 'dart:async';

import 'package:flutter/widgets.dart';

class PomodoroController extends ChangeNotifier{
  Timer? _timer;

  static const int focusTime = 2 * 60;
  static const int breakTime = 1 * 60;

  int _remainingSeconds = focusTime;
  bool _isRunning = false;
  bool _isFocusMode = true;

  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isFocusMode => _isFocusMode;

  String get formattedTime {
  final minutes = _remainingSeconds ~/ 60;
  final seconds = _remainingSeconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void startTimer() {
    if(_isRunning) return;

    _isRunning = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(_remainingSeconds > 0){
        _remainingSeconds--;
        notifyListeners();
      }else{
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
    _remainingSeconds= _isFocusMode ? focusTime : breakTime;
    notifyListeners();
  }

  void _switchMode() {
    _timer?.cancel();
    _isRunning = false;
    _isFocusMode = !_isFocusMode;
    _remainingSeconds = _isFocusMode ? focusTime : breakTime;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}