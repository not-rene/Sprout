import 'package:flutter/material.dart';

class LeadershipHomeScreen extends StatelessWidget {
  const LeadershipHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SizedBox.shrink()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Leadership • Home',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                leading: const Icon(Icons.wb_sunny),
                title: const Text('Daily Challenge'),
                subtitle: const Text('Complete today\'s leadership challenge'),
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.trending_up),
                title: const Text('Progress'),
                subtitle: const Text('View your leadership progress and badges'),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Center(
                child: Text(
                  'Welcome! This is the Leadership + Home screen.\nAdd your custom widgets here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
