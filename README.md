# 🧩 GetX Template

> A production-ready Flutter boilerplate built on the **GetX Architectural Pattern** — originally inspired by [Kaue Murakami](https://github.com/kauemurakami). Designed to be cloned and extended as the foundation for any market-standard Flutter application.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Why This Template?](#why-this-template)
- [Architecture](#architecture)
- [State Management](#state-management)
- [Navigation & Routing](#navigation--routing)
- [Dependency Injection](#dependency-injection)
- [Project Structure](#project-structure)
- [Key Dependencies](#key-dependencies)
- [Getting Started](#getting-started)
- [How to Add a New Module](#how-to-add-a-new-module)
- [Supported Platforms](#supported-platforms)

---

## Overview

**GetX Template** (package: `getx_templete`) is a Flutter starter template that enforces a clean, scalable, and consistent project structure using the **GetX** ecosystem. It bundles everything a real-world app needs from day one — networking, secure storage, internationalisation, image caching, barcode scanning, and theming — so you can focus immediately on building features instead of configuring boilerplate.

The repo description credits **Kaue Murakami's** GetX architectural pattern, a widely adopted convention in the Flutter community for feature-first, modular GetX projects.

---

## Why This Template?

| Problem | Solution in This Template |
|---|---|
| New projects waste time on setup | All essential packages pre-configured |
| Inconsistent folder structure | Enforced feature-first module layout |
| Mixed concerns (UI + logic) | Strict MVC separation via GetX |
| No DI strategy | GetX Bindings per module |
| Navigation boilerplate | Centralised named-route system |
| State scattered everywhere | Reactive `.obs` and `GetxService` singletons |

---

## Architecture

This template follows the **GetX Feature-First MVC** architecture. Code is organised by **feature/module**, not by technical layer. Each module is self-contained and owns its own controller, binding, model, repository, and view.

```
┌─────────────────────────────────────────────┐
│                   main.dart                 │
│  ┌──────────────┐   ┌─────────────────────┐ │
│  │  GetMaterial │   │  Initial Services   │ │
│  │     App      │   │  (GetxService init) │ │
│  └──────────────┘   └─────────────────────┘ │
└─────────────────────────────────────────────┘
            │
            ▼
┌─────────────────────────────────────────────┐
│              Routes (AppPages)              │
│  Maps route names → page + binding pairs    │
└─────────────────────────────────────────────┘
            │
            ▼
┌────────────────────── Module ───────────────┐
│                                             │
│  Binding ──► Controller ──► Repository      │
│                   │                         │
│                View (UI)                    │
│                   │                         │
│               Model (Data)                  │
└─────────────────────────────────────────────┘
```

### The Five Layers of a Module

| Layer | File | Responsibility |
|---|---|---|
| **Binding** | `*_binding.dart` | Lazily registers the controller via `Get.lazyPut` |
| **Controller** | `*_controller.dart` | Business logic, state, API calls |
| **Repository** | `*_repository.dart` | Raw data access (Dio HTTP calls, local DB) |
| **Model** | `*_model.dart` | Data classes with `fromJson` / `toJson` |
| **View** | `*_view.dart` | Stateless UI widgets, reads from controller |

---

## State Management

GetX offers three state management strategies. This template uses all three where appropriate.

---

### 1. Reactive State — `Rx` / `.obs` + `Obx`

The primary approach. Declare state as observable variables in the controller. Wrap only the widgets that need updating inside `Obx(() => ...)`. Only those widgets rebuild — no `setState`, no `BuildContext` needed.

```dart
// feature/home/controllers/home_controller.dart
class HomeController extends GetxController {
  final items = <ItemModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    try {
      items.value = await _repository.getItems();
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
```

```dart
// feature/home/views/home_view.dart
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) return const CircularProgressIndicator();
        if (controller.errorMessage.isNotEmpty) return Text(controller.errorMessage.value);
        return ListView(children: controller.items.map((i) => ItemCard(item: i)).toList());
      }),
    );
  }
}
```

---

### 2. Simple State — `GetBuilder` + `update()`

For non-reactive scenarios where explicit, manual UI refresh is more appropriate (e.g., toggling a UI mode, updating a form field).

```dart
// In controller
String selectedFilter = 'All';

void setFilter(String filter) {
  selectedFilter = filter;
  update(); // manually triggers GetBuilder rebuild
}
```

```dart
// In view
GetBuilder<HomeController>(
  builder: (ctrl) => FilterChip(label: Text(ctrl.selectedFilter)),
)
```

---

### 3. GetxService — Global Singletons

Long-lived app-wide services (auth session, connectivity, storage wrappers) are implemented as `GetxService`. They are initialised once at startup via `Get.putAsync` and persist for the app's lifetime. They are never removed from memory by GetX's garbage collector.

```dart
// core/services/auth_service.dart
class AuthService extends GetxService {
  final _storage = Get.find<StorageService>();
  final isLoggedIn = false.obs;

  Future<AuthService> init() async {
    final token = await _storage.getToken();
    isLoggedIn.value = token != null;
    return this;
  }

  Future<void> logout() async {
    await _storage.clearToken();
    isLoggedIn.value = false;
    Get.offAllNamed(Routes.login);
  }
}
```

```dart
// main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => StorageService().init());
  await Get.putAsync(() => AuthService().init());
  runApp(const MyApp());
}
```

---

## Navigation & Routing

All navigation is handled by **GetX Named Routes**. Routes are centralised in two files:

```dart
// routes/app_routes.dart
abstract class Routes {
  static const splash    = '/splash';
  static const home      = '/home';
  static const settings  = '/settings';
}
```

```dart
// routes/app_pages.dart
class AppPages {
  static final pages = [
    GetPage(name: Routes.splash,   page: () => const SplashView(),   binding: SplashBinding()),
    GetPage(name: Routes.home,     page: () => const HomeView(),     binding: HomeBinding()),
    GetPage(name: Routes.settings, page: () => const SettingsView(), binding: SettingsBinding()),
  ];
}
```

### Navigation API

```dart
// Navigate forward
Get.toNamed(Routes.home);

// Navigate with arguments
Get.toNamed(Routes.detail, arguments: {'id': product.id});

// Access arguments in the destination
final id = Get.arguments['id'];

// Navigate and clear back stack
Get.offAllNamed(Routes.login);

// Go back
Get.back();
```

---

## Dependency Injection

GetX's built-in DI removes the need for any external provider or locator package.

### Bindings (Per Module)

Each `GetPage` is paired with a `Binding` class. The binding is called **before** the page renders, ensuring the controller is ready exactly when the view needs it.

```dart
// feature/home/bindings/home_binding.dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeRepository>(() => HomeRepository());
    Get.lazyPut<HomeController>(() => HomeController(
      repository: Get.find(),
    ));
  }
}
```

### DI Registration Methods

| Method | When to Use |
|---|---|
| `Get.lazyPut(() => X())` | Module-scoped; created on first `Get.find()`, removed when page closes |
| `Get.put(X())` | Eager; created immediately and kept alive |
| `Get.putAsync(() async => X())` | Async services that need `await` before being available |
| `Get.find<X>()` | Retrieve an already-registered instance anywhere |
| `Get.delete<X>()` | Manually remove from memory |

---

## Project Structure

```
getx_templete/
├── android/
├── ios/
├── linux/
├── macos/
├── web/
├── windows/
│
├── assets/
│   ├── logo/              ← App logos / brand assets
│   └── images/            ← Static images
│
├── lib/
│   ├── main.dart          ← Entry point; service init + GetMaterialApp
│   │
│   ├── core/              ← App-wide, feature-agnostic code
│   │   ├── network/
│   │   │   ├── api_client.dart       ← Dio instance + interceptors
│   │   │   └── api_endpoints.dart    ← Base URL + endpoint constants
│   │   ├── services/
│   │   │   ├── storage_service.dart  ← flutter_secure_storage wrapper
│   │   │   ├── auth_service.dart     ← Session management
│   │   │   └── connectivity_service.dart
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   ├── app_spacing.dart
│   │   │   └── app_theme.dart
│   │   └── utils/
│   │       ├── helpers.dart
│   │       ├── validators.dart
│   │       └── constants.dart
│   │
│   ├── routes/
│   │   ├── app_routes.dart    ← Route name constants
│   │   └── app_pages.dart     ← GetPage definitions + binding pairs
│   │
│   ├── translations/          ← i18n string maps (flutter_localizations + intl)
│   │   ├── en_us.dart
│   │   └── app_translations.dart
│   │
│   └── modules/               ← Feature modules (one folder per screen/flow)
│       ├── splash/
│       │   ├── bindings/splash_binding.dart
│       │   ├── controllers/splash_controller.dart
│       │   └── views/splash_view.dart
│       │
│       ├── auth/
│       │   ├── bindings/auth_binding.dart
│       │   ├── controllers/auth_controller.dart
│       │   ├── models/user_model.dart
│       │   ├── repositories/auth_repository.dart
│       │   └── views/login_view.dart
│       │
│       ├── home/
│       │   ├── bindings/home_binding.dart
│       │   ├── controllers/home_controller.dart
│       │   ├── models/item_model.dart
│       │   ├── repositories/home_repository.dart
│       │   └── views/home_view.dart
│       │
│       └── settings/
│           ├── bindings/settings_binding.dart
│           ├── controllers/settings_controller.dart
│           └── views/settings_view.dart
│
├── test/
├── pubspec.yaml
└── analysis_options.yaml
```

---

## Key Dependencies

### Core

| Package | Version | Purpose |
|---|---|---|
| `get` | 4.7.3 | State management, navigation, DI |
| `flutter_localizations` | SDK | Built-in i18n support |
| `intl` | 0.20.2 | Date/number formatting + locale |

### Networking

| Package | Version | Purpose |
|---|---|---|
| `dio` | 5.9.2 | HTTP client |
| `pretty_dio_logger` | 1.4.0 | Colour-coded request/response logging |
| `connectivity_plus` | 7.1.1 | Network connectivity monitoring |

### Storage & Security

| Package | Version | Purpose |
|---|---|---|
| `flutter_secure_storage` | 10.3.1 | AES-encrypted key-value storage |
| `shared_preferences` | 2.5.5 | Lightweight persistent key-value store |
| `crypto` | 3.0.7 | SHA / MD5 hashing utilities |

### UI & UX

| Package | Version | Purpose |
|---|---|---|
| `google_fonts` | 8.1.0 | Google Fonts integration |
| `flutter_svg` | 2.3.0 | SVG rendering |
| `iconsax` | 0.0.8 | Iconsax icon library |
| `cached_network_image` | 3.4.1 | Async network image loading with cache |
| `flex_color_picker` | 3.7.2 | Full-featured colour picker widget |

### Device Features

| Package | Version | Purpose |
|---|---|---|
| `mobile_scanner` | 7.2.0 | Camera-based barcode & QR scanning |
| `share_plus` | 12.0.2 | Native share sheet integration |

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.35.6`
- Dart SDK `>=3.9.0 <4.0.0`
- Android Studio or VS Code with Flutter & Dart plugins

### Clone & Run

```bash
# Clone the template
git clone https://github.com/habibakij/getx_templete.git my_app
cd my_app

# Install dependencies
flutter pub get

# Run on connected device or emulator
flutter run
```

### Rename the Project

Update the `name` field in `pubspec.yaml` and run the rename across native folders:

```bash
# Option 1: use the rename package
dart pub global activate rename
rename setAppName --targets android,ios --value "My App"
rename setBundleId --targets android,ios --value "com.mycompany.myapp"
```

---

## How to Add a New Module

Follow these steps to add any new feature screen:

**1. Create the folder structure**

```
lib/modules/my_feature/
├── bindings/my_feature_binding.dart
├── controllers/my_feature_controller.dart
├── models/my_feature_model.dart
├── repositories/my_feature_repository.dart
└── views/my_feature_view.dart
```

**2. Define the controller**

```dart
class MyFeatureController extends GetxController {
  final _repository = Get.find<MyFeatureRepository>();
  final data = <MyFeatureModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    data.value = await _repository.fetchData();
    isLoading.value = false;
  }
}
```

**3. Create the binding**

```dart
class MyFeatureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyFeatureRepository>(() => MyFeatureRepository());
    Get.lazyPut<MyFeatureController>(() => MyFeatureController());
  }
}
```

**4. Register the route**

```dart
// routes/app_routes.dart
static const myFeature = '/my-feature';

// routes/app_pages.dart
GetPage(
  name: Routes.myFeature,
  page: () => const MyFeatureView(),
  binding: MyFeatureBinding(),
),
```

**5. Navigate to it**

```dart
Get.toNamed(Routes.myFeature);
```

---

## Supported Platforms

| Platform | Supported |
|---|---|
| Android | ✅ |
| iOS | ✅ |
| Web | ✅ |
| Windows | ✅ |
| macOS | ✅ |
| Linux | ✅ |

> **Note:** `mobile_scanner` requires a physical device with a camera for barcode scanning. `flutter_secure_storage` uses platform-specific encrypted storage (Keychain on iOS/macOS, Keystore on Android, libsecret on Linux).

---

## Contributing

This is a personal boilerplate template. Feel free to fork and adapt it for your own projects. Pull requests with improvements to the base template structure are welcome.

---

## Credits

- GetX architecture pattern inspired by **[Kaue Murakami](https://github.com/kauemurakami)**
- Built with ❤️ using [Flutter](https://flutter.dev) and [GetX](https://pub.dev/packages/get)
