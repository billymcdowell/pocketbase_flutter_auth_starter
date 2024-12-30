# Flutter Authentication Template with PocketBase & Biometric Authentication

A production-ready Flutter authentication template that provides a complete authentication flow integrated with PocketBase backend and biometric authentication. This template includes login, registration, password reset functionality, and biometric authentication with proper error handling and state management using Riverpod.

## Features

- 🔐 Complete Authentication Flow
  - Email & Password Sign In
  - User Registration
  - Password Reset
  - Biometric Authentication (Fingerprint/Face ID)
- 🎯 Production-Ready Architecture
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
- 🔒 Secure Storage
  - Encrypted credential storage
  - Biometric data protection
  - Secure token management

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- PocketBase server instance
- iOS device with Face ID or Android device with Fingerprint sensor

## Project Structure

```
lib/
├── main.dart                  # Application entry point
│
├── features/
│   └── auth/
│       ├── services/
│       │   ├── auth_service.dart       # PocketBase integration
│       │   └── biometric_service.dart  # Biometric authentication
│       │
│       ├── providers/
│       │   └── auth_provider.dart      # State management
│       │
│       ├── models/
│       │   └── auth_state.dart         # State definitions
│       │
│       ├── screens/
│       │   ├── login_screen.dart       # Login UI
│       │   ├── signup_screen.dart      # Sign up UI
│       │   ├── reset_password_screen.dart  # Password reset UI
│       │   ├── home_screen.dart        # Home screen
│       │   └── settings/
│       │       └── biometric_settings.dart  # Biometric settings
│       │
│       └── widgets/
│           └── biometric_prompt.dart    # Biometric authentication prompt
```

## Installation

1. Clone this repository:
```bash
git clone https://github.com/billymcdowell/pocketbase_flutter_auth_starter.git
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

## Dependencies

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  pocketbase: ^0.18.0
  freezed_annotation: ^2.4.1
  local_auth: ^2.1.6
  flutter_secure_storage: ^8.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.6
  freezed: ^2.4.5
```

## Platform Configuration

### iOS Configuration
Add to `ios/Runner/Info.plist`:
```xml
<key>NSFaceIDUsageDescription</key>
<string>We use Face ID to securely log you into the app</string>
```

### Android Configuration
Update `android/app/src/main/kotlin/MainActivity.kt`:
```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity
class MainActivity: FlutterFragmentActivity() {
}
```

Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
```

## Usage

### Initialize the App
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final biometricService = BiometricService();
  final isAvailable = await biometricService.isBiometricAvailable();

  runApp(
    ProviderScope(
      overrides: [
        biometricAvailableProvider.overrideWithValue(isAvailable),
      ],
      child: const MyApp(),
    ),
  );
}
```

### Enable Biometric Authentication
```dart
// In settings screen
await ref.read(authStateProvider.notifier).enableBiometric(
  email: credentials['email']!,
  password: credentials['password']!,
);
```

### Biometric Login Flow
The app automatically shows the biometric prompt on startup if enabled:
1. App launch → Biometric check
2. If enabled → Show biometric prompt
3. On success → Auto login
4. On failure → Show regular login screen

## Security Features

- Secure credential storage using FlutterSecureStorage
- Biometric authentication using system-level security
- Token-based authentication with PocketBase
- Automatic session management
- Proper error handling and validation

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
- [local_auth](https://pub.dev/packages/local_auth)
- [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)