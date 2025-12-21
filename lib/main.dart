import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  void initState() {
    super.initState();
    loadTheme();
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDark = prefs.getBool('darkMode') ?? false;
    });
  }

  void updateTheme(bool value) {
    setState(() {
      isDark = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: SettingsScreen(
        isDark: isDark,
        onChanged: updateTheme,
      ),
    );
  }
}
