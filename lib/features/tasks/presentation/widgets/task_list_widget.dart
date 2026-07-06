import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskflow/domain/task_entity.dart';

class TaskListWidget extends StatelessWidget {
final List<TaskEntity> tasks;
final Function(String) onDelete;

  const TaskListWidget({super.key, required this.tasks, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    if(tasks.isEmpty){
      return Center(child: Text('Nenhuma tarefa por aqui!'),);
    }
    return ListView.builder(
      itemBuilder: (context, index){
        final task = tasks[index];
        return ListTile(
          title: Text(task.title),
          subtitle: Text(task.description),
          trailing: IconButton(
            onPressed: () => onDelete(task.id),
            icon:  Icon(Icons.delete, color: Colors.red),
           ),
          leading: CircleAvatar(child: Text(task.priority.name[0].toUpperCase())),
        );
      },
      itemCount: tasks.length,
      );
  }
}