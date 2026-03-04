// Shared app configuration - source of truth for both iOS and Android.
// Used for app name, colors, endpoints, feature flags, and build variants.

/// Build environment: dev, stage, prod
enum AppEnvironment {
  dev,
  stage,
  prod,
}

/// App configuration constants.
class AppConfig {
  AppConfig._();

  /// App display name (used in app bar, about screens)
  static const String appName = 'Mount Diablo';

  /// Full app title (e.g., for store listing)
  static const String appTitle = 'Mount Diablo Contra Costa County';

  /// Bundle/package identifier
  static const String bundleId = 'com.gphelps.mountdiablo';

  /// Current environment (set via --dart-define or default)
  static AppEnvironment get environment {
    const env = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'prod',
    );
    switch (env) {
      case 'dev':
        return AppEnvironment.dev;
      case 'stage':
        return AppEnvironment.stage;
      default:
        return AppEnvironment.prod;
    }
  }

  /// Base API/endpoint URL (placeholder for future use)
  static String get baseUrl {
    switch (environment) {
      case AppEnvironment.dev:
        return 'https://dev.example.com';
      case AppEnvironment.stage:
        return 'https://stage.example.com';
      case AppEnvironment.prod:
        return 'https://api.example.com';
    }
  }

  /// Feature flags (placeholders for future use)
  static const bool enableAnalytics = false;
  static const bool enableCrashReporting = false;
}
