import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskflow/core/di/injection_container.dart';
import 'package:taskflow/domain/task_entity.dart';
import 'package:taskflow/features/tasks/presentation/controllers/task_controller.dart';
import 'package:taskflow/features/tasks/presentation/widgets/task_summary_card.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final controller = getIt<TaskController>();
  @override
  void initState() {
    super.initState();
    controller.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TaskFlow')),
      body: ListenableBuilder(
        listenable: controller,
        builder: (_, widget) {
          return controller.isLoading ?  
          Center(child: CircularProgressIndicator()) :
          Center(
            child: TaskSummaryCard(
              totalTasks: controller.tasks.length, 
              completedTasks: controller.tasks.where((task) => task.status == TaskStatus.done).length,
              )
          );
        },
      ),
    );
  }
}
