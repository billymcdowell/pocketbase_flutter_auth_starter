// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_auth_template/features/auth/providers/auth_provider.dart';
import 'package:flutter_auth_template/features/auth/screens/home_screen.dart';
import 'package:flutter_auth_template/features/auth/screens/login_screen.dart';
import 'package:flutter_auth_template/features/auth/screens/reset_password_screen.dart';
import 'package:flutter_auth_template/features/auth/screens/settings/biometric_settings.dart';
import 'package:flutter_auth_template/features/auth/screens/settings/settings_screen.dart';
import 'package:flutter_auth_template/features/auth/screens/signup_screen.dart';
import 'package:flutter_auth_template/features/auth/services/biometric_service.dart';
import 'package:flutter_auth_template/features/auth/widgets/biometric_prompt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize biometric service
  final biometricService = BiometricService();
  final isAvailable = await biometricService.isBiometricAvailable();
  runApp(
    ProviderScope(
      overrides: [
        // Make the availability status accessible throughout the app
        biometricAvailableProvider.overrideWithValue(isAvailable),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => authState.maybeWhen(
              authenticated: () => const HomeScreen(),
              orElse: () =>
                  const BiometricPrompt(), // Show biometric prompt first
            ),
        '/login': (context) => const LoginScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/settings/biometric': (context) => const BiometricSettings(),
        '/signup': (context) => const SignUpScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
