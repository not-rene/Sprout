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
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const SizedBox.shrink()),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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

class _AgeInputScreenState extends State<AgeInputScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  late final AnimationController _dropCtrl;
  late final Animation<Offset> _dropAnim;

  @override
  void dispose() {
    _dropCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dropCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _dropAnim = Tween<Offset>(begin: const Offset(0, -0.25), end: Offset.zero)
        .animate(CurvedAnimation(parent: _dropCtrl, curve: Curves.easeOut));
    // Start the drop animation when the screen appears.
    _dropCtrl.forward();
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
      appBar: AppBar(title: const SizedBox.shrink()),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            // Drop-down white box with black border and rounded corners.
            SlideTransition(
              position: _dropAnim,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Age', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'your age',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        errorText: _errorText,
                        prefixIcon: const Icon(Icons.cake, color: Colors.black87),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.black54),
                                onPressed: () => setState(() => _controller.clear()),
                              )
                            : null,
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                      onChanged: (_) {
                        if (_errorText != null) setState(() => _errorText = null);
                        setState(() {}); // update suffixIcon visibility
                      },
                      onSubmitted: (_) => _confirmAgeAndContinue(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // Action buttons: green Confirm (left) and red Cancel (right) with sharp rectangular shapes.
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _confirmAgeAndContinue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text('Confirm', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    // Go back to auth screen if user cancels.
                    Navigator.of(context).pushReplacementNamed('/auth');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text('Cancel', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
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
      appBar: AppBar(title: const SizedBox.shrink()),
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
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SizedBox.shrink(),
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

// OLD (deprecated)
final bg = Colors.green.withOpacity(0.6);

// Option A - use withAlpha (simple and exact)
final bg = Colors.green.withAlpha((0.6 * 255).round());

// Option B - use Color.fromRGBO with explicit opacity
final bg = Color.fromRGBO(76, 175, 80, 0.6); // r,g,b from the color you used
