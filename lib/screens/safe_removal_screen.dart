import 'package:flutter/material.dart';

import '../utils/app_exit.dart';

class SafeRemovalScreen extends StatelessWidget {
  const SafeRemovalScreen({
    super.key,
    required this.dataPath,
  });

  final String dataPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.usb_off,
                  size: 64,
                  color: Colors.green,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Vault Prepared for Removal',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Database writes are checkpointed, file writes are flushed, '
                  'and app database handles are closed. Use your operating '
                  'system eject command before unplugging the USB drive.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SelectableText(
                  dataPath,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () async {
                    await AppExit.closeApp();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text('Close App'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
