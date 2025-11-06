import 'package:flutter/material.dart';

void main() {
  runApp(const SproutApp());
}

class SproutApp extends StatelessWidget {
  // changed: use super parameter
  const SproutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprout',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  // changed: use super parameter
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sprout 🌱'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Sprout!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
