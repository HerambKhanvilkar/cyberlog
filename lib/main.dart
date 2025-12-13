import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {"title": "Daily Log", "color": Colors.blue},
      {"title": "Cyber Tips", "color": Colors.green},
      {"title": "Device Security", "color": Colors.orange},
      {"title": "Notes", "color": Colors.purple},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("CyberLog Dashboard")),

      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2.5, // 🔥 MUCH smaller height
        padding: const EdgeInsets.all(10),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,

        children: items.map((item) {
          return Container(
            decoration: BoxDecoration(
              color: item["color"],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                item["title"],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
