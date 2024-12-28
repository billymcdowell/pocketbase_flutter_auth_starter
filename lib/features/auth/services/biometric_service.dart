// biometric_service.dart
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class BiometricService {
  final LocalAuthentication _localAuth;
  final FlutterSecureStorage _secureStorage;

  BiometricService()
      : _localAuth = LocalAuthentication(),
        _secureStorage = const FlutterSecureStorage();

  Future<bool> isBiometricAvailable() async {
    try {
      // Check if biometrics is supported
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _localAuth.isDeviceSupported();

      return canAuthenticate;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // Store credentials for biometric login
  Future<void> storeBiometricCredentials({
    required String email,
    required String password,
  }) async {
    await _secureStorage.write(key: 'biometric_email', value: email);
    await _secureStorage.write(key: 'biometric_password', value: password);
    await _secureStorage.write(key: 'biometric_enabled', value: 'true');
  }

  Future<void> removeBiometricCredentials() async {
    await _secureStorage.delete(key: 'biometric_email');
    await _secureStorage.delete(key: 'biometric_password');
    await _secureStorage.delete(key: 'biometric_enabled');
  }

  Future<bool> isBiometricEnabled() async {
    final enabled = await _secureStorage.read(key: 'biometric_enabled');
    return enabled == 'true';
  }

  Future<Map<String, String?>> getBiometricCredentials() async {
    final email = await _secureStorage.read(key: 'biometric_email');
    final password = await _secureStorage.read(key: 'biometric_password');

    return {
      'email': email,
      'password': password,
    };
  }
}
