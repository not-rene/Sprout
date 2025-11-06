import 'package:flutter/material.dart';

void main() {
  runApp(SproutApp());
}

class SproutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sprout App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Sprout 🌱'),
      ),
      body: Center(
        child: Text(
          'Hello, world!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
