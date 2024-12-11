import 'package:flutter/material.dart';
import 'package:pocketbase_flutter_auth_starter/providers/auth_provider.dart';
import 'package:pocketbase_flutter_auth_starter/screens/login_screen.dart';
import 'package:provider/provider.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        if (!auth.isAuthenticated) {
          return Navigator(
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => const LoginScreen(),
              settings: settings,
            ),
          );
        }
        return child;
      },
    );
  }
}
