// Environment switch: dev / stage / prod
// Run with: flutter run --dart-define=APP_ENV=dev

import 'app_config.dart';

/// Returns true when running in development
bool get isDev => AppConfig.environment == AppEnvironment.dev;

/// Returns true when running in staging
bool get isStage => AppConfig.environment == AppEnvironment.stage;

/// Returns true when running in production
bool get isProd => AppConfig.environment == AppEnvironment.prod;
