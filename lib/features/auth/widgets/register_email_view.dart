import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/core/constants.dart';
import 'package:mindmate/core/utils.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';
import 'package:mindmate/features/auth/widgets/google_loading_button.dart';

class RegisterEmailView extends ConsumerStatefulWidget {
  final VoidCallback onNext;
  const RegisterEmailView({super.key, required this.onNext});

  @override
  ConsumerState<RegisterEmailView> createState() => _RegisterEmailViewState();
}

class _RegisterEmailViewState extends ConsumerState<RegisterEmailView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Future<void> _registerWithEmail() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (!isValidEmail(email)) {
      showSnackBar(context, 'Introduce un email válido.');
      return;
    }
    if (!isValidPassword(password)) {
      showSnackBar(
        context,
        'La contraseña debe tener al menos 6 caracteres y una letra o número.',
      );
      return;
    }

    if (password != confirmPassword) {
      showSnackBar(context, 'Las contraseñas no coinciden.message');
      return;
    }

    // Muestra indicador de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await ref
          .read(authControllerProvider.notifier)
          .registerUser(
            email: email,
            password: password,
            context: context,
            onSuccess: () {
              if (mounted) {
                // Cerrar el diálogo de carga
                Navigator.of(context).pop();
                // Navegar
                widget.onNext();
              }
            },
          );
    } catch (e) {
      if (mounted) {
        // Cierra el diálogo de carga en caso de error
        Navigator.of(context).pop();
        showSnackBar(context, "Error al registrar: ${e.toString()}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.padding * 1.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Crear cuenta',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  decoration: InputDecoration(
                    labelText: 'repetir contraseña',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirm = !_obscureConfirm);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _registerWithEmail,
                  child: const Text('Registrarme'),
                ),
                const SizedBox(height: 12),
                // Separador visual
                const Text(
                  "o",
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 16),

                // Botón de Google
                const GoogleLoadingButton(keepLoggedIn: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
