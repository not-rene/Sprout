import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Placeholder user data; replace with real model/data source
  final String _username = 'Jane Doe';
  final String _profileImage = 'https://picsum.photos/600';
  final List<String> _badges = ['Starter', 'Growth', 'Mentor'];
  final Map<String, String> _stats = {
    'Most seeds at once': '1,250',
    'Lessons completed': '42',
    'Friends': '18',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SizedBox.shrink()),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with background profile picture
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 240,
                  child: Image.network(
                    _profileImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: Icon(Icons.person, size: 72, color: Colors.white)),
                    ),
                  ),
                ),
                // Circular profile image overlay
                Positioned(
                  bottom: -36,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 44,
                      backgroundImage: NetworkImage(_profileImage),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48), // space for the overlapping avatar

            // Username
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _username,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Action buttons (message, add friend, placeholder)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: wire messaging
                      },
                      icon: const Icon(Icons.message),
                      label: const Text('Message'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: wire add friend
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('Add Friend'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: decide third action (e.g., Follow, Challenge, Invite)
                      },
                      icon: const Icon(Icons.more_horiz),
                      label: const Text('More'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Badges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 84,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _badges.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final badge = _badges[index];
                        return Column(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.green[100],
                              child: Text(badge[0], style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(height: 6),
                            Text(badge),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Stats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: _stats.entries.map((e) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(e.key),
                                Text(e.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
