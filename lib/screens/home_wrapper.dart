import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'profile_screen.dart';
import 'lessons_screen.dart';
import 'settings_screen.dart';

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
      case 'profile':
        return const ProfileScreen();
      case 'lessons':
        return const LessonsScreen();
      case 'settings':
        return const SettingsScreen();
      default:
        return const ProfileScreen();
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
