// 📄 utils.dart
// Funciones de utilidad que pueden ser usadas desde distintas partes de la app.
// Aquí puedes meter cosas como validaciones, formateadores, helpers, etc.

import 'package:flutter/material.dart';

// Muestra un snackbar con un mensaje. Útil para feedback al usuario.
void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ),
  );
}

// Valida una dirección de correo electrónico simple.
bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  return emailRegex.hasMatch(email);
}

// Verificar si la contraseña es válida
bool isValidPassword(String password) {
  final hasMinLength = password.length >= 6;
  final hasLetterOrNumber = RegExp(r'[A_Za-z0-9]').hasMatch(password);
  return hasMinLength && hasLetterOrNumber;
}
