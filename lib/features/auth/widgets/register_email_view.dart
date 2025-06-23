import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/core/constants.dart';
import 'package:mindmate/core/utils.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';

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

  void _registerWithEmail() {
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

    // Llama al controlador para registrar
    ref
        .read(authControllerProvider.notifier)
        .registerUser(
          context: context,
          email: email,
          password: password,
          onSuccess: widget.onNext, // Pasa a la siguiente pantalla si va bien
        );
  }

  void _registerWithGoogle() {
    ref
        .read(authControllerProvider.notifier)
        .signInWithGoogle(context: context, onSuccess: widget.onNext);
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
                OutlinedButton.icon(
                  onPressed: _registerWithGoogle,
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Registrarme con google'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
