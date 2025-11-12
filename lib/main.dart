import 'package:flutter/material.dart';
import 'package:sprout/services/user_storage.dart';

// global notifier so any widget can update theme
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved theme (defaults to system if none)
  final saved = await UserStorage.loadThemeMode();
  themeModeNotifier.value = saved ?? ThemeMode.system;

  runApp(const SproutApp());
}

class SproutApp extends StatelessWidget {
  const SproutApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild MaterialApp whenever themeModeNotifier changes
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Sprout',
          // Use ThemeData constructor for primarySwatch (light) and
          // update dark theme's primary color via colorScheme/primaryColor.
          theme: ThemeData(primarySwatch: Colors.green),
          darkTheme: ThemeData.dark().copyWith(
            primaryColor: Colors.green,
            colorScheme: ThemeData.dark().colorScheme.copyWith(primary: Colors.green),
          ),
          themeMode: mode, // uses system until user changes it
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
      backgroundColor: Colors.green,
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
    // Center the whole body and center the column contents.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in or Create account'),
        centerTitle: true, // center the AppBar title
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, // shrink to content
          mainAxisAlignment: MainAxisAlignment.center, // center vertically
          crossAxisAlignment: CrossAxisAlignment.center, // center horizontally
          children: [
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sprout Home'),
        centerTitle: true, // center the AppBar title
        actions: [
          // quick settings menu to change theme; persists choice
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
      body: const Center(
        child: Text(
          'Welcome to Sprout!',
          textAlign: TextAlign.center, // ensure multiline centering
        ),
      ),
    );
  }
}
