import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/core/constants.dart';
import 'package:mindmate/core/utils.dart';
import 'package:mindmate/features/auth/controllers/auth_controller.dart';
import 'package:mindmate/features/auth/widgets/forgot_password_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showPassword = false;
  bool keepLoggedIn = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLogin() async {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      // Riverpod para acceder al AuthController
      final user = await ref
          .read(authControllerProvider.notifier)
          .loginUser(email: email, password: password);

      if (user != null && context.mounted) {
        // Guardar las preferencias de sesión
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('keepLoggedIn', keepLoggedIn);
        
        context.go('/home');
        
      } else {
        if (context.mounted) {
          showSnackBar(context, 'Correo o contrasena incorrectos.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo de email
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, introduce tu email';
              }
              if (!isValidEmail(value)) {
                return 'Formato de email invalido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Campo de contraseña
          TextFormField(
            controller: passwordController,
            obscureText: !showPassword,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              border: const OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Mínimo 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Checkbox para mantener sesión iniciada
          CheckboxListTile(
            title: const Text('Mantener sesión iniciada'),
            value: keepLoggedIn,
            activeColor: AppColors.primary,
            onChanged: (value) {
              setState(() {
                keepLoggedIn = value ?? false;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 16),

          // Botón para iniciar sesión
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radius),
                ),
              ),
              child: const Text('Iniciar sesión'),
            ),
          ),
          const SizedBox(height: 12),

          // Enlace "He olvidado mi contraseña"
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const ForgotPasswordDialog(),
              );
            },
            child: const Text(
              'He olvidado mi contraseña',
              style: TextStyle(color: AppColors.primaryDark),
            ),
          ),
        ],
      ),
    );
  }
}
