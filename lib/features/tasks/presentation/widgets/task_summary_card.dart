import 'package:flutter/material.dart';

class TaskSummaryCard extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;

  const TaskSummaryCard({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = totalTasks == 0 ? 0.0 : completedTasks / totalTasks;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Resumo do dia'),
                  const SizedBox(height: 22),
                  Text('Total de tarefas: $totalTasks'),
                  const SizedBox(height: 8),
                  Text('Tarefas completadas: $completedTasks'),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              height: 80,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: progress),
                duration: const Duration(
                  milliseconds: 600,
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
                          '${(animatedValue * 100).toInt()}%', 
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
