import 'package:flutter/material.dart';
import 'package:sprout/main.dart'; // import themeModeNotifier
import 'package:sprout/services/user_storage.dart'; // import UserStorage
import 'sidebar.dart';
import 'profile_screen.dart';
import 'lessons_screen.dart';
import 'settings_screen.dart';
import 'leadership_home_screen.dart';
import 'leaderboard_screen.dart';
import 'dart:developer' as logger;

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  String _currentScreen = 'profile';

  void _navigateTo(String screenName) {
    setState(() {
      _currentScreen = screenName;
    });
  }

  Widget _getScreenWidget() {
    switch (_currentScreen) {
      case 'home':
        return const LeadershipHomeScreen();
      case 'leaderboard':
        return const LeaderboardScreen();
      case 'profile':
        return const ProfileScreen();
      case 'lessons':
        return const LessonsScreen();
      case 'settings':
        return const SettingsScreen();
      default:
        return const LeadershipHomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(
        currentScreen: _currentScreen,
        onNavigate: _navigateTo,
      ),
      appBar: AppBar(title: const SizedBox.shrink()),
      body: _getScreenWidget(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
        centerTitle: true,
        actions: [
          PopupMenuButton<ThemeMode>(
            onSelected: (mode) async {
              themeModeNotifier.value = mode;
              await UserStorage.saveThemeMode(mode);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: ThemeMode.system, child: Text('Use system theme')),
              PopupMenuItem(value: ThemeMode.light, child: Text('Light theme')),
              PopupMenuItem(value: ThemeMode.dark, child: Text('Dark theme')),
            ],
            icon: const Icon(Icons.color_lens),
          ),
        ],
      ),
      body: const Center(child: Text('Welcome to Sprout!')),
    );
  }
}
