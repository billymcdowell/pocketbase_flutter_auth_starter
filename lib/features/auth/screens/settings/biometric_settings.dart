// settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_auth_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_auth_template/features/auth/services/biometric_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BiometricSettings extends ConsumerStatefulWidget {
  const BiometricSettings({super.key});

  @override
  ConsumerState<BiometricSettings> createState() => _BiometricSettingsState();
}

class _BiometricSettingsState extends ConsumerState<BiometricSettings> {
  final BiometricService _biometricService = BiometricService();
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
  }

  Future<void> _checkBiometricStatus() async {
    setState(() => _isLoading = true);

    final isAvailable = await _biometricService.isBiometricAvailable();
    final isEnabled = await _biometricService.isBiometricEnabled();

    setState(() {
      _isBiometricAvailable = isAvailable;
      _isBiometricEnabled = isEnabled;
      _isLoading = false;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    setState(() => _isLoading = true);

    try {
      if (value) {
        // Enable biometric
        await ref.read(authStateProvider.notifier).enableBiometric(
              email: 'current_user_email', // Get from current user
              password: 'current_password', // Get from secure storage
            );
      } else {
        // Disable biometric
        await ref.read(authStateProvider.notifier).disableBiometric();
      }

      setState(() => _isBiometricEnabled = value);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isBiometricAvailable) {
      return const Center(
        child: Text('Biometric authentication is not available on this device'),
      );
    }

    return SwitchListTile(
      title: const Text('Enable Biometric Login'),
      subtitle: const Text('Use fingerprint or face ID to log in'),
      value: _isBiometricEnabled,
      onChanged: _toggleBiometric,
    );
  }
}
