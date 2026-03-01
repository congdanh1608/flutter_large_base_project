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
│   ├── config/
│   │   ├── app_constants.dart        # Timeouts, pagination, storage keys, Hive box names
│   │   ├── app_flavor.dart           # FlavorConfig — dev / prod base URLs & app names
│   │   └── flavor_banner.dart        # Visual dev/prod overlay banner
│   ├── error/
│   │   ├── error_mapper.dart         # DioException → Failure mapping
│   │   └── failures.dart             # Sealed Failure hierarchy (Network, Server, Unauthorized…)
│   ├── extensions/
│   │   └── extensions.dart           # String, int, double, Iterable, Color extensions
│   ├── network/
│   │   ├── api_paths.dart            # API endpoint constants
│   │   ├── api_result.dart           # ApiResult<T> sealed union (ApiSuccess / ApiFailure)
│   │   ├── dio_client.dart           # Singleton Dio factory with interceptors
│   │   ├── api_service/
│   │   │   └── auth_api_service.dart         # Raw Retrofit API calls
│   │   ├── api_service_provider/
│   │   │   └── auth_api_service_provider.dart # Orchestrator — wraps calls in ApiResult<T>
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart         # Bearer token attach + 401 silent refresh
│   │       ├── error_interceptor.dart        # DioException → Failure
│   │       └── logging_interceptor.dart      # Request / response logging
│   ├── router/
│   │   ├── app_router.dart           # GoRouter config, error handler
│   │   └── route_names.dart          # Path + named route constants
│   ├── storage/
│   │   ├── app_preferences.dart      # SharedPreferences (theme mode, onboarded flag)
│   │   ├── hive_service.dart         # Hive CE init + box access
│   │   └── secure_storage_service.dart # FlutterSecureStorage (access / refresh tokens)
│   ├── theme/
│   │   └── app_theme.dart            # Material3 light + dark themes (Poppins)
│   └── utils/
│       └── app_logger.dart           # Flavor-aware logger wrapper
├── features/
│   ├── auth/
│   │   ├── provider/
│   │   │   └── auth_provider.dart    # AuthNotifier (login, logout, getCurrentUser)
│   │   ├── screen/
│   │   │   └── login_screen.dart     # ReactiveForm login UI
│   │   └── widget/                   # Feature-scoped widgets (reserved)
│   ├── home/
│   │   ├── provider/                 # (reserved)
│   │   ├── screen/
│   │   │   └── home_screen.dart      # User profile display
│   │   └── widget/                   # (reserved)
│   ├── paging_example/
│   │   └── paging_example_screen.dart # Infinite scroll pagination example
│   └── splash/
│       └── screen/
│           └── splash_screen.dart    # Auth check + redirect
├── shared/
│   ├── providers/
│   │   └── theme_provider.dart       # ThemeModeNotifier (light / dark / system)
│   ├── states/
│   │   └── base_state.dart           # BaseState — isLoading, errorMessage, hasError
│   └── widgets/
│       ├── app_button.dart           # Primary button with loading state
│       ├── app_loading.dart          # AppLoading + AppShimmer
│       ├── not_found_screen.dart     # 404 screen
│       ├── paging/
│       │   └── paging_indicators.dart # Skeleton, error, no-items states
│       └── reactive_forms/           # Typed ReactiveForm field wrappers
│           ├── custom_reactive_text_field.dart
│           ├── custom_reactive_single_select_dropdown.dart
│           ├── custom_reactive_multiple_select_dropdown.dart
│           ├── custom_reactive_searchable_dropdown.dart
│           ├── custom_reactive_date_picker.dart
│           ├── custom_reactive_radio_tile.dart
│           └── custom_reactive_switch.dart
├── models/
│   └── user_model.dart               # UserModel with fromJson / toJson
├── l10n/
│   ├── app_en.arb                    # English ARB source
│   ├── app_localizations.dart        # (generated)
│   └── app_localizations_en.dart     # (generated)
├── app.dart                          # Root MaterialApp.router
└── main.dart                         # Bootstrap: Hive + SharedPrefs init, ProviderScope
```

### iOS flavor xcconfigs

```
ios/Flutter/
├── Debug.xcconfig          # Standard debug (no flavor)
├── Release.xcconfig        # Standard release (no flavor)
├── Debug-dev.xcconfig      # Debug + dev flavor
├── Release-dev.xcconfig    # Release + dev flavor
├── Debug-prod.xcconfig     # Debug + prod flavor
├── Release-prod.xcconfig   # Release + prod flavor
├── dev.xcconfig            # Dev flavor overrides (bundle ID, display name)
├── prod.xcconfig           # Prod flavor overrides (bundle ID, display name)
└── Generated.xcconfig      # Auto-generated by Flutter — do not edit
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

Follow the pattern used by **`auth`**:

```
lib/features/my_feature/
├── provider/
│   └── my_feature_provider.dart   # State class + Riverpod Notifier
├── screen/
│   └── my_feature_screen.dart
└── widget/                        # Feature-scoped widgets
```

**State + Notifier template:**
```dart
class MyFeatureState extends BaseState {
  const MyFeatureState({super.isLoading, super.errorMessage, this.data});
  final MyModel? data;

  MyFeatureState copyWith({...}) => MyFeatureState(...);
}

class MyFeatureNotifier extends Notifier<MyFeatureState> {
  @override
  MyFeatureState build() => const MyFeatureState();
}

final myFeatureProvider =
    NotifierProvider<MyFeatureNotifier, MyFeatureState>(MyFeatureNotifier.new);
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
