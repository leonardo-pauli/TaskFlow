import 'package:flutter/material.dart';
import 'package:taskflow/core/di/injection_container.dart';
import 'package:taskflow/features/pomodoro/presentation/controllers/pomodoro_controller.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final controller = getIt<PomodoroController>();
    

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListenableBuilder(
              listenable: controller,
              builder: (context, child) => Text(controller.isFocusMode ? "Tempo de Foco" : "Pausa Curta"),
               ),
            SizedBox(height: 22,),
            SizedBox(
            width: 250,
            height: 250,
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, child) {
                final int tempoTotal = controller.isFocusMode 
    ? PomodoroController.focusTime 
    : PomodoroController.breakTime;

    final double progress = controller.remainingSeconds / tempoTotal ;
                return TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 1.0, end: progress),
                duration: const Duration(
                  milliseconds: 300,
                ), 
                curve: Curves.easeInOut, 
                builder: (context, animatedValue, child) {
                  
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value:
                            animatedValue, 
                        strokeWidth: 8.0,
                        backgroundColor: Colors.deepPurple.withValues(alpha: 0.2),
                        color: Colors.deepPurple,
                      ),
                      Center(
                        child: Text(
                          controller.formattedTime, 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
              },
            ),
          ),
          SizedBox(height: 36,),
          Row(
            children: [
              Expanded(
                child: Container(
                  width: 90,
                  height: 70,
                  decoration: BoxDecoration(
                
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: IconButton(
                    onPressed: (){
                      controller.isRunning ? controller.pauseTimer() : controller.startTimer();
                    }, 
                    icon: Icon(controller.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded, size: 28,),
                    padding: EdgeInsets.all(16),
                    ),
                ),
              ),
              SizedBox(width: 22,),
              Expanded(
                child: Container(
                  width: 90,
                  height: 70,
                  decoration: BoxDecoration(
                
                    border: BoxBorder.all(color: Colors.deepPurple, width: 2, ),
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: IconButton(
                    onPressed: (){
                      controller.resetTimer();
                    }, 
                    icon: Icon(Icons.restart_alt_rounded, size: 28,),
                    padding: EdgeInsets.all(16),
                    ),),
              ),
            ],
          )
          ],
        ),
      ),
    );
  }
}