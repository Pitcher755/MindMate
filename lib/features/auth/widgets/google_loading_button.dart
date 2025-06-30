import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/core/utils.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleLoadingButton extends ConsumerStatefulWidget {
  final bool keepLoggedIn;

  const GoogleLoadingButton({super.key, required this.keepLoggedIn});

  @override
  ConsumerState<GoogleLoadingButton> createState() =>
      _GoogleLoadingButtonState();
}

class _GoogleLoadingButtonState extends ConsumerState<GoogleLoadingButton> {
  bool isLoading = false;

  void _onGoogleSignIn() async {
    setState(() => isLoading = true);

    // Iniciar sesión con Google
    final user = await ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle();

    if (user != null) {
      // Guardar preferencia de mantener sesión iniciada
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('keepLoggedIn', widget.keepLoggedIn);

      // Comprobar si tiene documento en Firestore
      final exists = await ref
          .read(authControllerProvider.notifier)
          .checkUserDocumentExists(user.uid);

      if (!mounted) return;

      if (exists) {
        // Usuario ya está registrado -> HomeScreen
        context.go('/home');
      } else {
        // Usuario nuevo -> Continuar registro (formulario)
        context.go('/register'); //***********************REVISAR*********** */
      }
    } else {
      if (mounted) {
        showSnackBar(context, 'Error al iniciar sesión con Google');
      }
    }

    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : _onGoogleSignIn,
      icon: Image.asset("assets/icons/google.png", height: 24),
      label: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.white,
              ),
            )
          : const Text('Continuar con Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
        ),
        side: const BorderSide(color: AppColors.primary),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
