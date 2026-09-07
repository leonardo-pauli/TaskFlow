import 'package:flutter/material.dart';
import 'package:taskflow/core/di/injection_container.dart';
import 'package:taskflow/domain/task_entity.dart';
import 'package:taskflow/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:taskflow/features/pomodoro/presentation/pages/pomodoro_page.dart';
import 'package:taskflow/features/tasks/presentation/controllers/task_controller.dart';

class TaskDetailPage extends StatefulWidget {
  final TaskEntity task;

  const TaskDetailPage({super.key, required this.task});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority _selectedPriority;
  late TaskStatus _selectedStatus;
  late TaskEntity _currentTask;
  bool _isEditing = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _currentTask = widget.task;
    _titleController = TextEditingController(text: _currentTask.title);
    _descriptionController = TextEditingController(text: _currentTask.description);
    _selectedPriority = _currentTask.priority;
    _selectedStatus = _currentTask.status;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _priorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return 'Urgente';
      case TaskPriority.important:
        return 'Importante';
      case TaskPriority.medium:
        return 'Média';
    }
  }

  IconData _priorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return Icons.warning_amber_rounded;
      case TaskPriority.important:
        return Icons.priority_high_rounded;
      case TaskPriority.medium:
        return Icons.remove_rounded;
    }
  }

  Color _priorityColor(TaskPriority priority, ColorScheme colorScheme) {
    switch (priority) {
      case TaskPriority.urgent:
        return colorScheme.error;
      case TaskPriority.important:
        return Colors.orange;
      case TaskPriority.medium:
        return colorScheme.primary;
    }
  }

  String _statusLabel(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return 'A Fazer';
      case TaskStatus.doing:
        return 'Fazendo';
      case TaskStatus.done:
        return 'Concluído';
    }
  }

  IconData _statusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.todo:
        return Icons.radio_button_unchecked_rounded;
      case TaskStatus.doing:
        return Icons.timelapse_rounded;
      case TaskStatus.done:
        return Icons.check_circle_rounded;
    }
  }

  void _saveChanges() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título não pode estar vazio')),
      );
      return;
    }

    final updatedTask = _currentTask.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      priority: _selectedPriority,
      status: _selectedStatus,
    );

    final taskController = getIt<TaskController>();
    taskController.updateTask(updatedTask);

    setState(() {
      _currentTask = updatedTask;
      _isEditing = false;
      _hasChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tarefa atualizada com sucesso!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _startPomodoro() {
    final pomodoroController = getIt<PomodoroController>();
    pomodoroController.setCurrentTask(_currentTask);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PomodoroPage(initialTask: _currentTask),
      ),
    );
  }

  void _cancelEditing() {
    setState(() {
      _titleController.text = _currentTask.title;
      _descriptionController.text = _currentTask.description;
      _selectedPriority = _currentTask.priority;
      _selectedStatus = _currentTask.status;
      _isEditing = false;
      _hasChanges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _hasChanges) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Descartar alterações?'),
              content: const Text(
                'Você tem alterações não salvas. Deseja descartá-las?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Continuar editando'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: const Text('Descartar'),
                ),
              ],
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes da Tarefa'),
          actions: [
            if (_isEditing) ...[
              IconButton(
                onPressed: _cancelEditing,
                icon: const Icon(Icons.close_rounded),
                tooltip: 'Cancelar',
              ),
              IconButton(
                onPressed: _saveChanges,
                icon: const Icon(Icons.check_rounded),
                tooltip: 'Salvar',
              ),
            ] else
              IconButton(
                onPressed: () => setState(() => _isEditing = true),
                icon: const Icon(Icons.edit_rounded),
                tooltip: 'Editar',
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card com título e descrição
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      colorScheme.primaryContainer.withValues(alpha: 0.5),
                      colorScheme.surfaceContainerLow,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_isEditing) ...[
                      TextField(
                        controller: _titleController,
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (_) => setState(() => _hasChanges = true),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style: textTheme.bodyLarge,
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (_) => setState(() => _hasChanges = true),
                      ),
                    ] else ...[
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _priorityColor(_currentTask.priority, colorScheme)
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _priorityIcon(_currentTask.priority),
                              color: _priorityColor(_currentTask.priority, colorScheme),
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _currentTask.title,
                              style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_currentTask.description.isNotEmpty) ...[
                        const SizedBox(height: 14),
                        Text(
                          _currentTask.description,
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Status e Prioridade
              Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      label: 'Status',
                      icon: _statusIcon(_isEditing ? _selectedStatus : _currentTask.status),
                      value: _statusLabel(_isEditing ? _selectedStatus : _currentTask.status),
                      color: colorScheme.primary,
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      label: 'Prioridade',
                      icon: _priorityIcon(_isEditing ? _selectedPriority : _currentTask.priority),
                      value: _priorityLabel(_isEditing ? _selectedPriority : _currentTask.priority),
                      color: _priorityColor(
                        _isEditing ? _selectedPriority : _currentTask.priority,
                        colorScheme,
                      ),
                      colorScheme: colorScheme,
                      textTheme: textTheme,
                    ),
                  ),
                ],
              ),

              if (_isEditing) ...[
                const SizedBox(height: 20),

                // Seletor de Status
                Text(
                  'Alterar Status',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: TaskStatus.values.map((status) {
                    final isSelected = _selectedStatus == status;
                    return ChoiceChip(
                      label: Text(_statusLabel(status)),
                      selected: isSelected,
                      avatar: Icon(
                        _statusIcon(status),
                        size: 18,
                        color: isSelected ? colorScheme.onPrimaryContainer : null,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedStatus = status;
                            _hasChanges = true;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                // Seletor de Prioridade
                Text(
                  'Alterar Prioridade',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: TaskPriority.values.map((priority) {
                    final isSelected = _selectedPriority == priority;
                    return ChoiceChip(
                      label: Text(_priorityLabel(priority)),
                      selected: isSelected,
                      avatar: Icon(
                        _priorityIcon(priority),
                        size: 18,
                        color: isSelected ? colorScheme.onPrimaryContainer : null,
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedPriority = priority;
                            _hasChanges = true;
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 20),

              // Data de criação
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Criada em',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(_currentTask.createdAt),
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Botão de Pomodoro
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton.icon(
                  onPressed: _startPomodoro,
                  icon: const Icon(Icons.timer_rounded, size: 24),
                  label: const Text(
                    'Iniciar Pomodoro',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Botão de deletar
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Excluir tarefa?'),
                        content: const Text(
                          'Essa ação não pode ser desfeita.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () {
                              final taskController = getIt<TaskController>();
                              taskController.deleteTask(_currentTask.id);
                              Navigator.pop(context); // fecha dialog
                              Navigator.pop(context); // volta para dashboard
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: colorScheme.error,
                            ),
                            child: const Text('Excluir'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.delete_outline_rounded, color: colorScheme.error),
                  label: Text(
                    'Excluir Tarefa',
                    style: TextStyle(color: colorScheme.error),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year às $hour:$minute';
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String value;
  final Color color;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _InfoCard({
    required this.label,
    required this.icon,
    required this.value,
    required this.color,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
