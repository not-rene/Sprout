import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final String currentScreen;
  final Function(String) onNavigate;

  const SideBar({
    super.key,
    required this.currentScreen,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green[700],
            ),
            child: const Text(
              'Sprout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          _buildNavItem(
            icon: Icons.person,
            label: 'Profile',
            routeName: 'profile',
            onTap: () {
              onNavigate('profile');
              Navigator.pop(context); // Close sidebar after navigation
            },
          ),
          _buildNavItem(
            icon: Icons.school,
            label: 'Lessons',
            routeName: 'lessons',
            onTap: () {
              onNavigate('lessons');
              Navigator.pop(context);
            },
          ),
          _buildNavItem(
            icon: Icons.settings,
            label: 'Settings',
            routeName: 'settings',
            onTap: () {
              onNavigate('settings');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required String routeName,
    required VoidCallback onTap,
  }) {
    final isActive = currentScreen == routeName;
    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? Colors.green : Colors.grey,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.green : Colors.black,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}
