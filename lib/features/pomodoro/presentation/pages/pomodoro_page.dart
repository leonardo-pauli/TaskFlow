import 'package:flutter/material.dart';
import 'package:taskflow/core/di/injection_container.dart';
import 'package:taskflow/features/pomodoro/presentation/controllers/pomodoro_controller.dart';

class PomodoroPage extends StatelessWidget {
  const PomodoroPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = getIt<PomodoroController>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
                        final double progress = controller.remainingSeconds / tempoTotal;

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
                                  backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                                  valueColor: AlwaysStoppedAnimation(colorScheme.primary),
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
                                        controller.isRunning ? 'Em andamento' : 'Pausado',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}