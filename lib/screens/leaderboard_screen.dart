import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder leaderboard list
    final entries = List.generate(10, (i) => {'name': 'User ${i + 1}', 'score': (100 - i * 5)});

    return Scaffold(
      appBar: AppBar(title: const SizedBox.shrink()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Leaderboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: entries.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final e = entries[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(e['name'] as String),
                    trailing: Text('${e['score']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
