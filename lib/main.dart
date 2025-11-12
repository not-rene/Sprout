import 'package:flutter/material.dart';
import 'package:sprout/services/user_storage.dart'; // add this import

void main() {
  // Entry point: run the app by instantiating (creating a new instance) 
  // top level widget (main app class :p)
  runApp(const SproutApp());
}

class SproutApp extends StatelessWidget {
  // Root app widget (first thing flutter runs, also that widget 
  //"SproutApp") Uses a const constructor (marks as unchanging 4 optimization) and provides routing.
  // WHICH means lets lets you define and jump between named pages easy peasy
  const SproutApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp (Starter kit type thing. Handles colors, typography, icons, button styles, app bars, cards, blah blah)
    // supplies Material theming, navigation (lets you move between pages easily), and route table (kinda like a menu of screens
    //that your app knows about)
    return MaterialApp(
      title: 'Sprout',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        // Routes (map of pages, each name points to a function that creates/builds the screen you wanna show)
        // map names to builder functions (returns the widget to that screen)
        // returning the target screen. All routes are stored together in MaterialApp like a dictionary. 
        '/': (_) => const SplashScreen(),
        '/auth': (_) => const AuthScreen(),
        '/age': (_) => const AgeInputScreen(), // NEW: Age input before customization
        '/home': (_) => const HomeScreen(),
        '/customize': (_) => const CharacterCustomizationScreen(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  // Splash screen shown when the app launches.
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  // Animation controller for the splash animation.
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  // Curved animation to give an ease-out-back effect to the scale.
  late final Animation<double> _scale = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);

  @override
  void initState() {
    super.initState();
    // Start the scale animation immediately.
    _ctrl.forward();

    // Simulate a short loading period, then navigate to the auth screen.
    // Check `mounted` before using context to avoid using a BuildContext after the widget is disposed.
    Future.delayed(const Duration(seconds: 2)).then((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/auth');
    });
  }

  @override
  void dispose() {
    // Dispose the animation controller to free resources.
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Build the splash UI: a centered, scaling FlutterLogo.
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _scale,
          child: const FlutterLogo(size: 140),
        ),
      ),
    );
  }
}

class AuthScreen extends StatelessWidget {
  // Authentication screen offering sign in or create account actions.
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Minimal mock auth UI. Replace with real auth logic later.
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in or Create account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Put an image between the AppBar/title and the buttons.
            // By default this uses a network image so you don't need to add
            // an asset file. If you prefer a bundled asset, see the
            // instructions below (pubspec.yaml) and replace Image.network
            // with Image.asset('assets/images/welcome.png').
            SizedBox(
              width: double.infinity,
              child: Image.asset(
                'assets/images/slack.png',
                height: 180,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {
                // Mock sign in -> direct to home. Replace with real sign-in flow.
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: const Text('Sign in (mock)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // New account -> now go to the age input screen first
                Navigator.of(context).pushReplacementNamed('/age');
              },
              child: const Text('Create new account'),
            ),
          ],
        ),
      ),
    );
  }
}

// NEW: Screen to collect user's age before customization.
class AgeInputScreen extends StatefulWidget {
  const AgeInputScreen({super.key});

  @override
  State<AgeInputScreen> createState() => _AgeInputScreenState();
}

class _AgeInputScreenState extends State<AgeInputScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Validate the input is a positive integer and return parsed value or null.
  int? _parseAge(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;
    final value = int.tryParse(trimmed);
    if (value == null || value <= 0 || value > 120) return null;
    return value;
  }

  // Show confirmation dialog with Yes/No. If Yes -> proceed to customization.
  Future<void> _confirmAgeAndContinue() async {
    final age = _parseAge(_controller.text);
    if (age == null) {
      setState(() => _errorText = 'Please enter a valid age (1-120).');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm age'),
        content: Text('I am $age years old. Correct?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Yes')),
        ],
      ),
    );

    if (confirmed == true) {
      // Save age locally, then navigate.
      await UserStorage.saveAge(age);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/customize');
    } else {
      // If not confirmed, keep the user on the page so they can fix the input.
      // Optionally clear or focus the field:
      // _controller.clear();
      setState(() => _errorText = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simple UI: prompt, text field and a confirm button.
    return Scaffold(
      appBar: AppBar(title: const Text('I am...')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your age so we can personalize the experience.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'I am...',
                hintText: 'e.g. 12',
                errorText: _errorText,
              ),
              onChanged: (_) {
                if (_errorText != null) setState(() => _errorText = null);
              },
              onSubmitted: (_) => _confirmAgeAndContinue(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _confirmAgeAndContinue,
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

class CharacterCustomizationScreen extends StatefulWidget {
  // Screen for first-time users to customize their avatar/character.
  const CharacterCustomizationScreen({super.key});
  @override
  State<CharacterCustomizationScreen> createState() => _CharacterCustomizationScreenState();
}

class _CharacterCustomizationScreenState extends State<CharacterCustomizationScreen> {
  // Simple customization state: selected hair variant and color.
  int hairIndex = 0;
  Color color = Colors.green;

  void _saveAndContinue() async {
    // persist locally
    await UserStorage.saveCustomization(hairIndex: hairIndex, color: color);

    // Ensure widget still mounted before using context (avoids use_build_context_synchronously)
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    // Build a simple customization UI with preview, hair choices and color swatches.
    return Scaffold(
      appBar: AppBar(title: const Text('Customize your character')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar preview: shows chosen color and a text marker for hair variant.
            CircleAvatar(
              radius: 48,
              backgroundColor: color,
              child: Text('H$hairIndex', style: const TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            // Hair selection: ChoiceChips allow selecting one hair variant.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text('Hair ${i+1}'),
                    selected: hairIndex == i,
                    onSelected: (_) => setState(() => hairIndex = i),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            // Color selection: small circular swatches to pick a color.
            Wrap(
              spacing: 8,
              children: [Colors.green, Colors.blue, Colors.purple, Colors.orange].map((c) {
                return GestureDetector(
                  onTap: () => setState(() => color = c),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: c,
                      shape: BoxShape.circle,
                      // Outline the currently selected color.
                      border: Border.all(color: color == c ? Colors.black : Colors.transparent, width: 2),
                    ),
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            // Save button: persist choices and continue to home.
            ElevatedButton(
              onPressed: _saveAndContinue,
              child: const Text('Save and Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  // Main app home screen after authentication/customization.
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    // Simple placeholder home UI. Expand with your app features.
    return Scaffold(
      appBar: AppBar(title: const Text('Sprout Home')),
      body: const Center(child: Text('Welcome to Sprout!')),
    );
  }
}
```
