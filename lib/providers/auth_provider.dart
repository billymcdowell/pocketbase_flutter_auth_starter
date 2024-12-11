import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import '../services/pocketbase_service.dart';

class AuthProvider with ChangeNotifier {
  final _pb = PocketBaseService();
  bool get isAuthenticated => _pb.pb.authStore.isValid;

  Future<void> signUp({
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      await _pb.pb.collection('users').create(body: {
        'email': email,
        'password': password,
        'passwordConfirm': passwordConfirm,
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _pb.pb.collection('users').authWithPassword(
            email,
            password,
          );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      _pb.pb.authStore.clear(); // Clear PocketBase auth
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to logout: ${e.toString()}');
    }
  }

  Future<void> requestPasswordReset(String email) async {
    try {
      await _pb.pb.collection('users').requestPasswordReset(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<RecordModel> getCurrentUser() async {
    final userId = _pb.pb.authStore.model?.id;
    if (userId == null) {
      throw Exception('No authenticated user');
    }

    try {
      final record = await _pb.pb.collection('users').getOne(userId);
      return record;
    } catch (e) {
      throw Exception('Failed to get user data: ${e.toString()}');
    }
  }

  Future<void> updateUsername(String username) async {
    final userId = _pb.pb.authStore.model?.id;
    if (userId == null) {
      throw Exception('No authenticated user');
    }

    try {
      await _pb.pb.collection('users').update(userId, body: {
        'username': username,
      });
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update username: ${e.toString()}');
    }
  }
}
