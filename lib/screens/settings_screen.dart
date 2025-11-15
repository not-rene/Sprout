import 'package:flutter/material.dart';
import 'package:sprout/main.dart';
import 'package:sprout/services/user_storage.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override 
  State <SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificationsEnabled = true;
  double sound = true;
  ThemeMode selectedTheme = ThemeMode.system;
 
 @override
 Widget build (BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text ('settingd'),
    ),
    body: ListView(
      children: [
    
      
      // general category 
      ExpansionTile(
title const Text ('General'),
leading: const Icon (Icons.settings),
children: [
SwitchListTile(
  title: const Text ('Enable Notifications'),
  value: notifications,
  onChanged: (value) {
    setState(() => notifications =value);
  },
),
ListTile(
  title: const Text ('Sound Level'),
  subtitle: Slider(
    value: sound,
    onChanged: (value) {
      setState(() => sound = value);
    },
  ),
  ),
],

// appearance category 
 ExpansionTile(
  title: const Text ('Appearance'), 
  leading: const Icon (Icons.color_lens),
  children: [
    ListTile(
      title: const Text ('Theme'),
      subtitle: DropdownButton<ThemeMode>(
        value: selectedTheme,
        isExpanded: true, 
        items: const [
          DropdownMenuItem(
            value: ThemeMode.system, 
            child: Text ('Automatic'),
          ), 
          DropdownMenuItem(
            value: ThemeMode.light,
            child: Text ('light'),
          ),
          DropdownMenuItem(
            value: ThemeMode.dark,
            child: Text ('dark'),
          ),
        ],
        onChanged: (value) {
          setState(() {
            selectedTheme = value!;

          });
        },
          ),
          ),
        ],
      ),
      // account category
      ExpansionTile(
        title: const Text ('Account'),
        leading: const Icon (Icons.person),
        children:  const [
          ListTile(title: Text('Change Username')),
          ListTile(title: Text('Change Password')),
        ],
      ),
      ],
          );
 }
    }    
    
