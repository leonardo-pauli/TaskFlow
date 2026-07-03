import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskflow/domain/task_entity.dart';

class TaskListWidget extends StatelessWidget {
final List<TaskEntity> tasks;

  const TaskListWidget({super.key, required this.tasks});

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
          trailing: Icon(Icons.delete, color: Colors.red),
          leading: CircleAvatar(child: Text(task.priority.name[0].toUpperCase())),
        );
      },
      itemCount: tasks.length,
      );
  }
}