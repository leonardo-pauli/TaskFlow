import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskSummaryCard extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  
  
   const TaskSummaryCard({super.key, required this.totalTasks, required this.completedTasks});

  @override
  Widget build(BuildContext context) {
    double progress = totalTasks == 0 ? 0.0 : completedTasks  / totalTasks;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded( 
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Resumo do dia'),
                  SizedBox(height: 22,),
                  Text('Total de tarefas: $totalTasks'),
                  SizedBox(height: 8,),
                  Text('Tarefas completadas: $completedTasks'),
                ],
              ),
            ),
            SizedBox(
            height: 60,
            width: 60,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progress), 
              duration: const Duration(seconds: 1), 
              builder: (ctx, valorAnimado, child){
                return Stack(children:[
                  CircularProgressIndicator(value: valorAnimado,),
                  Center(child: Text('${(progress * 100).toInt()}%'))]);
              },
              ),
              ),


          ],
        ),
        ),
    );
  }
}