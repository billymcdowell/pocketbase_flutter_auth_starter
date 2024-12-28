// biometric_prompt.dart
import 'package:flutter/material.dart';
import 'package:flutter_auth_template/features/auth/providers/auth_provider.dart';
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

    final authNotifier = ref.read(authStateProvider.notifier);
    final success = await authNotifier.attemptBiometricLogin();

    if (!success && mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Authenticating...'),
      ),
    );
  }
}
