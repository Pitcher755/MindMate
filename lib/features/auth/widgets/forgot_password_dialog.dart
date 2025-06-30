import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindmate/core/utils.dart';

class ForgotPasswordDialog extends StatefulWidget {
  const ForgotPasswordDialog({ Key? key });

  @override
  _ForgotPasswordDialogState createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  final TextEditingController emailController = TextEditingController();
  bool isSending = false;

  Future<void> _sendResetEmail() async {
    final email = emailController.text.trim();

    if (!isValidEmail(email)) {
      showSnackBar(context, 'Introduce un correo válido');
      return;
    }

    setState(() => isSending = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) {
        context.pop();
        showSnackBar(context, 'Hemos enviado un enlace a tu correo');
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message ?? 'Algo salió mal');
    } finally {
      setState(() => isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Olvidaste tu contraseña?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Introduce tu correo y te enviaremos un enlace'),
          const SizedBox(height: 12),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Correo electrónico',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: isSending ? null : () => context.pop(), 
        child: const Text('Cancelar'),
        ),
        ElevatedButton(onPressed: isSending ? null : _sendResetEmail, 
        child: const Text('Enviar enlace'),
        ),
      ],
    );
  }
}