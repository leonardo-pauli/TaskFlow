import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskflow/core/di/injection_container.dart';
import 'package:taskflow/domain/task_entity.dart';
import 'package:taskflow/features/pomodoro/presentation/controllers/pomodoro_controller.dart';
import 'package:taskflow/features/tasks/presentation/controllers/task_controller.dart';

class PomodoroPage extends StatelessWidget {
  final TaskEntity? initialTask;

  const PomodoroPage({super.key, this.initialTask});
  void _showStatusSnackBar(
    BuildContext context, {
    required bool success,
    required String message,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: success ? Colors.green.shade600 : colorScheme.error,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showTaskPicker(BuildContext context, PomodoroController controller) {
    final taskController = getIt<TaskController>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return ListenableBuilder(
              listenable: taskController,
              builder: (context, _) {
                final tasks = taskController.tasks
                    .where((t) => t.status != TaskStatus.done)
                    .toList();

                return Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 4),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.playlist_add_check_rounded,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Escolher Tarefa',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                    if (tasks.isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inbox_rounded,
                                size: 48,
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Nenhuma tarefa pendente',
                                style: textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Crie uma tarefa primeiro no dashboard',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: tasks.length,
                          separatorBuilder: (_, _) => Divider(
                            height: 1,
                            indent: 60,
                            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                          ),
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return _TaskPickerItem(
                              task: task,
                              onTap: () {
                                controller.setCurrentTask(task);
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt<PomodoroController>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Vincular a tarefa ao iniciar a página
    if (initialTask != null && controller.currentTask?.id != initialTask!.id) {
      controller.setCurrentTask(initialTask);
    }

    return Scaffold(
      appBar: AppBar(title: Text("Pomodoro")),
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 32.0,
            ),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 420),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.surfaceContainerLow,
                    colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tarefa vinculada ou botão de selecionar
                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, child) {
                      if (controller.currentTask != null) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 18),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(
                              alpha: 0.4,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.task_alt_rounded,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Focando em',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            controller.currentTask!.title,
                                            style: textTheme.titleSmall?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: colorScheme.onPrimaryContainer,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (controller.completedCycles > 0) ...[
                                          const SizedBox(width: 8),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: colorScheme.tertiary.withValues(alpha: 0.15),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              '🍅 x${controller.completedCycles}',
                                              style: textTheme.labelSmall?.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: colorScheme.tertiary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    controller.setCurrentTask(null),
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                tooltip: 'Desvincular tarefa',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Sem tarefa vinculada — botão para escolher
                      return GestureDetector(
                        onTap: () => _showTaskPicker(context, controller),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 18),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.add_task_rounded,
                                  size: 20,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nenhuma tarefa vinculada',
                                      style: textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Toque para escolher uma tarefa',
                                      style: textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right_rounded,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, child) {
                      final title = controller.isFocusMode
                          ? 'Tempo de Foco'
                          : 'Pausa Curta';

                      return Column(
                        children: [
                          Text(
                            title,
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            controller.isFocusMode
                                ? 'Mantenha o ritmo e foque no que importa.'
                                : 'Descanse por um momento antes de continuar.',
                            textAlign: TextAlign.center,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: ListenableBuilder(
                      listenable: controller,
                      builder: (context, child) {
                        final int tempoTotal = controller.isFocusMode
                            ? PomodoroController.focusTime
                            : PomodoroController.breakTime;
                        final double progress =
                            controller.remainingSeconds / tempoTotal;

                        return TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 1.0, end: progress),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                          builder: (context, animatedValue, child) {
                            return Stack(
                              fit: StackFit.expand,
                              children: [
                                CircularProgressIndicator(
                                  value: animatedValue,
                                  strokeWidth: 10.0,
                                  backgroundColor: colorScheme.primary
                                      .withValues(alpha: 0.15),
                                  valueColor: AlwaysStoppedAnimation(
                                    colorScheme.primary,
                                  ),
                                ),
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        controller.formattedTime,
                                        style: textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        controller.isRunning
                                            ? 'Em andamento'
                                            : 'Pausado',
                                        style: textTheme.bodyMedium?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            controller.isRunning
                                ? controller.pauseTimer()
                                : controller.startTimer();
                          },
                          icon: Icon(
                            controller.isRunning
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          label: Text(
                            controller.isRunning ? 'Pausar' : 'Iniciar',
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: controller.resetTimer,
                          icon: const Icon(Icons.restart_alt_rounded),
                          label: const Text('Restart'),
                        ),
                      ),
                    ],
                  ),

                  // === Ações da Tarefa ===
                  ListenableBuilder(
                    listenable: controller,
                    builder: (context, _) {
                      final task = controller.currentTask;
                      if (task == null) return const SizedBox.shrink();

                      return Column(
                        children: [
                          const SizedBox(height: 20),
                          Divider(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 12),
                            child: Text(
                              'Ações da Tarefa',
                              style: textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),

                          // Botão "Marcar como Fazendo"
                          if (task.status == TaskStatus.todo)
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.tonalIcon(
                                onPressed: () async {
                                  HapticFeedback.mediumImpact();
                                  final success = await controller
                                      .updateTaskStatus(TaskStatus.doing);
                                  if (context.mounted) {
                                    _showStatusSnackBar(
                                      context,
                                      success: success,
                                      message: success
                                          ? 'Tarefa movida para "Fazendo" ✨'
                                          : 'Erro ao atualizar status',
                                    );
                                  }
                                },
                                icon: const Icon(Icons.timelapse_rounded),
                                label: const Text('Marcar como Fazendo'),
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),

                          if (task.status == TaskStatus.todo)
                            const SizedBox(height: 10),

                          // Botão "Concluir Tarefa"
                          if (task.status != TaskStatus.done)
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: () async {
                                  HapticFeedback.heavyImpact();
                                  final success = await controller
                                      .updateTaskStatus(TaskStatus.done);
                                  if (context.mounted) {
                                    _showStatusSnackBar(
                                      context,
                                      success: success,
                                      message: success
                                          ? 'Tarefa concluída! 🎉'
                                          : 'Erro ao concluir tarefa',
                                    );
                                  }
                                },
                                icon: const Icon(Icons.check_circle_rounded),
                                label: const Text('Concluir Tarefa'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),

                          // Indicador de tarefa já concluída
                          if (task.status == TaskStatus.done)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    size: 20,
                                    color: Colors.green.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Tarefa concluída',
                                    style: textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget de item individual no seletor de tarefas
class _TaskPickerItem extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onTap;

  const _TaskPickerItem({required this.task, required this.onTap});

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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pColor = _priorityColor(task.priority, colorScheme);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: pColor.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            task.title.isNotEmpty ? task.title[0].toUpperCase() : '?',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: pColor,
            ),
          ),
        ),
      ),
      title: Text(
        task.title,
        style: textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: pColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _priorityLabel(task.priority),
              style: textTheme.labelSmall?.copyWith(
                color: pColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _statusLabel(task.status),
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.play_circle_outline_rounded,
        color: colorScheme.primary,
      ),
    );
  }
}
