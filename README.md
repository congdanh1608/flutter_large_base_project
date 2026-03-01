# DTDigitalStudio — Flutter Large Base Project

A production-ready Flutter boilerplate for **medium and large** applications, targeting **Android & iOS** with Clean Architecture and a feature-first folder structure.

---

## 🛠 Tech Stack

| Category | Package |
|---|---|
| State Management | `flutter_riverpod` + `riverpod_annotation` |
| Navigation | `go_router` |
| HTTP Client | `dio` + `retrofit` |
| Local Storage | `shared_preferences` + `flutter_secure_storage` + `hive_ce` |
| Localization | `flutter_localizations` + `intl` |
| Image Caching | `cached_network_image` |
| Logging | `logger` |
| Connectivity | `connectivity_plus` |
| Permissions | `permission_handler` |

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── config/       # AppFlavor, AppConstants
│   ├── error/        # Failure sealed class, ErrorMapper
│   ├── extensions/   # String, int, Iterable, Color extensions
│   ├── l10n/         # (generated) Localization helper
│   ├── network/      # DioClient, interceptors, ApiResult<T>
│   ├── router/       # AppRouter (GoRouter), RouteNames
│   ├── storage/      # AppPreferences, SecureStorageService, HiveService
│   ├── theme/        # AppTheme (light + dark, Material3)
│   └── utils/        # AppLogger
├── features/
│   └── [feature_name]/
│       ├── data/         # Models (manual JSON), datasources, repo impls
│       ├── domain/       # Entities, repo interfaces, use cases
│       └── presentation/ # Riverpod providers, screens, widgets
├── shared/
│   ├── providers/    # ThemeModeProvider
│   └── widgets/      # AppButton, AppTextField, AppLoading, Splash, 404
├── l10n/             # ARB translation files
├── app.dart          # Root MaterialApp.router
└── main.dart         # Bootstrap: Hive + SharedPrefs init, ProviderScope
```

---

## 🏃 Running the App

### Prerequisites
- Flutter ≥ 3.22.0
- Dart ≥ 3.4.0

### Install dependencies
```bash
flutter pub get
```

### Generate localization files
```bash
flutter gen-l10n
```

### Run in VS Code
Select a configuration from the Debug panel:
- **▶ DEV** — uses `https://dev-api.dtdigitalstudio.com`
- **▶ STAGING** — uses `https://staging-api.dtdigitalstudio.com`
- **▶ PROD** — uses `https://api.dtdigitalstudio.com` (release mode)

### Run from CLI
```bash
# Development
flutter run --dart-define=FLAVOR=dev

# Staging
flutter run --dart-define=FLAVOR=staging

# Production (release build)
flutter build apk --dart-define=FLAVOR=prod --release
flutter build ipa --dart-define=FLAVOR=prod --release
```

---

## 🏗 Adding a New Feature

Follow the Clean Architecture pattern used by **`auth`**:

```
lib/features/my_feature/
├── data/
│   ├── datasources/my_feature_remote_datasource.dart  # Dio calls
│   ├── models/my_feature_model.dart                   # fromJson / toJson
│   └── repositories/my_feature_repository_impl.dart  # wraps in ApiResult<T>
├── domain/
│   ├── entities/my_feature_entity.dart
│   ├── repositories/my_feature_repository.dart        # abstract interface
│   └── usecases/my_use_case.dart
└── presentation/
    ├── providers/my_feature_provider.dart              # Riverpod AsyncNotifier
    ├── screens/my_feature_screen.dart
    └── widgets/
```

**Wire the provider:**
```dart
final myFeatureRepoProvider = Provider<MyFeatureRepository>(
  (_) => MyFeatureRepositoryImpl(),
);
```

---

## 🌍 Adding Translations

1. Add keys to `lib/l10n/app_en.arb`
2. Run `flutter gen-l10n`
3. Use in widgets: `AppLocalizations.of(context).yourKey`

---

## 🎨 Theming

Toggle dark/light mode anywhere:
```dart
ref.read(themeModeProvider.notifier).setTheme(ThemeMode.dark);
```

---

## 🔒 Auth Flow

```
SplashScreen
    └── checks auth state → GoRouter redirect
           ├── not logged in → /login
           └── logged in    → /home
```

Tokens are stored in `flutter_secure_storage` and automatically attached by `AuthInterceptor`. On 401, the interceptor refreshes tokens and retries the request once.

---

## ✅ Code Quality

```bash
# Static analysis (must pass clean)
flutter analyze

# Tests
flutter test
```
