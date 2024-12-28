import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../services/biometric_service.dart';
import '../models/auth_state.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final BiometricService _biometricService;

  AuthStateNotifier(this._authService)
      : _biometricService = BiometricService(),
        super(_authService.isAuthenticated
            ? const AuthState.authenticated()
            : const AuthState.unauthenticated());

  Future<void> signOut() async {
    try {
      await _authService.signOut();
      await _biometricService.removeBiometricCredentials();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signIn({required String email, required String password}) async {
    state = const AuthState.loading();
    try {
      await _authService.signIn(email: email, password: password);
      state = const AuthState.authenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    state = const AuthState.loading();
    try {
      await _authService.signUp(
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      await signIn(email: email, password: password);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    state = const AuthState.loading();
    try {
      await _authService.resetPassword(email);
      state = const AuthState.resetEmailSent();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<bool> attemptBiometricLogin() async {
    try {
      final isEnabled = await _biometricService.isBiometricEnabled();
      print('Biometric enabled: $isEnabled'); // Debug log

      if (!isEnabled) {
        return false;
      }

      state = const AuthState.loading();

      final authenticated = await _biometricService.authenticate();
      print('Biometric authenticated: $authenticated'); // Debug log

      if (!authenticated) {
        state = const AuthState.unauthenticated();
        return false;
      }

      final credentials = await _biometricService.getBiometricCredentials();
      print('Got credentials: ${credentials.toString()}'); // Debug log

      if (credentials['email'] == null || credentials['password'] == null) {
        state = const AuthState.unauthenticated();
        return false;
      }

      await _authService.signIn(
        email: credentials['email']!,
        password: credentials['password']!,
      );

      state = const AuthState.authenticated();
      return true;
    } catch (e) {
      print('Biometric error: $e'); // Debug log
      state = AuthState.error(e.toString());
      return false;
    }
  }

  Future<void> enableBiometric({
    required String email,
    required String password,
  }) async {
    try {
      final isAvailable = await _biometricService.isBiometricAvailable();
      if (!isAvailable) {
        throw 'Biometric authentication is not available on this device';
      }

      final authenticated = await _biometricService.authenticate();
      if (!authenticated) {
        throw 'Biometric authentication failed';
      }

      await _biometricService.storeBiometricCredentials(
        email: email,
        password: password,
      );
    } catch (e) {
      throw 'Failed to enable biometric authentication: ${e.toString()}';
    }
  }

  Future<void> disableBiometric() async {
    await _biometricService.removeBiometricCredentials();
  }
}

final biometricAvailableProvider = Provider<bool>((ref) => false);
