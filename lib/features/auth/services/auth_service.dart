// auth_service.dart
import 'package:pocketbase/pocketbase.dart';

class AuthService {
  final PocketBase pb;

  AuthService() : pb = PocketBase('https://warn-statement.pockethost.io/');

  Future<void> signUp({
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      await pb.collection('users').create(body: {
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
        'emailVisibility': true,
      });
    } catch (e) {
      throw _handlePocketBaseError(e);
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await pb.collection('users').authWithPassword(
            email,
            password,
          );
    } catch (e) {
      throw _handlePocketBaseError(e);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await pb.collection('users').requestPasswordReset(email);
    } catch (e) {
      throw _handlePocketBaseError(e);
    }
  }

  Future<void> signOut() async {
    pb.authStore.clear();
  }

  bool get isAuthenticated => pb.authStore.isValid;

  String _handlePocketBaseError(dynamic error) {
    if (error is ClientException) {
      if (error.response.containsKey('data')) {
        final data = error.response['data'] as Map<String, dynamic>;
        if (data.containsKey('email')) {
          return data['email']['message'];
        }
        if (data.containsKey('password')) {
          return data['password']['message'];
        }
      }
      return error.response['message'] ?? 'An unknown error occurred';
    }
    return 'An unexpected error occurred';
  }
}
