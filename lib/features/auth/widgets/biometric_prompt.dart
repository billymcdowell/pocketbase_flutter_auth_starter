// biometric_prompt.dart
import 'package:flutter/material.dart';
import 'package:flutter_auth_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_auth_template/features/auth/services/biometric_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BiometricPrompt extends ConsumerStatefulWidget {
  const BiometricPrompt({super.key});

  @override
  ConsumerState<BiometricPrompt> createState() => _BiometricPromptState();
}

class _BiometricPromptState extends ConsumerState<BiometricPrompt> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  Future<void> _checkBiometric() async {
    setState(() => _isLoading = true);

    // First check if biometric is enabled
    final biometricService = BiometricService();
    final isBiometricEnabled = await biometricService.isBiometricEnabled();

    if (!isBiometricEnabled) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
        return;
      }
    }

    final authNotifier = ref.read(authStateProvider.notifier);
    final success = await authNotifier.attemptBiometricLogin();

    if (!success && mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/'),
                    child: const Text('Continue to home'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    child: const Text('Use Password Instead'),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
