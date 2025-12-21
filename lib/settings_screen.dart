import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDark;
  final Function(bool) onChanged;

  const SettingsScreen({
    super.key,
    required this.isDark,
    required this.onChanged,
  });

  Future<void> saveTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: SwitchListTile(
        title: const Text("Dark Mode"),
        value: isDark,
        onChanged: (value) {
          saveTheme(value);
          onChanged(value);
        },
      ),
    );
  }
}
