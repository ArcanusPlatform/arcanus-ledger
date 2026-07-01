import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recordkeep/database/database.dart';
import 'package:recordkeep/lite/lite_customer_app.dart';
import 'package:recordkeep/utils/startup_integrity_check.dart';
import 'package:recordkeep/utils/storage_paths.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  try {
    await StoragePaths.initialize();
    await StartupIntegrityCheck.verifyStorage();
    await AppDatabase.init();
    await AppDatabase.instance.ensureLiteSyncTables();
    await StartupIntegrityCheck.verifyDatabase(AppDatabase.instance);
    runApp(const ArcanusLedgerLiteApp());
  } catch (error) {
    if (AppDatabase.isInitialized) {
      await AppDatabase.instance.close();
    }
    runApp(LiteStartupFailureApp(message: error.toString()));
  }
}

class LiteStartupFailureApp extends StatelessWidget {
  const LiteStartupFailureApp({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Arcanus Ledger Lite',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  const Text(
                    'Arcanus Ledger Lite Cannot Open',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
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
