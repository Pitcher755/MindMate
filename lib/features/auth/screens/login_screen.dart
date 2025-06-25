import 'package:flutter/material.dart';
import 'package:mindmate/core/app_colors.dart';
import 'package:mindmate/core/constants.dart';
import 'package:mindmate/features/auth/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Bienvenid@ de nuevo'),
        backgroundColor: AppColors.primary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Logo o imágen decorativa ********* TEMPORAL *********
                  Image.asset("assets/images/home_image.png", height: 160),
                  const SizedBox(height: 24),

                  // Formulario email y contraseña
                  const LoginForm(),
                  const SizedBox(height: 24),

                  // Separador visual
                  const Text("o", style: TextStyle(fontSize: 16, color: Colors.black54)),
                  const SizedBox(height: 16),

                  // Botón de Google
                  // const GoogleLoadingButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
