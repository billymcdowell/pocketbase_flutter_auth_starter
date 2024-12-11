import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  static final PocketBaseService _instance = PocketBaseService._internal();
  factory PocketBaseService() => _instance;
  PocketBaseService._internal();

  final pb = PocketBase('https://warn-statement.pockethost.io');
  final storage = const FlutterSecureStorage();

  // Initialize and load stored auth state
  Future<void> initialize() async {
    final authData = await storage.read(key: 'pb_auth');
    if (authData != null) {
      pb.authStore.save(authData, null);
    }

    // Listen to auth state changes
    pb.authStore.onChange.listen((event) {
      if (pb.authStore.isValid) {
        storage.write(key: 'pb_auth', value: pb.authStore.token);
      } else {
        storage.delete(key: 'pb_auth');
      }
    });
  }
}
