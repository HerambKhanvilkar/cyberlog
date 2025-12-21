import 'package:flutter/material.dart';
import 'home_screen.dart';

void main() {
  runApp(const CyberLogApp());
}

class CyberLogApp extends StatelessWidget {
  const CyberLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
