import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recordkeep/screens/login_screen.dart';
import 'package:recordkeep/database/database.dart';
import 'package:recordkeep/utils/storage_paths.dart';
import 'package:recordkeep/utils/startup_integrity_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Immersive fullscreen — hides nav bar and status bar on Android TV/phone.
  // This prevents the OS from reserving safe-area space that boxes the app.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Allow all orientations including landscape on TV/monitor
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  try {
    await StoragePaths.initialize();
    await StartupIntegrityCheck.verifyStorage();
    await AppDatabase.init();
    await StartupIntegrityCheck.verifyDatabase(AppDatabase.instance);
    runApp(const MyApp());
  } catch (error) {
    if (AppDatabase.isInitialized) {
      await AppDatabase.instance.close();
    }
    runApp(StartupFailureApp(message: error.toString()));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcanus Ledger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class StartupFailureApp extends StatelessWidget {
  const StartupFailureApp({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcanus Ledger',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 56),
                  const SizedBox(height: 20),
                  const Text(
                    'Arcanus Ledger Cannot Open',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Portable storage failed the startup integrity check.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SelectableText(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
