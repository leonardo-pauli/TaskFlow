import 'package:flutter/material.dart';
import 'package:taskflow/domain/task_entity.dart';

class AddTaskFormWidget extends StatefulWidget {
  final TaskEntity? taskToEdit;
  final Function(TaskEntity) onSave;

  const AddTaskFormWidget({super.key, required this.onSave, this.taskToEdit});

  @override
  State<AddTaskFormWidget> createState() => _AddTaskFormWidgetState();
}

class _AddTaskFormWidgetState extends State<AddTaskFormWidget> {
  TaskPriority _selectedPriority = TaskPriority.medium;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

@override
  void initState() {
    super.initState();
    if(widget.taskToEdit != null){
      _titleController.text = widget.taskToEdit!.title;
      _descriptionController.text = widget.taskToEdit!.description;
      _selectedPriority = widget.taskToEdit!.priority;
    }

  }

  @override
  void dispose() {
    
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Titulo'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            SizedBox(height: 16),
            Text('Prioridade:'),
            Wrap(
              spacing: 8,

              children: TaskPriority.values.map((priority) {
                return ChoiceChip(
                  label: Text(priority.name.toUpperCase()),
                  selected: _selectedPriority == priority,
                  onSelected: (bool isSelected) {
                    if (isSelected) {
                      setState(() {
                        _selectedPriority = priority;
                      });
                    }
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 22),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty) return;

                final newTask = TaskEntity(
                  createdAt: widget.taskToEdit != null ? widget.taskToEdit!.createdAt : DateTime.now(),
                  id: widget.taskToEdit != null ? widget.taskToEdit!.id : DateTime.now().millisecondsSinceEpoch.toString(),
                  priority: _selectedPriority,
                  status: widget.taskToEdit != null ? widget.taskToEdit!.status :  TaskStatus.todo,
                  title: _titleController.text,
                  description: _descriptionController.text,
                );
                widget.onSave(newTask);
                Navigator.pop(context);
              },
              child: Text('Salvar Tarefa'),
            ),
          ],
        ),
      ),
    );
  }
}
