import 'package:flutter/material.dart';
import 'package:flutter_auth_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAvailable = ref.watch(biometricAvailableProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          if (isAvailable)
            ListTile(
              title: const Text('Biometric Login'),
              onTap: () => Navigator.pushNamed(context, '/settings/biometric'),
            ),
        ],
      ),
    );
  }
}
