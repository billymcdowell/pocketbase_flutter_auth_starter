# Flutter Authentication Template with PocketBase

A production-ready Flutter authentication template that provides a complete authentication flow integrated with PocketBase backend. This template includes login, registration, password reset functionality with proper error handling and state management using Riverpod.

## Features

- 🔐 Complete authentication flow
  - Email & Password Sign In
  - User Registration
  - Password Reset
- 🎯 Production-ready architecture
  - Clean Architecture principles
  - Feature-based folder structure
  - Separation of concerns
- 📱 Polished UI
  - Material Design 3
  - Loading states
  - Error handling
  - Form validation
- 🔄 State Management
  - Riverpod for state management
  - Type-safe state handling with Freezed
- 🔌 PocketBase Integration
  - Complete PocketBase auth implementation
  - Error handling
  - Session management

## Prerequisites

- Flutter SDK (2.0.0 or higher)
- Dart SDK (2.12.0 or higher)
- PocketBase server instance

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/flutter-auth-template.git
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure PocketBase:
   - Open `lib/features/auth/services/auth_service.dart`
   - Replace `YOUR_POCKETBASE_URL` with your PocketBase server URL

4. Generate Freezed models:
```bash
flutter pub run build_runner build
```

## Project Structure

```
lib/
├── main.dart                  # Application entry point
│
├── features/
│   └── auth/
│       ├── services/
│       │   └── auth_service.dart    # PocketBase integration
│       │
│       ├── providers/
│       │   └── auth_provider.dart   # State management
│       │
│       ├── models/
│       │   └── auth_state.dart      # State definitions
│       │
│       └── screens/
│           ├── login_screen.dart    # Login UI
│           ├── signup_screen.dart   # Sign up UI
│           ├── reset_password_screen.dart  # Password reset UI
│           └── home_screen.dart     # Home screen
```

## Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  pocketbase: ^0.18.0
  freezed_annotation: ^2.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.6
  freezed: ^2.4.5
```

## Usage

### Initialize the App

The template comes with a pre-configured `main.dart`:

```dart
void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### Authentication State

The authentication state is managed through Riverpod and can be accessed anywhere in the app:

```dart
final authState = ref.watch(authStateProvider);

authState.maybeWhen(
  authenticated: () {
    // Handle authenticated state
  },
  error: (message) {
    // Handle error state
  },
  orElse: () {
    // Handle other states
  },
);
```

### Protected Routes

Routes are automatically protected based on authentication state:

```dart
MaterialApp(
  // ...
  initialRoute: '/',
  routes: {
    '/': (context) => authState.maybeWhen(
          authenticated: () => const HomeScreen(),
          orElse: () => const LoginScreen(),
        ),
    // ...
  },
);
```

## Customization

### Styling

The template uses Material Design 3 by default. You can customize the theme in `main.dart`:

```dart
MaterialApp(
  theme: ThemeData(
    primarySwatch: Colors.blue,
    useMaterial3: true,
    // Add your custom theme data
  ),
  // ...
);
```

### Error Messages

Customize error messages in `auth_service.dart`:

```dart
String _handlePocketBaseError(dynamic error) {
  // Add your custom error handling logic
}
```

## Security Considerations

- User passwords are never stored in the app
- Authentication tokens are managed by PocketBase
- Form inputs are validated before submission
- Error messages don't reveal sensitive information

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Flutter](https://flutter.dev)
- [PocketBase](https://pocketbase.io)
- [Riverpod](https://riverpod.dev)
- [Freezed](https://pub.dev/packages/freezed)