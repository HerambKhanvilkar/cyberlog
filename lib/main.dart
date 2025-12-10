import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogsPage(),
    );
  }
}

class Log {
  String action;
  DateTime timestamp;
  String status;

  Log(this.action, this.timestamp, this.status);
}

class LogsPage extends StatelessWidget {
  LogsPage({super.key});

  final List<Log> logs = [
    Log("Login Attempt", DateTime.now(), "Success"),
    Log("Password Change", DateTime.now().subtract(Duration(minutes: 10)), "Success"),
    Log("Invalid OTP", DateTime.now().subtract(Duration(hours: 1)), "Failed"),
    Log("Logout", DateTime.now().subtract(Duration(hours: 2)), "Success"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Activity Logs")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: logs.map((log) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                "${log.action} • ${log.timestamp} • Status: ${log.status}",
                style: TextStyle(fontSize: 16),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
