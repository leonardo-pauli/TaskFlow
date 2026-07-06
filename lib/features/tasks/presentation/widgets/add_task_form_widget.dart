import 'package:flutter/material.dart';
import 'package:taskflow/domain/task_entity.dart';

class AddTaskFormWidget extends StatefulWidget {
  final Function(TaskEntity) onSave;

  const AddTaskFormWidget({super.key, required this.onSave});

  @override
  State<AddTaskFormWidget> createState() => _AddTaskFormWidgetState();
}

class _AddTaskFormWidgetState extends State<AddTaskFormWidget> {
  TaskPriority _selectedPriority = TaskPriority.medium;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
                  createdAt: DateTime.now(),
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  priority: _selectedPriority,
                  status: TaskStatus.todo,
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
