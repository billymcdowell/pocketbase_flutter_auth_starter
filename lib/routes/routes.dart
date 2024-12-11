import 'package:flutter/material.dart';
import 'package:pocketbase_flutter_auth_starter/screens/edit_profile_screen.dart';
import 'package:pocketbase_flutter_auth_starter/screens/home_screen.dart';
import 'package:pocketbase_flutter_auth_starter/screens/main_screen.dart';
import 'package:pocketbase_flutter_auth_starter/src/sample_feature/sample_item_list_view.dart';
import 'package:pocketbase_flutter_auth_starter/src/settings/settings_view.dart';
import 'package:pocketbase_flutter_auth_starter/widgets/auth_guard.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/reset_password_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String resetPassword = '/reset-password';
  static const String editProfile = '/edit-profile';
  static const String main = '/main';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );

      case resetPassword:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordScreen(),
          settings: settings,
        );

      case editProfile:
        return MaterialPageRoute(
          builder: (_) => const EditProfileScreen(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
