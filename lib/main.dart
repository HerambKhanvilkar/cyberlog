import 'package:flutter/material.dart';

void main() {
  runApp(const SecurityChecklistApp());
}

class SecurityChecklistApp extends StatelessWidget {
  const SecurityChecklistApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Security Checklist',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SecurityChecklistScreen(),
    );
  }
}

class SecurityChecklistScreen extends StatelessWidget {
  const SecurityChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Security Checklist"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ChecklistTile(
            title: "Screen Lock Enabled",
            subtitle: "Your device is protected",
            icon: Icons.lock,
            color: Colors.green,
          ),

          ChecklistTile(
            title: "Camera Permission",
            subtitle: "May pose privacy risk",
            icon: Icons.camera_alt,
            color: Colors.orange,
          ),

          ChecklistTile(
            title: "Storage Permission",
            subtitle: "Files can be accessed by apps",
            icon: Icons.folder,
            color: Colors.orange,
          ),

          ChecklistTile(
            title: "Root / Emulator Warning",
            subtitle: "Unable to verify device integrity",
            icon: Icons.security,
            color: Colors.red,
          ),

          SizedBox(height: 20),

          Card(
            color: Colors.blue,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Security Tips:\n"
                    "• Use a strong screen lock\n"
                    "• Review app permissions\n"
                    "• Avoid installing unknown apps\n"
                    "• Keep your device updated",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChecklistTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const ChecklistTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.check_circle, color: color),
      ),
    );
  }
}
