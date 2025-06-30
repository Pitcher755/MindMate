// 📄 app_router.dart
// Configuración de las rutas de navegación usando go_router.

import 'package:go_router/go_router.dart';
import 'package:mindmate/features/auth/screens/login_screen.dart';
import 'package:mindmate/features/auth/screens/register_screen.dart';
import 'package:mindmate/features/auth/screens/welcome_screen.dart';
import 'package:mindmate/features/home/home_screen.dart';
import '../core/constants.dart';
import '../features/splash/splash_screen.dart';

final GoRouter appRouter = GoRouter(
  // Ruta inicial cuando se abre la app
  initialLocation: AppRoutes.splash,

  // Definimos las rutas disponibles en la app
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.welcome,
      builder: (context, state) => const WelcomeScreen(),
    ),

    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),

    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),

    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
