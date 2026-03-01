# CLAUDE.md — DTDigitalStudio Flutter Base Project

## Project Overview

**Name:** DTDigitalStudio
**Type:** Flutter App (Android + iOS)
**Package:** `dt_digital_studio`
**Version:** 1.0.0+1
**SDK:** Flutter ≥3.3.0, Dart ≥3.3.0

Production-ready Flutter base project for medium and large applications using Clean Architecture.

---

## Architecture

- **Pattern:** Clean Architecture + Feature-First folder structure
- **State Management:** Flutter Riverpod 2.6.1 (code generation with `riverpod_generator`)
- **Navigation:** GoRouter 14.6.3
- **HTTP:** Dio 5.8.0 + Retrofit 4.4.2
- **Storage:** SharedPreferences (app state) + FlutterSecureStorage (tokens) + Hive CE (object caching)
- **Forms:** reactive_forms 18.1.1
- **Localization:** ARB-based i18n via `flutter_localizations` + `intl 0.20.0`
- **Theming:** Material3 + Poppins font (light/dark/system)

---

## Directory Structure

```
lib/
├── core/
│   ├── config/       # AppConstants, FlavorConfig (dev/staging/prod)
│   ├── error/        # Sealed Failure hierarchy + DioException mapper
│   ├── extensions/   # String, int, double, Iterable, Color extensions
│   ├── network/      # Dio client, Retrofit services, interceptors, ApiResult<T>
│   ├── router/       # GoRouter config, route name constants
│   ├── storage/      # AppPreferences, HiveService, SecureStorageService
│   ├── theme/        # Light + dark AppTheme
│   └── utils/        # AppLogger (flavor-aware)
├── features/
│   ├── auth/         # Login screen, AuthNotifier, AuthState
│   ├── home/         # HomeScreen
│   ├── paging_example/  # Infinite scroll example
│   └── splash/       # Auth check + route redirect
├── shared/
│   ├── providers/    # ThemeModeNotifier
│   ├── states/       # BaseState (isLoading, errorMessage)
│   └── widgets/      # AppButton, AppLoading, AppShimmer, ReactiveForm wrappers, PagingIndicators
├── models/           # UserModel
├── l10n/             # ARB files + generated AppLocalizations
├── gen/              # flutter_gen output (assets)
├── app.dart          # Root MaterialApp.router
└── main.dart         # Bootstrap: Hive + SharedPrefs init, ProviderScope
```

---

## Key Patterns & Conventions

### State Pattern
Every feature uses `BaseState` and a `Notifier`:
```dart
class FeatureState extends BaseState {
  const FeatureState({super.isLoading, super.errorMessage, this.data});
  final MyModel? data;
  FeatureState copyWith({...}) => ...;
}

class FeatureNotifier extends Notifier<FeatureState> {
  @override
  FeatureState build() => const FeatureState();
}
```

### API Result Pattern
All API calls return `ApiResult<T>` (sealed: `ApiSuccess<T>` / `ApiFailure`):
```dart
final result = await ref.read(authApiServiceProvider).login(email, password);
switch (result) {
  case ApiSuccess(:final data): ...
  case ApiFailure(:final failure): ...
}
```

### Failure Hierarchy
`NetworkFailure`, `ServerFailure`, `UnauthorizedFailure`, `CacheFailure`, `UnknownFailure`

### Provider Layers
- `*ApiService` (Retrofit raw calls) → `*ApiServiceProvider` (wraps in `ApiResult<T>`) → `*Notifier` (state + business logic)

### Riverpod Code Generation
Use `@riverpod` annotation; run `build_runner` to regenerate `.g.dart` files.

---

## Build & Run Commands

```bash
# Install dependencies
flutter pub get

# Generate code (Riverpod, Retrofit, Hive, assets)
dart run build_runner build --delete-conflicting-outputs

# Generate localization files
flutter gen-l10n

# Run with flavors
flutter run --dart-define=FLAVOR=dev
flutter run --dart-define=FLAVOR=staging
flutter run --dart-define=FLAVOR=prod --release

# Build
flutter build apk --dart-define=FLAVOR=prod --release
flutter build ipa --dart-define=FLAVOR=prod --release

# Analyze & test
flutter analyze
flutter test
```

---

## Flavors / Environments

| Flavor | Android App ID Suffix | iOS Bundle Suffix | API Base URL |
|--------|-----------------------|-------------------|--------------|
| `dev`  | `.dev`               | `.dev`            | Defined in `FlavorConfig` |
| `staging` | *(none)*          | *(none)*          | Defined in `FlavorConfig` |
| `prod` | *(none)*             | *(none)*          | Defined in `FlavorConfig` |

Flavor set at runtime via `--dart-define=FLAVOR=<value>`. Visual banner shown in dev/staging via `FlavorBanner`.

---

## Code Generation Files

The following files are auto-generated — do NOT edit manually:
- `**/*.g.dart` (Riverpod, Retrofit, Hive adapters)
- `**/*.freezed.dart`
- `lib/gen/**` (flutter_gen asset references)
- `lib/l10n/app_localizations*.dart`

Always regenerate after modifying:
- `@riverpod` providers
- `@RestApi()` Retrofit services
- `@HiveType()` models
- ARB localization files
- `pubspec.yaml` assets

---

## Platform Support

- **Android:** Kotlin + Gradle KTS, min SDK from `flutter.minSdkVersion`, dev/prod product flavors
- **iOS:** CocoaPods, xcconfig-based flavors (`dev.xcconfig`, `prod.xcconfig`)
- **Web:** Not configured

---

## Linting

Rules from `analysis_options.yaml`:
- Avoid `print` (use `AppLogger`)
- Always declare return types
- Prefer `const` constructors
- Prefer `final` for local variables and fields
- Unawaited futures flagged
- Generated files excluded from analysis

---

## Adding a New Feature

1. Create `lib/features/<feature_name>/`
2. Add `screen/`, `provider/`, `widget/` sub-directories as needed
3. Define `<Feature>State extends BaseState` and `<Feature>Notifier extends Notifier`
4. Add Retrofit API methods to `core/network/api_service/`
5. Wrap in `ApiResult<T>` in `core/network/api_service_provider/`
6. Register new routes in `core/router/app_router.dart` and `route_names.dart`
7. Run `dart run build_runner build --delete-conflicting-outputs`
