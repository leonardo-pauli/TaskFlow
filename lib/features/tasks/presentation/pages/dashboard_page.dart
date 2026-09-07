import 'package:flutter/material.dart';
import 'package:taskflow/core/di/injection_container.dart';
import 'package:taskflow/domain/task_entity.dart';
import 'package:taskflow/features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'package:taskflow/features/settings/presentation/pages/settings_page.dart';
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

  void _onChangeStatus(TaskEntity taskAtual, TaskStatus novoStatus) {
    final tarefaAtualizada = taskAtual.copyWith(status: novoStatus);
    controller.updateTask(tarefaAtualizada);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TaskFlow'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PomodoroPage()),
                );
              },
              icon: const Icon(Icons.timer),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Column(
          children: [
            // 1. O Card escuta o controller sozinho (micro-rebuild)
            ListenableBuilder(
              listenable: controller,
              builder: (context, _) {
                if (controller.isLoading) {
                  return const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return TaskSummaryCard(
                  totalTasks: controller.tasks.length,
                  completedTasks: controller.tasks
                      .where((task) => task.status == TaskStatus.done)
                      .length,
                );
              },
            ),

            // 2. A barra de pesquisa NÃO precisa do ListenableBuilder
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                onChanged: controller.setSearchQuery,
                decoration: InputDecoration(
                  hintText: 'Buscar tarefas...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Colors.deepPurple,
                  ),
                  filled: true,
                  fillColor: Colors.deepPurple.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 3. TabBar é estático — const
            const TabBar(
              tabs: [
                Tab(text: 'A Fazer'),
                Tab(text: 'Fazendo'),
                Tab(text: 'Completo'),
              ],
            ),

            // 4. As listas escutam o controller de forma isolada (micro-rebuild)
            Expanded(
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  return TabBarView(
                    children: [
                      TaskListWidget(
                        tasks: controller.tasks
                            .where((task) => task.status == TaskStatus.todo)
                            .toList(),
                        onDelete: (id) => controller.deleteTask(id),
                        onEdit: _showEditModal,
                        onChangeStatus: _onChangeStatus,
                      ),
                      TaskListWidget(
                        tasks: controller.tasks
                            .where((task) => task.status == TaskStatus.doing)
                            .toList(),
                        onDelete: (id) => controller.deleteTask(id),
                        onEdit: _showEditModal,
                        onChangeStatus: _onChangeStatus,
                      ),
                      TaskListWidget(
                        tasks: controller.tasks
                            .where((task) => task.status == TaskStatus.done)
                            .toList(),
                        onDelete: (id) => controller.deleteTask(id),
                        onEdit: _showEditModal,
                        onChangeStatus: _onChangeStatus,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
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
