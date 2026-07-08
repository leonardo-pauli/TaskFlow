import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskflow/core/di/injection_container.dart';
import 'package:taskflow/domain/task_entity.dart';
import 'package:taskflow/features/tasks/presentation/controllers/task_controller.dart';
import 'package:taskflow/features/tasks/presentation/widgets/add_task_form_widget.dart';
import 'package:taskflow/features/tasks/presentation/widgets/task_list_widget.dart';
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

  void _showEditModal(TaskEntity task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: AddTaskFormWidget(
            taskToEdit: task,
            onSave: (updateTask) {
              controller.updateTask(updateTask);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text('TaskFlow')),
        body: ListenableBuilder(
          listenable: controller,
          builder: (_, widget) {
            return controller.isLoading
                ? Center(child: CircularProgressIndicator())
                : Center(
                    child: Column(
                      children: [
                        TaskSummaryCard(
                          totalTasks: controller.tasks.length,
                          completedTasks: controller.tasks
                              .where((task) => task.status == TaskStatus.done)
                              .length,
                        ),
                        TabBar(
                          tabs: [
                            Tab(text: 'A Fazer'),
                            Tab(text: 'Fazendo'),
                            Tab(text: 'Completo'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              TaskListWidget(
                                tasks: controller.tasks
                                    .where(
                                      (task) => task.status == TaskStatus.todo,
                                    )
                                    .toList(),
                                onDelete: (id) => controller.deleteTask(id),
                                onEdit: _showEditModal,
                              ),
                              TaskListWidget(
                                tasks: controller.tasks
                                    .where(
                                      (task) => task.status == TaskStatus.doing,
                                    )
                                    .toList(),
                                onDelete: (id) => controller.deleteTask(id),
                                onEdit: _showEditModal,
                              ),
                              TaskListWidget(
                                tasks: controller.tasks
                                    .where(
                                      (task) => task.status == TaskStatus.done,
                                    )
                                    .toList(),
                                onDelete: (id) => controller.deleteTask(id),
                                onEdit: _showEditModal,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: SizedBox(
                    height: 300,
                    child: AddTaskFormWidget(
                      onSave: (task) => controller.addTask(task),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
