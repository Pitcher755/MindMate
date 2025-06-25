// 📄 constants.dart
// Este archivo contiene constantes globales que usaremos en toda la app.
// Las constantes ayudan a evitar errores por nombres repetidos o mal escritos,
// y hacen que el código sea más limpio y mantenible.


/// Tamaños usados en padding, márgenes, iconos, etc.
class AppSizes {
  static const double padding = 16.0;
  static const double radius = 12.0;
  static const double iconSize = 24.0;
}

/// Nombres de colecciones de Firestore centralizados.
class FirestoreCollections {
  static const String users = 'users';
  static const String exercises = 'exercises';
  static const String motivationalQuotes = 'motivationalQuotes';
  static const String techniques = 'techniques';
  static const String sounds = 'sounds';
  static const String dailyChallenges = 'dailyChallenges';
  static const String achievements = 'achievements';
}

/// Rutas nombradas para la navegación (las usaremos en go_router)
class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String home = '/home';
  static const String profileview = '/profileview';
}
