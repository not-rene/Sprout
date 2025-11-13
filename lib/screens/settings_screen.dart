import 'package:flutter/material.dart';
import 'package:sprout/main.dart';
import 'package:sprout/services/user_storage.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SizedBox.shrink()),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Theme',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeModeNotifier,
              builder: (context, mode, _) {
                return Column(
                  children: [
                    _buildThemeOption(
                      label: 'Use system theme',
                      value: ThemeMode.system,
                      groupValue: mode,
                      onChanged: (newMode) async {
                        themeModeNotifier.value = newMode!;
                        await UserStorage.saveThemeMode(newMode);
                      },
                    ),
                    _buildThemeOption(
                      label: 'Light theme',
                      value: ThemeMode.light,
                      groupValue: mode,
                      onChanged: (newMode) async {
                        themeModeNotifier.value = newMode!;
                        await UserStorage.saveThemeMode(newMode);
                      },
                    ),
                    _buildThemeOption(
                      label: 'Dark theme',
                      value: ThemeMode.dark,
                      groupValue: mode,
                      onChanged: (newMode) async {
                        themeModeNotifier.value = newMode!;
                        await UserStorage.saveThemeMode(newMode);
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption({
    required String label,
    required ThemeMode value,
    required ThemeMode groupValue,
    required Function(ThemeMode?) onChanged,
  }) {
    return RadioListTile<ThemeMode>(
      title: Text(label),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
