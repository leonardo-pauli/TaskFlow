import 'package:flutter/material.dart';
import 'package:taskflow/core/di/injection_container.dart';
import 'package:taskflow/core/theme/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = getIt<ThemeController>();
    return Scaffold(
      appBar: AppBar(title: Text('Configuracoes')),
      body: ListenableBuilder(
        listenable: themeController,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Text(
                  'Tema:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SegmentedButton<ThemeMode>(
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10.0,
                        ),
                      ),
                    ),
                  ),
                  selected: {themeController.themeMode},
                  onSelectionChanged: (Set<ThemeMode> newSelection) {
                    themeController.changeThemeMode(newSelection.first);
                  },

                  segments: const [
                    ButtonSegment(
                      value: ThemeMode.system,
                      label: Text('Sistema'),
                      icon: Icon(Icons.brightness_auto),
                    ),
                    ButtonSegment(
                      value: ThemeMode.light,
                      label: Text('Claro'),
                      icon: Icon(Icons.light_mode),
                    ),
                    ButtonSegment(
                      value: ThemeMode.dark,
                      label: Text('Escuro'),
                      icon: Icon(Icons.dark_mode),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
