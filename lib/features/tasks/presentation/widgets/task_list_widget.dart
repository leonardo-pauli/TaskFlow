import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskflow/domain/task_entity.dart';

class TaskListWidget extends StatelessWidget {
  final List<TaskEntity> tasks;
  final Function(String) onDelete;
  final Function(TaskEntity) onEdit;

  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.onDelete, 
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return Center(child: Text('Nenhuma tarefa por aqui!'));
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        final task = tasks[index];
        return Dismissible(
          background: Container(
            color: Colors.blue,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.edit, color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          confirmDismiss: (direction) async{
            if(direction == DismissDirection.endToStart){
              onDelete(task.id);
              return true;
            }else if (direction == DismissDirection.startToEnd){
              onEdit(task);
              return false;
            }
            return false;
          },
          key: ValueKey(task.id),
          child: ListTile(
            title: Text(task.title),
            subtitle: Text(task.description),

            leading: CircleAvatar(
              child: Text(task.priority.name[0].toUpperCase()),
            ),
          ),
        );
      },
      itemCount: tasks.length,
    );
  }
}
